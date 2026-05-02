import 'package:flutter/material.dart';

class SymptomScreen extends StatefulWidget {
  const SymptomScreen({super.key});

  @override
  State<SymptomScreen> createState() => _SymptomScreenState();
}

class _SymptomScreenState extends State<SymptomScreen> {
  final TextEditingController _controller = TextEditingController();
  String? result;
  bool isSearching = false;

  final Color primaryColor = const Color(0xFF2EC4B6);

  void _searchSymptom() {
    if (_controller.text.trim().isEmpty) return;

    setState(() => isSearching = true);

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isSearching = false;
        result = _controller.text.trim();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Symptom Checker"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: const [], // ✅ FIXED
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 🔍 Search Box
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _searchSymptom(),
                decoration: InputDecoration(
                  hintText: "Type your symptom (like fever, headache...)",
                  prefixIcon: Icon(Icons.search, color: primaryColor),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      setState(() => result = null);
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔘 Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _searchSymptom,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Check Symptom",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ⏳ Loading
            if (isSearching)
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: primaryColor),
                ),
              )

            // 📄 Result
            else if (result != null)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      ),
                    ], // ✅ FIXED
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.medical_information,
                                color: primaryColor, size: 28),
                            const SizedBox(width: 10),
                            const Text(
                              "Possible Condition",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Text(
                          _getSymptomInfo(result!),
                          style: const TextStyle(
                            fontSize: 17,
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ⚠️ Warning Box
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.warning_amber_rounded,
                                  color: Colors.red),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "This is only general information.\nAlways consult a doctor.",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )

            // 💤 Empty State
            else
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search, size: 90, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        "Enter a symptom above",
                        style: TextStyle(fontSize: 17, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getSymptomInfo(String symptom) {
    symptom = symptom.toLowerCase();

    if (symptom.contains("headache") || symptom.contains("head pain")) {
      return "Most likely tension headache or migraine.\n\n"
          "Drink water, rest in a dark room, and avoid stress. "
          "If headache is very strong or comes with vomiting, see a doctor immediately.";
    } else if (symptom.contains("fever") || symptom.contains("hot body")) {
      return "Your body is fighting an infection.\n\n"
          "Rest well, drink lots of water, and take paracetamol if needed. "
          "If fever stays above 39°C for more than 2 days, consult a doctor.";
    } else if (symptom.contains("cough")) {
      return "Common cold or allergy.\n\n"
          "Drink warm water with honey. If you have chest pain or breathing difficulty, visit a doctor.";
    }

    return "We don't have specific information for this symptom.\n"
        "This is not a diagnosis. Please see a doctor for proper check-up.";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
