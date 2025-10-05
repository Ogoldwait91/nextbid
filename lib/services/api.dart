import "dart:convert";
import "package:http/http.dart" as http;

class NextBidApi {
  final String base; // e.g. http://127.0.0.1:8000
  const NextBidApi({required this.base});

  Future<Map<String, dynamic>> getCalendar(int year, int month) async {
    final uri = Uri.parse("$base/calendars/$year/$month");
    final res = await http.get(uri);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return json.decode(res.body) as Map<String, dynamic>;
    }
    throw Exception(
        "Calendar $year-$month failed: ${res.statusCode} ${res.body}");
  }
}
