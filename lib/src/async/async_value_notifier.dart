import 'package:flutter/foundation.dart';

import 'async_value.dart';

/// {@template async_value_notifier}
/// [AsyncValueNotifier] return an [AsyncValue].
///
/// ```dart
/// /// A [AsyncValueNotifier] that asynchronously exposes the current user
/// final asyncUser = AsyncValueNotifier<User>(() async {
///   // fetch the user
/// });
///
/// class Example extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///
///     return ValueListenableBuilder(
///        valueListenable: asyncUser,
///        builder: (context, asyncValue, child) => asyncValue.when(
///          data: (user) => Text('Hello ${user.name}'),
///          loading: () => CircularProgressIndicator(),
///          error: (error, stack) => Text('Oops, something unexpected happened'),
///       ),
///     );
///   }
/// }
/// ```
///
/// ## .refresh()
///
/// Refresh the future value by setting `isLoading` to true, but maintain the current state (AsyncData, AsyncLoading, AsyncError).
///
/// ```dart
/// final s = AsyncValueNotifier(() => Future(() => 1));
/// s.refresh();
/// print(s.value.isRefreshing); // true
/// ```
///
/// ## .reload()
///
/// Reload the future value by setting the state to `AsyncLoading`.
///
/// ```dart
/// final s = AsyncValueNotifier(() => Future(() => 1));
/// s.reload();
/// print(s.value.isReloading); // true
/// ```
/// {@endtemplate}
class AsyncValueNotifier<T> extends ChangeNotifier
    implements ValueListenable<AsyncValue<T>> {
  AsyncValueNotifier(Future<T> Function() create) : _create = create {
    if (kFlutterMemoryAllocationsEnabled) {
      ChangeNotifier.maybeDispatchObjectCreation(this);
    }
    _initialize();
  }

  AsyncValue<T> _asyncValue = const AsyncLoading();
  late final Future<T> Function() _create;

  Future<void> _initialize(
      {Future<void> Function()? futureFn, bool isRefresh = false}) async {
    try {
      _value = AsyncLoading<T>().copyWithPrevious(value, isRefresh: isRefresh);

      await futureFn?.call();

      _create().then<AsyncValue>(
        (newValue) => _value = AsyncData<T>(newValue),
        onError: (Object error, StackTrace stackTrace) => _value =
            AsyncValue<T>.error(error, stackTrace)
                .copyWithPrevious(value, isRefresh: isRefresh),
      );
    } catch (error, stackTrace) {
      _value = AsyncValue<T>.error(error, stackTrace)
          .copyWithPrevious(value, isRefresh: isRefresh);
    }
  }

  Future<void> reload() async {
    _initialize();
  }

  Future<void> refresh() async {
    _initialize(isRefresh: true);
  }

  Future<void> refreshWhen(Future<void> Function() futureFn) async {
    _initialize(futureFn: futureFn, isRefresh: true);
  }

  @override
  AsyncValue<T> get value => _asyncValue;

  set _value(AsyncValue<T> newValue) {
    _asyncValue = newValue;
    notifyListeners();
  }

  Future<void> guard(
    Future<T> Function() future, {
    bool isRefresh = true,
  }) async {
    _value = AsyncValue<T>.loading().copyWithPrevious(
      value,
      isRefresh: isRefresh,
    );
    try {
      _value = AsyncValue.data(await future());
    } catch (err, stack) {
      _value = AsyncValue.error(err, stack);
    }
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';
}

AsyncValueNotifier<V> Function(Arg arg) asyncValueNotifierFamily<V, Arg>(
  AsyncValueNotifier<V> Function(Arg arg) create,
) =>
    (arg) => create(arg);
