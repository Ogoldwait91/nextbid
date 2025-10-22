import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:path/path.dart' as p;

Future<File> exportBidText(String filename, List<String> lines) async {
  final dir = await getApplicationDocumentsDirectory();
  final path = '${dir.path}/$filename';

  // Strip trailing CR/LF from each input line; join with CRLF; ensure trailing CRLF.
  final joined = lines
      .map((l) => l.replaceAll(RegExp(r'[\r\n]+$'), ''))
      .join('\r\n');
  final normalized = '$joined\r\n';

  final file = File(path);
  return file.writeAsString(normalized, mode: FileMode.write, flush: true);
}

/// Writes a pretty-printed JSON sidecar into the same export directory.
Future<File> exportSidecarJson(
  String fileName,
  Map<String, dynamic> data,
) async {
  // Reuse whatever directory exportBidText uses
  final dir = await _ensureExportDir();
  final f = File(p.join(dir.path, fileName));
  final pretty = const JsonEncoder.withIndent('  ').convert(data);
  await f.writeAsString(pretty, encoding: utf8);
  return f;
}

Future<Directory> _ensureExportDir() async {
  // Dev-friendly location: project\exports  (works on Windows/macOS/Linux)
  final dir = Directory(p.join(Directory.current.path, 'exports'));
  if (!await dir.exists()) {
    await dir.create(recursive: true);
  }
  return dir;
}
