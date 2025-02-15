import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

/// {@template computed_listenable}
/// Data is often derived from other pieces of existing data. The `computed` function lets you combine the values of multiple listenables into a new listenable that can be reacted to, or even used by additional computed listenables. When the listenables accessed from within a computed callback change, the computed callback is re-executed and its new return value becomes the computed listenable's value.
///
/// > `Computed` class extends the [ChangeNotifier] class, so you can use it anywhere you would use a listenable.
///
/// ```dart
/// import 'package:super_value_notifier/super_value_notifier.dart';
///
/// final name = ValueNotifier("Jane");
/// final surname = ValueNotifier("Doe");
///
/// final fullName = computedListenable([name, surname], () => name.value + " " + surname.value);
///
/// // Logs: "Jane Doe"
/// print(fullName.value);
///
/// // Updates flow through computed, but only if someone
/// // subscribes to it. More on that later.
/// name.value = "John";
/// // Logs: "John Doe"
/// print(fullName.value);
/// ```
///
/// Any listenable that is accessed inside the `computed`'s callback function will be automatically subscribed to and tracked as a dependency of the computed listenable.
///
/// > Computed listenables are both lazily evaluated and memoized
/// {@endtemplate}
ComputedListenable<T> computedListenable<T>(
  List<Listenable?> listenables,
  T Function() computeFn,
) {
  return ComputedListenable<T>(Listenable.merge(listenables), computeFn);
}

/// {@macro computed_listenable}
class ComputedListenable<T> extends ChangeNotifier
    implements ValueListenable<T> {
  /// {@macro computed_listenable}
  ComputedListenable(this.listenable, this.compute) {
    _updateValue();
    listenable.addListener(_updateValue);
  }

  final Listenable listenable;
  final T Function() compute;
  final _equality = const DeepCollectionEquality();

  T? _value;

  void _updateValue() {
    value = compute();
  }

  @override
  T get value => _value!;

  set value(T newValue) {
    if (_equality.equals(_value, newValue)) {
      return;
    }
    _value = newValue;
    notifyListeners();
  }

  @override
  void dispose() {
    listenable.removeListener(_updateValue);
    super.dispose();
  }
}
