import "dart:convert";
import "package:http/http.dart" as http;

class NextBidApi {
  final String base;
  NextBidApi({this.base = "http://127.0.0.1:8000"});

  Future<Map<String, dynamic>> validateBid(Map<String, dynamic> bid) async {
    final r = await http.post(
      Uri.parse("$base/bid/validate"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(bid),
    );
    if (r.statusCode != 200) {
      throw Exception("Validate failed: ${r.statusCode} ${r.body}");
    }
    return jsonDecode(r.body) as Map<String, dynamic>;
  }
}
