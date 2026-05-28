// lib/screen/symptom_screen.dart
import 'package:flutter/material.dart';
import '../utils/theme_helper.dart';

class SymptomScreen extends StatefulWidget {
  const SymptomScreen({super.key});

  @override
  State<SymptomScreen> createState() => _SymptomScreenState();
}

class _SymptomScreenState extends State<SymptomScreen> {
  static const Color primary = Color(0xFF2EC4B6);
  final _ctrl = TextEditingController();
  String? _result;
  bool _loading = false;

  final List<String> _quick = [
    'Headache',
    'Fever',
    'Cough',
    'Nausea',
    'Fatigue',
    'Chest Pain',
    'Dizziness',
    'Sore Throat',
  ];

  void _check(String symptom) {
    if (symptom.trim().isEmpty) return;
    _ctrl.text = symptom;
    setState(() => _loading = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _loading = false;
        _result = symptom;
      });
    });
  }

  String _getInfo(String s) {
    s = s.toLowerCase();
    if (s.contains('headache') || s.contains('head')) {
      return '🧠 Most likely tension headache or migraine.\n\nRest in a quiet dark room. Stay hydrated. Take paracetamol if needed. See a doctor if pain is severe or sudden.';
    } else if (s.contains('fever')) {
      return '🌡️ Your body is fighting an infection.\n\nRest and drink plenty of fluids. Take paracetamol to reduce fever. Seek medical attention if fever exceeds 39°C for more than 2 days.';
    } else if (s.contains('cough')) {
      return '😷 Likely a common cold, allergy or respiratory infection.\n\nDrink warm water with honey. Avoid cold drinks. Visit a doctor if you have chest pain or breathing difficulty.';
    } else if (s.contains('nausea') || s.contains('vomit')) {
      return '🤢 Could be food poisoning, gastritis or motion sickness.\n\nEat light meals and stay hydrated. Rest and avoid strong smells. See a doctor if vomiting persists.';
    } else if (s.contains('fatigue') || s.contains('tired')) {
      return '😴 Fatigue can be caused by poor sleep, stress, anaemia or infection.\n\nEnsure 7-9 hours of sleep. Eat balanced meals. See a doctor if fatigue is persistent.';
    } else if (s.contains('chest')) {
      return '❤️ Chest pain can range from minor to serious.\n\n⚠️ If you have severe chest pain, shortness of breath or sweating — call emergency services immediately.';
    } else if (s.contains('dizz') || s.contains('vertigo')) {
      return '💫 Dizziness may be caused by dehydration, low blood pressure or inner ear issues.\n\nSit or lie down immediately. Drink water slowly. See a doctor if it recurs.';
    } else if (s.contains('throat') || s.contains('sore')) {
      return '🫁 Likely a viral throat infection or tonsillitis.\n\nGargle with warm salt water. Drink warm liquids. See a doctor if you have high fever or difficulty swallowing.';
    }
    return '🔍 We don\'t have specific information for "$s".\n\nPlease consult a qualified healthcare professional for an accurate diagnosis.';
  }

  @override
  Widget build(BuildContext context) {
    final bg = TH.bg(context);
    final card = TH.card(context);
    final text = TH.text(context);
    final isDark = TH.isDark(context);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('Symptom Checker',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search
            Container(
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: primary.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      onSubmitted: _check,
                      style: TextStyle(color: text),
                      decoration: InputDecoration(
                        hintText: 'Type a symptom...',
                        hintStyle: TextStyle(color: TH.subText(context)),
                        prefixIcon: const Icon(Icons.search, color: primary),
                        border: InputBorder.none,
                        fillColor: Colors.transparent,
                        filled: false,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  if (_ctrl.text.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.close, color: TH.subText(context)),
                      onPressed: () {
                        _ctrl.clear();
                        setState(() => _result = null);
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _check(_ctrl.text.trim()),
                icon: const Icon(Icons.health_and_safety, color: Colors.white),
                label: const Text('Check Symptom',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Quick symptoms
            Text('Common Symptoms',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15, color: text)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quick
                  .map((s) => GestureDetector(
                        onTap: () => _check(s),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color:
                                isDark ? const Color(0xFF21262D) : Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: primary.withOpacity(0.4)),
                          ),
                          child: Text(s,
                              style: const TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13)),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),

            // Result
            if (_loading)
              const Center(child: CircularProgressIndicator(color: primary))
            else if (_result != null)
              Container(
                width: double.infinity,
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
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.medical_information_rounded,
                              color: primary, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text('Results for "$_result"',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: text)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(_getInfo(_result!),
                        style:
                            TextStyle(fontSize: 15, height: 1.6, color: text)),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B6B).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFFFF6B6B).withOpacity(0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              color: Color(0xFFFF6B6B)),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                                'General information only. Always consult a doctor.',
                                style: TextStyle(
                                    color: Color(0xFFFF6B6B),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                          color: primary.withOpacity(0.08),
                          shape: BoxShape.circle),
                      child: const Icon(Icons.health_and_safety_rounded,
                          size: 56, color: primary),
                    ),
                    const SizedBox(height: 16),
                    Text('Enter a symptom above',
                        style: TextStyle(
                            fontSize: 16, color: TH.subText(context))),
                    Text('or tap a common symptom',
                        style: TextStyle(
                            fontSize: 13, color: TH.subText(context))),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
