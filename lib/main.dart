import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'domain/session_math.dart';
import 'workout_store.dart';

void main() => runApp(const FitPulseApp());

class FitPulseApp extends StatefulWidget {
  const FitPulseApp({super.key});

  @override
  State<FitPulseApp> createState() => _FitPulseAppState();
}

class _FitPulseAppState extends State<FitPulseApp> {
  final store = WorkoutStore();

  @override
  Widget build(BuildContext context) {
    return WorkoutScope(
      store: store,
      child: MaterialApp(
        title: 'FitPulse',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFB6F34A),
            primary: const Color(0xFF222222),
            secondary: const Color(0xFFB6F34A),
            background: const Color(0xFFF7F7F2),
          ),
        ),
        home: const GymGate(),
      ),
    );
  }
}

class WorkoutScope extends InheritedWidget {
  const WorkoutScope({super.key, required this.store, required super.child});

  final WorkoutStore store;

  static WorkoutStore of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<WorkoutScope>()!.store;
  }

  @override
  bool updateShouldNotify(WorkoutScope oldWidget) => store != oldWidget.store;
}

class GymGate extends StatelessWidget {
  const GymGate({super.key});

  @override
  Widget build(BuildContext context) {
    final store = WorkoutScope.of(context);
    return Observer(
        builder: (_) =>
            store.signedIn.value ? const SessionPage() : const SignInPage());
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _email = TextEditingController(text: 'kai@fitpulse.dev');
  final _password = TextEditingController(text: 'demo1234');

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = WorkoutScope.of(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('FitPulse', style: Theme.of(context).textTheme.headlineMedium),
            const Text(
                'Training log demo. Loads and calories are estimates, not medical advice.'),
            const SizedBox(height: 16),
            TextField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email')),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            Observer(builder: (_) => Text(store.error.value ?? '')),
            FilledButton(
              onPressed: () => store.signIn(_email.text, _password.text),
              child: const Text('Start session'),
            ),
          ],
        ),
      ),
    );
  }
}

class SessionPage extends StatelessWidget {
  const SessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = WorkoutScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Lower body')),
      body: Observer(
        builder: (_) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
                'Elapsed ${store.elapsed.value}s · left ${const SessionMath().remainingSeconds(store.elapsed.value, 45)}s of the sample block'),
            Text('Volume score ${store.volume.value}'),
            FilledButton(
                onPressed: store.addSet,
                child: const Text('Log 8 reps at 40 kg')),
            TextButton(
                onPressed: store.tick, child: const Text('Tick one second')),
            for (final set in store.sets)
              Text('${set.reps} × ${set.weightKg} kg'),
          ],
        ),
      ),
    );
  }
}
