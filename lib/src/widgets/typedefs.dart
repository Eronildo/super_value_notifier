import 'package:flutter/widgets.dart';

typedef WidgetBuilder = Widget Function(BuildContext context, Widget? child);
typedef Listener = void Function();

typedef ValueWidgetBuilder<T> = Widget Function(
  BuildContext context,
  T value,
  Widget? child,
);
typedef ValueListener<T> = void Function(T value);
