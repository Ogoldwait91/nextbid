import 'package:flutter_test/flutter_test.dart';
import 'package:nextbid_demo/main.dart';

void main() {
  testWidgets('App builds without crashing', (tester) async {
    await tester.pumpWidget(const NextBidApp());
    await tester.pumpAndSettle();
    expect(find.byType(NextBidApp), findsOneWidget);
  });
}
