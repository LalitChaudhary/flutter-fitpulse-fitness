import 'package:mobx/mobx.dart';

import 'domain/session_math.dart';

class WorkoutStore {
  final signedIn = Observable(false);
  final error = Observable<String?>(null);
  final sets = ObservableList<SetLog>();
  final elapsed = Observable(0);

  late final volume = Computed(() => const SessionMath().volume(sets));

  void signIn(String email, String password) {
    runInAction(() {
      if (email.trim() == 'kai@fitpulse.dev' && password == 'demo1234') {
        signedIn.value = true;
        error.value = null;
      } else {
        error.value = 'Use the demo athlete on this screen.';
      }
    });
  }

  void addSet() {
    runInAction(() => sets.add(const SetLog(reps: 8, weightKg: 40)));
  }

  void tick() {
    runInAction(() => elapsed.value += 1);
  }
}
