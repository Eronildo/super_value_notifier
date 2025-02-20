import 'package:flutter/widgets.dart';

typedef WidgetBuilder = Widget Function(BuildContext context);
typedef Listener = void Function();

typedef ValueWidgetBuilder<T> = Widget Function(BuildContext context, T value);
typedef ValueListener<T> = void Function(T value);
