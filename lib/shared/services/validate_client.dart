import "dart:convert";
import "package:http/http.dart" as http;

class ApiClient {
  final String base;
  ApiClient(this.base);

  Future<Map<String, dynamic>> validateBid(String text) async {
    final uri = Uri.parse("$base/bid/validate");
    final res = await http.post(
      uri,
      headers: {"Content-Type": "application/json; charset=utf-8"},
      body: jsonEncode({"text": text}),
    );
    if (res.statusCode != 200) {
      throw Exception("Validate failed: ${res.statusCode} ${res.body}");
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }
}
