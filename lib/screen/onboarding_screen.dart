import 'package:flutter/material.dart';
import '../widgets/onboarding_page.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  int index = 0;

  final pages = const [
    OnboardingPage(
      title: "Never Miss a Dose",
      description:
          "Set reminders for medications and stay on track with your health routine",
      icon: Icons.medication,
    ),
    OnboardingPage(
      title: "Track Your Health",
      description:
          "Monitor blood pressure, calculate BMI, and keep your records",
      icon: Icons.favorite,
    ),
    OnboardingPage(
      title: "Symptom Checker",
      description: "Assess symptoms and get guidance instantly",
      icon: Icons.health_and_safety,
    ),
    OnboardingPage(
      title: "Find Pharmacies",
      description: "Locate nearby pharmacies بسهولة",
      icon: Icons.location_on,
    ),
  ];

  void next() {
    if (index == pages.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(onPressed: skip, child: const Text("Skip")),
            ),

            // 🔹 Pages
            Expanded(
              child: PageView(
                controller: controller,
                onPageChanged: (i) => setState(() => index = i),
                children: pages,
              ),
            ),

            // 🔹 Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (i) => Container(
                  margin: const EdgeInsets.all(4),
                  width: index == i ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: index == i ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: next,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(index == pages.length - 1 ? "Get Started" : "Next"),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
