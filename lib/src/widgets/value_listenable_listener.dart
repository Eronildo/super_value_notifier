import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' hide Listener, WidgetBuilder;

import 'typedefs.dart';

class ValueListenableListener<T> extends StatefulWidget {
  const ValueListenableListener({
    super.key,
    required this.valueListenable,
    required this.listener,
    required this.child,
  });
  final ValueListenable<T> valueListenable;
  final ValueListener<T> listener;
  final Widget child;
  @override
  State<StatefulWidget> createState() => _ValueListenableListenerState();
}

class _ValueListenableListenerState<T>
    extends State<ValueListenableListener<T>> {
  void _listener() {
    widget.listener(widget.valueListenable.value);
  }

  @override
  void initState() {
    super.initState();
    widget.valueListenable.addListener(_listener);
  }

  @override
  void didUpdateWidget(covariant ValueListenableListener<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.valueListenable != widget.valueListenable) {
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
