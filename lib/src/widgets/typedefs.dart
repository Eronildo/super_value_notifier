import 'package:flutter/widgets.dart';

typedef WidgetBuilder<T> = Widget Function(BuildContext context, T value);
typedef Listener<T> = void Function(T value);
