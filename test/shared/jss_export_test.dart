import "package:flutter_test/flutter_test.dart";
import "package:nextbid_demo/shared/jss_export.dart"; // if your package name differs, switch to relative: import "../../lib/shared/jss_export.dart";

void main() {
  test("buildJssText uses CRLF and expected structure", () {
    final text = buildJssText(
      credit: 50,
      groups: [
        ["INCLUDE EZE01", "AVOID DXB12"],
        ["PREFER DAYS OFF: SAT,SUN"],
      ],
    );

    // Must contain CRLFs
    expect(text.contains("\r\n"), true);
    // Must *not* contain lone LFs (every LF is paired with CR)
    expect(text.contains("\n") && !text.contains("\r\n"), false);

    // Structure
    expect(
      text.startsWith("GLOBAL SETTINGS\r\nCREDIT=50\r\n\r\nGROUP 1\r\n"),
      true,
    );
    expect(
      text.contains("\r\nGROUP 2\r\nPREFER DAYS OFF: SAT,SUN\r\n\r\n"),
      true,
    );
  });
}
