import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart'
    hide Listener, WidgetBuilder, ValueWidgetBuilder;

import 'typedefs.dart';

class ValueListenableConsumer<T> extends _ValueConsumerBase<T> {
  const ValueListenableConsumer({
    super.key,
    required super.valueListenable,
    required this.listener,
    required this.builder,
  });

  final ValueListener<T> listener;
  final ValueWidgetBuilder<T> builder;

  @override
  void listen(value) => listener(value);

  @override
  Widget build(BuildContext context, T value) => builder(context, value);
}

abstract class _ValueConsumerBase<T> extends StatefulWidget {
  const _ValueConsumerBase({
    super.key,
    required this.valueListenable,
  });

  final ValueListenable<T> valueListenable;

  void listen(T value);
  Widget build(BuildContext context, T value);

  @override
  State<_ValueConsumerBase> createState() => _ValueConsumerBaseState<T>();
}

class _ValueConsumerBaseState<T> extends State<_ValueConsumerBase> {
  late T _value;

  void _listener() {
    final value = widget.valueListenable.value;
    widget.listen(value);
    setState(() => _value = value);
  }

  @override
  void initState() {
    super.initState();
    _value = widget.valueListenable.value;
    widget.valueListenable.addListener(_listener);
  }

  @override
  void didUpdateWidget(covariant _ValueConsumerBase oldWidget) {
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
  Widget build(BuildContext context) => widget.build(context, _value);
}
