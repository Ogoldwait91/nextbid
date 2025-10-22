import "dart:convert";
import "dart:io";

/// Build JSS text with CRLF (\r\n) line endings.
/// `groups` is a list of groups, each group is a list of lines (strings).
String buildJssText({required int credit, required List<List<String>> groups}) {
  final lines = <String>[];
  lines.add("GLOBAL SETTINGS");
  lines.add("CREDIT=$credit");
  lines.add(""); // blank line between GLOBAL and groups
  for (var i = 0; i < groups.length; i++) {
    lines.add("GROUP ${i + 1}");
    lines.addAll(groups[i]);
    lines.add(""); // blank line after each group
  }
  // Ensure CRLF for JSS compatibility
  return lines.join("\r\n");
}

/// Save text as UTF-8 to a file in the given directory.
Future<File> saveJssText({
  required String content,
  required Directory directory,
  String filename = "nextbid_export.txt",
}) async {
  final pathSep = Platform.pathSeparator;
  final file = File("${directory.path}$pathSep$filename");
  return file.writeAsString(content, mode: FileMode.write, encoding: utf8);
}

/// Ensure CRLF line endings with a trailing CRLF (JSS-friendly).
String ensureCrlfAll(String s) {
  final lf = s.replaceAll("\r\n", "\n").replaceAll("\r", "\n");
  final crlf = lf.replaceAll("\n", "\r\n");
  return crlf.endsWith("\r\n") ? crlf : ("$crlf\r\n");
}
