class Jss {
  static String leave(int days) {
    final sign = days >= 0 ? '+' : '-';
    final magnitude = days.abs();
    return 'LEAVE $sign$magnitude';
  }

  static String credit(String pref) {
    switch (pref.toLowerCase()) {
      case 'high': return 'CREDIT HIGH';
      case 'low':  return 'CREDIT LOW';
      default:     return 'CREDIT NEUTRAL';
    }
  }
}

List<String> buildJss({
  required int leaveDays,
  required String creditPref, // 'high' | 'neutral' | 'low'
  List<String> groups = const [],
}) {
  final lines = <String>[];
  lines.add('BID START');
  lines.add(Jss.leave(leaveDays));
  lines.add(Jss.credit(creditPref));
  lines.addAll(groups);
  lines.add('BID END');
  return lines;
}
