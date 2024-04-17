Map<String, T> listToMap<T>(
  List<T> list,
  String Function(T) keygen,
) {
  return {
    for (final el in list) keygen(el): el,
  };
}

Map<String, U> listToMapWithValue<T, U>(
  List<T> list,
  String Function(T) keygen,
  U Function(T) valuegen,
) {
  return {
    for (final el in list) keygen(el): valuegen(el),
  };
}
