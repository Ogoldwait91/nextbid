import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient._();

  static const String _base = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000',
  );

  static Uri _u(String path) => Uri.parse('$_base$path');

  static Future<Map<String, dynamic>> getJson(String path) async {
    final res = await http.get(_u(path));
    if (res.statusCode != 200) {
      throw Exception('GET $path failed: ${res.statusCode} ${res.body}');
    }
    final body = jsonDecode(res.body);
    if (body is Map<String, dynamic>) return body;
    throw Exception('Expected JSON object from $path');
  }

  static Future<List<dynamic>> getList(String path) async {
    final res = await http.get(_u(path));
    if (res.statusCode != 200) {
      throw Exception('GET $path failed: ${res.statusCode} ${res.body}');
    }
    final body = jsonDecode(res.body);
    if (body is List) return body;
    throw Exception('Expected JSON array from $path');
  }

  static Future<Map<String, dynamic>> postJson(
    String path,
    Map<String, dynamic> payload,
  ) async {
    final res = await http.post(
      _u(path),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('POST $path failed: ${res.statusCode} ${res.body}');
    }
    final body = jsonDecode(res.body);
    if (body is Map<String, dynamic>) return body;
    throw Exception('Expected JSON object from $path');
  }
}
