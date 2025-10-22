import "package:test/test.dart";

String joinAsCrlf(Iterable<String> lines) {
  final lf = lines.join("\n");
  final crlf = lf
      .replaceAll("\r\n", "\n")
      .replaceAll("\r", "\n")
      .replaceAll("\n", "\r\n");
  return crlf.endsWith("\r\n") ? crlf : ("$crlf\r\n");
}

void main() {
  test("joins lines with CRLF and trailing CRLF", () {
    final out = joinAsCrlf(["!GROUP 1", " SET CREDIT 500-540", "!END GROUP"]);
    expect(out.contains("\r\n"), isTrue);
    expect(out.endsWith("\r\n"), isTrue);
    // There should be exactly 3 CRLFs for 3 lines + trailing CRLF (total 3)
    final crlfCount = RegExp(r"\r\n").allMatches(out).length;
    expect(crlfCount, equals(3));
  });
}
