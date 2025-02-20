import 'package:flutter/widgets.dart' hide Listener, WidgetBuilder;

import 'typedefs.dart';

class ListenableListener extends _ListenerBase {
  const ListenableListener({
    super.key,
    required super.listenable,
    required this.listener,
    required super.child,
  });

  final Listener listener;

  @override
  void listen() => listener();
}

abstract class _ListenerBase extends StatefulWidget {
  const _ListenerBase({
    super.key,
    required this.listenable,
    required this.child,
  });

  final Listenable listenable;
  final Widget child;
  void listen();

  @override
  State<_ListenerBase> createState() => _ListenerBaseState();
}

class _ListenerBaseState extends State<_ListenerBase> {
  void _listener() {
    widget.listen();
  }

  @override
  void initState() {
    super.initState();
    widget.listenable.addListener(_listener);
  }

  @override
  void didUpdateWidget(covariant _ListenerBase oldWidget) {
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
