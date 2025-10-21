import "package:flutter_test/flutter_test.dart";
import "package:nextbid_demo/shared/jss_export.dart";

String _normalizeLF(String s) => s.replaceAll("\r\n", "\n").replaceAll("\r", "\n");
int _countCrlf(String s) => RegExp(r"\r\n").allMatches(s).length;

void main() {
  test("buildJssText uses CRLF and includes group content", () {
    // Minimal, known-good inputs for the current signature
    final out = buildJssText(
      credit: 520,
      groups: const [
        ["INCLUDE 1,2", "WAIVE LONGHAUL"],
      ],
    );

    // Hard requirement: CRLF present and ends with CRLF
    expect(_countCrlf(out) > 0, isTrue, reason: "No CRLF detected");
    expect(out.endsWith("\r\n"), isTrue, reason: "Output must end with CRLF");

    // Structure/content sanity (platform-stable via LF normalization)
    final norm = _normalizeLF(out);
    expect(norm.contains("INCLUDE 1,2\n"), isTrue, reason: "Missing INCLUDE line in order");
    expect(norm.contains("WAIVE LONGHAUL\n"), isTrue, reason: "Missing WAIVE line in order");

    // Credit sanity (don’t over-specify the exact wording)
    expect(out.contains("520"), isTrue, reason: "Credit value not present");
  });
}

