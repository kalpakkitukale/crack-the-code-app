/// Collection Extensions
/// Safe access methods for collections to prevent crashes on empty collections
library;

/// Extension methods for safe List access
extension SafeListAccess<T> on List<T> {
  /// Returns the first element or null if the list is empty
  T? get firstOrNull => isEmpty ? null : first;

  /// Returns the last element or null if the list is empty
  T? get lastOrNull => isEmpty ? null : last;

  /// Returns the element at the given index or null if out of bounds
  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  /// Returns the first element matching the predicate or null if none found
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  /// Returns the last element matching the predicate or null if none found
  T? lastWhereOrNull(bool Function(T element) test) {
    T? result;
    for (final element in this) {
      if (test(element)) result = element;
    }
    return result;
  }

  /// Returns a new list with the element at index replaced, or the same list if index is out of bounds
  List<T> safeReplaceAt(int index, T newValue) {
    if (index < 0 || index >= length) return this;
    final newList = List<T>.from(this);
    newList[index] = newValue;
    return newList;
  }
}

/// Extension methods for safe Iterable access
extension SafeIterableAccess<T> on Iterable<T> {
  /// Returns the first element or null if the iterable is empty
  T? get firstOrNull => isEmpty ? null : first;

  /// Returns the last element or null if the iterable is empty
  T? get lastOrNull => isEmpty ? null : last;

  /// Returns the first element matching the predicate or null if none found
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

/// Extension methods for safe Map access
extension SafeMapAccess<K, V> on Map<K, V> {
  /// Returns the value for the key or null if not found (same as [])
  V? getOrNull(K key) => this[key];

  /// Returns the value for the key or the default value if not found
  V getOrDefault(K key, V defaultValue) => this[key] ?? defaultValue;

  /// Returns the first entry or null if the map is empty
  MapEntry<K, V>? get firstEntryOrNull =>
      isEmpty ? null : entries.first;

  /// Returns the first key or null if the map is empty
  K? get firstKeyOrNull => isEmpty ? null : keys.first;

  /// Returns the first value or null if the map is empty
  V? get firstValueOrNull => isEmpty ? null : values.first;
}

/// Extension methods for safe Set access
extension SafeSetAccess<T> on Set<T> {
  /// Returns the first element or null if the set is empty
  T? get firstOrNull => isEmpty ? null : first;

  /// Returns the last element or null if the set is empty
  T? get lastOrNull => isEmpty ? null : last;

  /// Returns the first element matching the predicate or null if none found
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
