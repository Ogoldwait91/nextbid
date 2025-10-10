import 'dart:io';
import 'package:path_provider/path_provider.dart';

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
