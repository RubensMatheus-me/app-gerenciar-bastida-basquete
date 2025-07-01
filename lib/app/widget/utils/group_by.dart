extension GroupBy<K, V> on Iterable<V> {
  Map<K, List<V>> groupListsBy(K Function(V) keyFn) {
    final Map<K, List<V>> result = {};
    for (var element in this) {
      final key = keyFn(element);
      result.putIfAbsent(key, () => []).add(element);
    }
    return result;
  }
}