import 'package:flutter/widgets.dart' hide Listener, WidgetBuilder;

import 'typedefs.dart';

class ListenableConsumer extends StatefulWidget {
  const ListenableConsumer({
    super.key,
    required this.listenable,
    required this.listener,
    required this.builder,
    this.child,
  });

  final Listenable listenable;
  final Listener listener;
  final WidgetBuilder builder;
  final Widget? child;

  @override
  State<StatefulWidget> createState() => _ListenableConsumerState();
}

class _ListenableConsumerState extends State<ListenableConsumer> {
  void _listener() {
    widget.listener();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.listenable.addListener(_listener);
  }

  @override
  void didUpdateWidget(covariant ListenableConsumer oldWidget) {
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
  Widget build(BuildContext context) => widget.builder(context, widget.child);
}
