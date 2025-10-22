class JssValidator {
  static void check({required List<List<String>> groups}) {
    if (groups.length > 15) {
      throw ArgumentError('Max 15 bid groups exceeded');
    }
    for (final g in groups) {
      if (g.length > 40) {
        throw ArgumentError('Max 40 rows per group exceeded');
      }
    }
  }
}
