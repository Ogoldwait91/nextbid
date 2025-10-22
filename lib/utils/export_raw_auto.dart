import "dart:convert";
import "dart:io";
import "package:nextbid_demo/utils/file_naming.dart";

/// Writes [text] to the next auto-named file (UTF-8, CRLF ensured).
Future<File> exportRawTextAuto({
  required String text,
  String crew = "USER",
  String? month,
  Directory? baseDir,
}) async {
  // normalise line endings to CRLF with trailing CRLF
  final lf = text.replaceAll("\r\n", "\n").replaceAll("\r", "\n");
  final crlf =
      lf.replaceAll("\n", "\r\n") +
      (lf.isEmpty ? "" : (lf.endsWith("\n") ? "" : "\r\n"));
  final file = await nextExportFilePath(
    crew: crew,
    month: month,
    baseDir: baseDir,
  );
  await file.writeAsBytes(utf8.encode(crlf), flush: true);
  return file;
}
