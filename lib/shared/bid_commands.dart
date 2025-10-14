/// Typed bid commands → single JSS lines via toJss().
abstract class BidCommand {
  String toJss();
}

class IncludePairing implements BidCommand {
  final List<String> ids;
  IncludePairing(this.ids);
  @override
  String toJss() => ids.isEmpty ? "" : "INCLUDE ${ids.join(",")}";
}

class AvoidPairing implements BidCommand {
  final List<String> ids;
  AvoidPairing(this.ids);
  @override
  String toJss() => ids.isEmpty ? "" : "AVOID ${ids.join(",")}";
}

class PreferDaysOff implements BidCommand {
  final List<String> days; // ["MON","TUE","WED","THU","FRI","SAT","SUN"]
  PreferDaysOff(this.days);
  @override
  String toJss() => days.isEmpty ? "" : "PREFER DAYS OFF: ${days.join(",")}";
}

class RequestReserve implements BidCommand {
  final String start;
  final int days;
  RequestReserve({required this.start, required this.days});
  @override
  String toJss() => "REQUEST RESERVE: $start x$days";
}

class TargetCreditHint implements BidCommand {
  final int credit;
  TargetCreditHint(this.credit);
  @override
  String toJss() => "TARGET CREDIT: $credit";
}

class RawJssLine implements BidCommand {
  final String line;
  RawJssLine(this.line);
  @override
  String toJss() => line;
}

/// Utility: map commands → non-empty JSS lines
List<String> commandsToLines(List<BidCommand> commands) =>
    commands.map((c) => c.toJss().trim()).where((s) => s.isNotEmpty).toList();
