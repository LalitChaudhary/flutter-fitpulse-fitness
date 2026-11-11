import 'package:fitpulse/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('athlete opens the session', (tester) async {
    await tester.pumpWidget(const FitPulseApp());
    await tester.tap(find.text('Start session'));
    await tester.pumpAndSettle();
    expect(find.text('Log 8 reps at 40 kg'), findsOneWidget);
  });
}
