import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screens/auth_gate.dart';
import 'screens/setup_needed_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? firebaseError;
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    firebaseError = e.toString();
  }

  runApp(SuperAppRw(firebaseError: firebaseError));
}

class SuperAppRw extends StatelessWidget {
  const SuperAppRw({super.key, this.firebaseError});

  final String? firebaseError;

  static const Color green = Color(0xFF1B5E20);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super App RW',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: green),
        appBarTheme: const AppBarTheme(
          backgroundColor: green,
          foregroundColor: Colors.white,
        ),
      ),
      home: firebaseError != null
          ? SetupNeededScreen(error: firebaseError!)
          : const AuthGate(),
    );
  }
}
