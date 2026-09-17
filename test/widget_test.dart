import 'package:flutter_test/flutter_test.dart';
import 'package:ntc_information_portal/main.dart';

void main() {
  testWidgets('App should render landing page', (WidgetTester tester) async {
    await tester.pumpWidget(const NTCApp());
    await tester.pumpAndSettle();
    expect(find.text('NTC'), findsOneWidget);
  });
}
