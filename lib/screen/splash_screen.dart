


// lib/screen/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final bool hasSeenOnboarding =
        prefs.getBool('has_seen_onboarding') ?? false;

    // FIX: 2.5 seconds instead of 7
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    if (hasSeenOnboarding) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 253, 252),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/app_logo.jpg',
              width: 220,
              height: 220,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 220,
                  height: 220,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.medical_services,
                    size: 140,
                    color: Color(0xFF2EC486),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            const Text(
              "MediCare",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 5, 237, 249),
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Care You Can Count On!",
              style: TextStyle(
                fontSize: 22,
                color: Color.fromARGB(179, 99, 232, 247),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 60),
            const CircularProgressIndicator(
              color: Color(0xFF2EC4B6),
            ),
          ],
        ),
      ),
    );
  }
}
