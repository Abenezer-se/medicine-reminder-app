

// lib/screen/health_screen.dart
import 'package:flutter/material.dart';
import '../utils/theme_helper.dart';
import '../widgets/notification_button.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  static const Color primary = Color(0xFF2EC4B6);

  int _tab = 0;
  final heightCtrl = TextEditingController(text: '175');
  final weightCtrl = TextEditingController(text: '70');
  final systolicCtrl = TextEditingController(text: '118');
  final diastolicCtrl = TextEditingController(text: '78');

  double bmi = 22.9;
  String bmiLabel = 'Normal';
  Color bmiColor = const Color(0xFF4CAF50);
  int systolic = 118, diastolic = 78;
  String bpLabel = 'Normal';
  Color bpColor = const Color(0xFF4CAF50);

  @override
  void initState() {
    super.initState();
    _calcBMI();
    _calcBP();
  }

  void _calcBMI() {
    final h = double.tryParse(heightCtrl.text) ?? 0;
    final w = double.tryParse(weightCtrl.text) ?? 0;
    if (h > 0 && w > 0) {
      final hm = h / 100;
      bmi = double.parse((w / (hm * hm)).toStringAsFixed(1));
      if (bmi < 18.5) {
        bmiLabel = 'Underweight';
        bmiColor = const Color(0xFF5B8DEF);
      } else if (bmi < 25) {
        bmiLabel = 'Normal';
        bmiColor = const Color(0xFF4CAF50);
      } else if (bmi < 30) {
        bmiLabel = 'Overweight';
        bmiColor = const Color(0xFFFFAA00);
      } else {
        bmiLabel = 'Obese';
        bmiColor = const Color(0xFFFF6B6B);
      }
    }
    setState(() {});
  }

  void _calcBP() {
    systolic = int.tryParse(systolicCtrl.text) ?? 120;
    diastolic = int.tryParse(diastolicCtrl.text) ?? 80;
    if (systolic < 120 && diastolic < 80) {
      bpLabel = 'Normal';
      bpColor = const Color(0xFF4CAF50);
    } else if (systolic < 130 && diastolic < 80) {
      bpLabel = 'Elevated';
      bpColor = const Color(0xFFFFAA00);
    } else if (systolic < 140 || diastolic < 90) {
      bpLabel = 'Stage 1 Hypertension';
      bpColor = Colors.deepOrange;
    } else if (systolic < 180 || diastolic < 120) {
      bpLabel = 'Stage 2 Hypertension';
      bpColor = const Color(0xFFFF6B6B);
    } else {
      bpLabel = 'Hypertensive Crisis';
      bpColor = Colors.red;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bg = TH.bg(context);
    final card = TH.card(context);
    final text = TH.text(context);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title:
            const Text('Health', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: const [NotificationButton()],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              decoration: const BoxDecoration(
                color: primary,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(28)),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: _summaryCard('Blood Pressure',
                          '$systolic/$diastolic', 'mmHg', bpLabel, bpColor)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _summaryCard('BMI', bmi.toStringAsFixed(1),
                          'kg/m²', bmiLabel, bmiColor)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Tab switcher
                  Container(
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 10)
                      ],
                    ),
                    child: Row(
                      children: [
                        _tabBtn('🫀 Blood Pressure', 0, card),
                        _tabBtn('⚖️ BMI Calculator', 1, card),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _tab == 0
                      ? _buildBPTab(card, text)
                      : _buildBMITab(card, text),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabBtn(String label, int index, Color card) {
    final active = _tab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: active ? primary : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: active ? Colors.white : Colors.grey,
                  fontSize: 13)),
        ),
      ),
    );
  }

  Widget _summaryCard(
      String title, String value, String unit, String label, Color labelColor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          Text(unit,
              style: const TextStyle(color: Colors.white60, fontSize: 11)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
                color: labelColor.withOpacity(0.25),
                borderRadius: BorderRadius.circular(20)),
            child: Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildBPTab(Color card, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Blood Pressure Calculator',
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _field('Systolic (Top)', systolicCtrl, _calcBP)),
              const SizedBox(width: 14),
              Expanded(
                  child: _field('Diastolic (Bottom)', diastolicCtrl, _calcBP)),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                Text('$systolic / $diastolic mmHg',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: textColor)),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                      color: bpColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(bpLabel,
                      style: TextStyle(
                          color: bpColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _guide('Normal', '< 120/80', const Color(0xFF4CAF50)),
          _guide('Elevated', '120-129/<80', const Color(0xFFFFAA00)),
          _guide('Stage 1', '130-139/80-89', Colors.deepOrange),
          _guide('Stage 2', '≥ 140/≥ 90', const Color(0xFFFF6B6B)),
          _guide('Crisis', '> 180/>120', Colors.red),
        ],
      ),
    );
  }

  Widget _buildBMITab(Color card, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('BMI Calculator',
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _field('Height (cm)', heightCtrl, _calcBMI)),
              const SizedBox(width: 14),
              Expanded(child: _field('Weight (kg)', weightCtrl, _calcBMI)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _calcBMI,
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Calculate BMI',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                Text(bmi.toStringAsFixed(1),
                    style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: bmiColor)),
                Text(bmiLabel,
                    style: TextStyle(
                        fontSize: 20,
                        color: bmiColor,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _guide('Underweight', '< 18.5', const Color(0xFF5B8DEF)),
          _guide('Normal', '18.5 – 24.9', const Color(0xFF4CAF50)),
          _guide('Overweight', '25 – 29.9', const Color(0xFFFFAA00)),
          _guide('Obese', '≥ 30', const Color(0xFFFF6B6B)),
        ],
      ),
    );
  }

  Widget _field(
      String label, TextEditingController ctrl, VoidCallback onChange) {
    return TextField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      onChanged: (_) => onChange(),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
      ),
    );
  }

  Widget _guide(String label, String range, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Text(label,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(range,
              style: TextStyle(
                  fontSize: 13, color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
