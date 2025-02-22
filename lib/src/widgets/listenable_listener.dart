import 'package:flutter/widgets.dart' hide Listener, WidgetBuilder;

import 'typedefs.dart';

class ListenableListener extends StatefulWidget {
  const ListenableListener({
    super.key,
    required this.listenable,
    required this.listener,
    required this.child,
  });

  final Listenable listenable;
  final Listener listener;
  final Widget child;

  @override
  State<StatefulWidget> createState() => _ListenableListenerState();
}

class _ListenableListenerState extends State<ListenableListener> {
  void _listener() {
    widget.listener();
  }

  @override
  void initState() {
    super.initState();
    widget.listenable.addListener(_listener);
  }

  @override
  void didUpdateWidget(covariant ListenableListener oldWidget) {
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
  Widget build(BuildContext context) => widget.child;
}
