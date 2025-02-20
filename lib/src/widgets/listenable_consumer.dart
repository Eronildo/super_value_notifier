import 'package:flutter/widgets.dart' hide Listener, WidgetBuilder;

import 'typedefs.dart';

class ListenableConsumer extends _ConsumerBase {
  const ListenableConsumer({
    super.key,
    required super.listenable,
    required this.listener,
    required this.builder,
  });

  final Listener listener;
  final WidgetBuilder builder;

  @override
  void listen() => listener();

  @override
  Widget build(BuildContext context) => builder(context);
}

abstract class _ConsumerBase extends StatefulWidget {
  const _ConsumerBase({
    super.key,
    required this.listenable,
  });

  final Listenable listenable;

  void listen();
  Widget build(BuildContext context);

  @override
  State<_ConsumerBase> createState() => _ConsumerBaseState();
}

class _ConsumerBaseState extends State<_ConsumerBase> {
  void _listener() {
    widget.listen();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.listenable.addListener(_listener);
  }

  @override
  void didUpdateWidget(covariant _ConsumerBase oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.listenable != oldWidget.listenable) {
      oldWidget.listenable.removeListener(_listener);
      widget.listenable.addListener(_listener);
    }
  }

  @override
  void dispose() {
    widget.listenable.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.build(context);
}
