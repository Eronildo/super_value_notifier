import 'package:flutter/foundation.dart';

abstract class ListenableCubit<T> {
  ListenableCubit(T initalState) {
    _state = ValueNotifier<T>(initalState);
  }

  late final ValueNotifier<T> _state;
  ValueListenable<T> get listenable => _state;
  T get state => _state.value;

  @protected
  @visibleForTesting
  void emit(T state) {
    _state.value = state;
  }
}
