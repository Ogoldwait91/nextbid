import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static String base = const String.fromEnvironment('API_BASE_URL', defaultValue: 'http://127.0.0.1:8000');

  static Future<Map<String, dynamic>> getJson(String path) async {
    final r = await http.get(Uri.parse('\\'));
    if (r.statusCode != 200) { throw Exception('GET ' + path + ' failed: ' + r.statusCode.toString()); }
    return json.decode(r.body) as Map<String, dynamic>;
  }

  static Future<List<dynamic>> getList(String path) async {
    final r = await http.get(Uri.parse('\\'));
    if (r.statusCode != 200) { throw Exception('GET ' + path + ' failed: ' + r.statusCode.toString()); }
    return json.decode(r.body) as List<dynamic>;
  }

  static Future<Map<String, dynamic>> postJson(String path, Map<String, dynamic> body) async {
    final r = await http.post(Uri.parse('\\'),
      headers: {'Content-Type':'application/json'},
      body: json.encode(body),
    );
    if (r.statusCode < 200 || r.statusCode >= 300) { throw Exception('POST ' + path + ' failed: ' + r.statusCode.toString() + ' ' + r.body); }
    return json.decode(r.body) as Map<String, dynamic>;
  }
}
