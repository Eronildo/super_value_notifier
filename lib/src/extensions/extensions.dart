import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide ValueWidgetBuilder;
import 'package:flutter/scheduler.dart';

import '../widgets/widgets.dart';

extension ValueNotifierX<T> on ValueNotifier<T> {
  void setValue(T value) {
    this.value = value;
  }
}

extension ValueListenableX<T> on ValueListenable<T> {
  ValueListenableBuilder<T> valueBuilder(ValueWidgetBuilder<T> builder) =>
      ValueListenableBuilder<T>(
        valueListenable: this,
        builder: builder,
      );

  ValueListenableListener<T> valueListener({
    required ValueListener<T> listener,
    required Widget child,
  }) =>
      ValueListenableListener<T>(
        valueListenable: this,
        listener: listener,
        child: child,
      );

  ValueListenableConsumer<T> valueConsumer({
    required ValueListener<T> listener,
    required ValueWidgetBuilder<T> builder,
  }) =>
      ValueListenableConsumer<T>(
        valueListenable: this,
        listener: listener,
        builder: builder,
      );

  T watch(BuildContext context) {
    void listener() {
      _rebuild(context);
      removeListener(listener);
    }

    addListener(listener);
    return value;
  }

  void _rebuild(BuildContext context) async {
    final element = WeakReference(context as Element);
    final target = element.target;
    if (target == null) {
      return;
    }
    if (!target.mounted) return;
    if (target.dirty) return;
    if (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle) {
      await SchedulerBinding.instance.endOfFrame;
    }
    if (!target.mounted) return;
    target.markNeedsBuild();
  }
}
