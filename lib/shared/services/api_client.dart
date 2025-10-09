import "dart:convert";
import "package:http/http.dart" as http;

class ApiClient {
  final String base;
  const ApiClient({this.base = "http://127.0.0.1:8000"});

  Future<Map<String, dynamic>> getJson(String path) async {
    final r = await http.get(Uri.parse("$base$path"));
    if (r.statusCode >= 200 && r.statusCode < 300) {
      return json.decode(r.body) as Map<String, dynamic>;
    }
    throw Exception("GET $path failed: ${r.statusCode}");
  }

  Future<Map<String, dynamic>> credit(String month) => getJson("/credit/$month");
  Future<Map<String, dynamic>> calendar(String month) => getJson("/calendar/$month");
  Future<Map<String, dynamic>> statusResolve(String staffNo, String crewCode) =>
      getJson("/status/resolve?staff_no=$staffNo&crew_code=$crewCode");
}
