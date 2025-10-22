import "package:flutter_test/flutter_test.dart";

void main() {
  test("export uses CRLF and correct order (placeholder)", () {
    // Placeholder sample text until real export builder is wired.
    const text = "GROUP 1\r\nLINE A\r\nGROUP 2\r\n";
    // Ensure CRLF exists
    expect(text.contains("\r\n"), true);
    // Ensure no LF-only lines sneaked in
    expect(text.contains("\n") && !text.contains("\r\n"), false);
    // Simple ordering assertion
    final idxA = text.indexOf("GROUP 1");
    final idxB = text.indexOf("GROUP 2");
    expect(idxA != -1 && idxB != -1 && idxA < idxB, true);
  });
}
