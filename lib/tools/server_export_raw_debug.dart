import "dart:convert";
import "package:http/http.dart" as http;
import "package:nextbid_demo/utils/export_raw.dart";

/// Posts multi-line JSS to the dev API (/bid/export.txt) and writes normalised CRLF result
/// into project\\exports\\nextbid_export_YYYY-MM.jss.
/// Safe for debug tooling; does not alter existing JSON export flows.
Future<void> serverExportRawDebug(
  String text, {
  String baseUrl = "http://127.0.0.1:8000",
}) async {
  final uri = Uri.parse("$baseUrl/bid/export.txt");
  final resp = await http.post(
    uri,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"text": text}),
  );
  if (resp.statusCode != 200) {
    throw Exception("export.txt failed ${resp.statusCode}: ${resp.body}");
  }
  final now = DateTime.now();
  final fname =
      "nextbid_export_${now.year}-${now.month.toString().padLeft(2, "0")}.jss";
  await exportRawText(fname, resp.body);
}
