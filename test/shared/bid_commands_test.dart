import "package:flutter_test/flutter_test.dart";
import "package:nextbid_demo/shared/bid_commands.dart"; // switch to relative if your package name differs

void main() {
  test("Include/Avoid pairing lines", () {
    expect(IncludePairing(["EZE01"]).toJss(), "INCLUDE EZE01");
    expect(AvoidPairing(["DXB12", "LAX03"]).toJss(), "AVOID DXB12,LAX03");
  });

  test("Days off + reserve + credit", () {
    expect(PreferDaysOff(["SAT", "SUN"]).toJss(), "PREFER DAYS OFF: SAT,SUN");
    expect(
      RequestReserve(start: "2025-11-10", days: 5).toJss(),
      "REQUEST RESERVE: 2025-11-10 x5",
    );
    expect(TargetCreditHint(50).toJss(), "TARGET CREDIT: 50");
  });

  test("commandsToLines filters blanks and trims", () {
    final lines = commandsToLines([
      IncludePairing(["EZE01"]),
      IncludePairing([]),
      RawJssLine("  RAW LINE  "),
    ]);
    expect(lines, ["INCLUDE EZE01", "RAW LINE"]);
  });
}
