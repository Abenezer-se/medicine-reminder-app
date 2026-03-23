import 'package:flutter/material.dart';
import 'screen/onboarding_screen.dart';

void main() {
  runApp(const MeditimeApp());
}

class MeditimeApp extends StatelessWidget {
  const MeditimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    );
  }
}
