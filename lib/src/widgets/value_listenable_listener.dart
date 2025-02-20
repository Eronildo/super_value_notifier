import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' hide Listener, WidgetBuilder;

import 'typedefs.dart';

class ValueListenableListener<T> extends _ValueListenerBase<T> {
  const ValueListenableListener({
    super.key,
    required super.valueListenable,
    required this.listener,
    required super.child,
  });

  final ValueListener<T> listener;

  @override
  void listen(value) => listener(value);
}

abstract class _ValueListenerBase<T> extends StatefulWidget {
  const _ValueListenerBase({
    super.key,
    required this.valueListenable,
    required this.child,
  });

  final ValueListenable<T> valueListenable;
  final Widget child;
  void listen(T value);

  @override
  State<_ValueListenerBase> createState() => _ValueListenerBaseState();
}

class _ValueListenerBaseState extends State<_ValueListenerBase> {
  void _listener() {
    widget.listen(widget.valueListenable.value);
  }

  @override
  void initState() {
    super.initState();
    widget.valueListenable.addListener(_listener);
  }

  @override
  void didUpdateWidget(covariant _ValueListenerBase oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.valueListenable != oldWidget.valueListenable) {
      oldWidget.valueListenable.removeListener(_listener);
      widget.valueListenable.addListener(_listener);
    }
  }

  @override
  void dispose() {
    widget.valueListenable.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
