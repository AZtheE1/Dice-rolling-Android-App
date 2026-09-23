import 'package:flutter_test/flutter_test.dart';
import 'package:dicerollinggame/main.dart';

void main() {
  testWidgets('App renders splash screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DiceGameApp());
    expect(find.text('ROLL MASTER'), findsOneWidget);
  });
}
