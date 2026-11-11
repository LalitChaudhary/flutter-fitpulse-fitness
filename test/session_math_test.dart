import 'package:fitpulse/domain/session_math.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const math = SessionMath();

  test('volume uses tenths of a kilogram', () {
    expect(
      math.volume(const [
        SetLog(reps: 8, weightKg: 40),
        SetLog(reps: 6, weightKg: 42.5)
      ]),
      8 * 400 + 6 * 425,
    );
  });

  test('timer does not go below zero', () {
    expect(math.remainingSeconds(50, 45), 0);
    expect(math.remainingSeconds(10, 45), 35);
  });
}
