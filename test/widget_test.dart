import 'package:flutter_test/flutter_test.dart';
import 'package:nextbid_app/main.dart'; // matches pubspec.yaml 'name'

void main() {
  testWidgets('app boots to Login screen', (tester) async {
    await tester.pumpWidget(const NextBidApp());

    // Your MaterialApp title is 'NextBid' and the first page shows 'Log in'
    expect(find.text('Log in'), findsOneWidget);

    // Optional: sanity checkâ€”MaterialApp is present
    expect(find.byType(NextBidApp), findsOneWidget);
  });
}
