import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart'
    hide Listener, WidgetBuilder, ValueWidgetBuilder;

import 'typedefs.dart';

class ValueListenableConsumer<T> extends StatefulWidget {
  const ValueListenableConsumer({
    super.key,
    required this.valueListenable,
    required this.listener,
    required this.builder,
    this.child,
  });

  final ValueListenable<T> valueListenable;
  final ValueListener<T> listener;
  final ValueWidgetBuilder<T> builder;
  final Widget? child;

  @override
  State<ValueListenableConsumer> createState() =>
      _ValueListenableConsumerState<T>();
}

class _ValueListenableConsumerState<T> extends State<ValueListenableConsumer> {
  late T _value;

  void _listener() {
    final value = widget.valueListenable.value;
    widget.listener(value);
    setState(() => _value = value);
  }

  @override
  void initState() {
    super.initState();
    _value = widget.valueListenable.value;
    widget.valueListenable.addListener(_listener);
  }

  @override
  void didUpdateWidget(covariant ValueListenableConsumer oldWidget) {
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
  Widget build(BuildContext context) =>
      widget.builder(context, _value, widget.child);
}
