// lib/screen/health_screen.dart
import 'package:flutter/material.dart';
import '../widgets/notification_button.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  int _selectedTab = 0; // 0 = Blood Pressure, 1 = BMI

  // BMI Controllers
  final heightController = TextEditingController(text: "175");
  final weightController = TextEditingController(text: "70");
  double bmi = 22.9;
  String bmiResult = "Normal";
  Color bmiColor = Colors.green;

  // Blood Pressure Controllers
  final systolicController = TextEditingController(text: "118");
  final diastolicController = TextEditingController(text: "78");
  int systolic = 118;
  int diastolic = 78;
  String bpResult = "Normal";
  Color bpColor = Colors.green;

  @override
  void initState() {
    super.initState();
    _calculateBMI();
    _calculateBloodPressure();
  }

  void _calculateBMI() {
    double height = double.tryParse(heightController.text) ?? 0;
    double weight = double.tryParse(weightController.text) ?? 0;

    if (height > 0 && weight > 0) {
      double h = height / 100;
      double calc = weight / (h * h);
      bmi = double.parse(calc.toStringAsFixed(1));

      if (bmi < 18.5) {
        bmiResult = "Underweight";
        bmiColor = Colors.blue;
      } else if (bmi < 25) {
        bmiResult = "Normal";
        bmiColor = Colors.green;
      } else if (bmi < 30) {
        bmiResult = "Overweight";
        bmiColor = Colors.orange;
      } else {
        bmiResult = "Obese";
        bmiColor = Colors.red;
      }
    }
    setState(() {});
  }

  void _calculateBloodPressure() {
    systolic = int.tryParse(systolicController.text) ?? 120;
    diastolic = int.tryParse(diastolicController.text) ?? 80;

    if (systolic < 120 && diastolic < 80) {
      bpResult = "Normal";
      bpColor = Colors.green;
    } else if (systolic < 130 && diastolic < 80) {
      bpResult = "Elevated";
      bpColor = Colors.orange;
    } else if (systolic < 140 || diastolic < 90) {
      bpResult = "Stage 1 Hypertension";
      bpColor = Colors.deepOrange;
    } else if (systolic < 180 || diastolic < 120) {
      bpResult = "Stage 2 Hypertension";
      bpColor = Colors.red;
    } else {
      bpResult = "Hypertensive Crisis";
      bpColor = Colors.redAccent;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Health"),
        backgroundColor: const Color(0xFF2EC4B6),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: const [
          NotificationButton(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top Summary Cards
            Row(
              children: [
                // Blood Pressure Card
                Expanded(
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text("Blood Pressure",
                              style: TextStyle(fontSize: 14)),
                          Text(
                            "$systolic/$diastolic",
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          Text(bpResult,
                              style: TextStyle(
                                  color: bpColor, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // BMI Card
                Expanded(
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text("BMI", style: TextStyle(fontSize: 14)),
                          Text(
                            bmi.toStringAsFixed(1),
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          Text(bmiResult,
                              style: TextStyle(
                                  color: bmiColor,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Tabs
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _selectedTab == 0
                              ? const Color(0xFF2EC4B6)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            "Blood Pressure",
                            style: TextStyle(
                              color: _selectedTab == 0
                                  ? Colors.white
                                  : Colors.grey[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _selectedTab == 1
                              ? const Color(0xFF2EC4B6)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            "BMI Calculator",
                            style: TextStyle(
                              color: _selectedTab == 1
                                  ? Colors.white
                                  : Colors.grey[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tab Content
            _selectedTab == 0 ? _buildBloodPressureTab() : _buildBMITab(),
          ],
        ),
      ),
    );
  }

  Widget _buildBloodPressureTab() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Blood Pressure Calculator",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Systolic (Top)"),
                      const SizedBox(height: 8),
                      TextField(
                        controller: systolicController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        onChanged: (_) => _calculateBloodPressure(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Diastolic (Bottom)"),
                      const SizedBox(height: 8),
                      TextField(
                        controller: diastolicController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        onChanged: (_) => _calculateBloodPressure(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                "$systolic / $diastolic mmHg",
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                bpResult,
                style: TextStyle(
                    fontSize: 20, color: bpColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBMITab() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Calculate BMI",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Height (cm)"),
                      const SizedBox(height: 8),
                      TextField(
                        controller: heightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        onChanged: (_) => _calculateBMI(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Weight (kg)"),
                      const SizedBox(height: 8),
                      TextField(
                        controller: weightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        onChanged: (_) => _calculateBMI(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculateBMI,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2EC4B6),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Calculate BMI",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  Text(bmi.toStringAsFixed(1),
                      style: const TextStyle(
                          fontSize: 48, fontWeight: FontWeight.bold)),
                  Text(bmiResult,
                      style: TextStyle(fontSize: 22, color: bmiColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
