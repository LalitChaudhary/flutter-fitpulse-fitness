class SetLog {
  const SetLog({required this.reps, required this.weightKg});
  final int reps;
  final double weightKg;
}

class SessionMath {
  const SessionMath();

  int volume(List<SetLog> sets) {
    var total = 0;
    for (final set in sets) {
      total += set.reps * (set.weightKg * 10).round();
    }
    return total;
  }

  int remainingSeconds(int elapsed, int target) {
    final left = target - elapsed;
    return left < 0 ? 0 : left;
  }
}
