import "dart:convert";
import "dart:io";
import "package:path/path.dart" as p;

/// Writes raw JSS `text` into project\\exports with UTF-8 (no BOM) and CRLF endings.
/// Non-destructive: creates directory if missing.
Future<File> exportRawText(String filename, String text) async {
  final dir = Directory(p.join(Directory.current.path, "exports"));
  if (!await dir.exists()) {
    await dir.create(recursive: true);
  }
  // Normalise endings to CRLF for safety
  final crlf = text
      .replaceAll("\r\n", "\n")
      .replaceAll("\r", "\n")
      .replaceAll("\n", "\r\n");
  final file = File(p.join(dir.path, filename));
  await file.writeAsBytes(utf8.encode(crlf));
  return file;
}
