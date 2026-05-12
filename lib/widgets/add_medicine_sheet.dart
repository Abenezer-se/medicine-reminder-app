// lib/widgets/add_medicine_sheet.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/medicine_provider.dart';

class AddMedicineSheet extends StatefulWidget {
  const AddMedicineSheet({super.key});

  @override
  State<AddMedicineSheet> createState() => _AddMedicineSheetState();
}

class _AddMedicineSheetState extends State<AddMedicineSheet> {
  final nameController = TextEditingController();
  final doseController = TextEditingController();
  final frequencyController = TextEditingController(text: "Once Daily");
  final timeController = TextEditingController();
  final remainingDosesController = TextEditingController(text: "7");
  final startDateController = TextEditingController(text: "10 Mar 2026");
  final endDateController = TextEditingController();
  final reminderController = TextEditingController();

  final List<String> frequencyOptions = [
    "Once Daily",
    "Twice Daily",
    "Three Times Daily",
    "Every 8 hours",
    "As needed"
  ];

  // Function to open Time Picker
  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final String formattedTime =
          pickedTime.format(context); // e.g., "8:00 AM"
      setState(() {
        timeController.text = formattedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Add Medicine",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Medicine Name
            const Text("Medicine Name*"),
            const SizedBox(height: 6),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "e.g. Aspirin",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            // Doses + Frequency
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Doses*"),
                      const SizedBox(height: 6),
                      TextField(
                        controller: doseController,
                        decoration: InputDecoration(
                          hintText: "e.g. 500mg",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Frequency"),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: frequencyController.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        items: frequencyOptions
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) frequencyController.text = val;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Remaining Doses
            const Text("Remaining Doses"),
            const SizedBox(height: 6),
            TextField(
              controller: remainingDosesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "7",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            // Time Field + Select Time Button
            const Text("Time"),
            const SizedBox(height: 6),
            TextField(
              controller: timeController,
              decoration: InputDecoration(
                hintText: "8:00 in the morning",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 8),

            // New Button: Select Time using Time Picker
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: _selectTime,
                icon: const Icon(Icons.access_time),
                label: const Text("Select Time"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2EC4B6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Start & End Date
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Start Date"),
                      const SizedBox(height: 6),
                      TextField(
                        controller: startDateController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("End Date"),
                      const SizedBox(height: 6),
                      TextField(
                        controller: endDateController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Reminder Times
            const Text("Reminder Times"),
            const SizedBox(height: 6),
            TextField(
              controller: reminderController,
              decoration: InputDecoration(
                hintText: "optional",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 30),

            // Done Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2EC4B6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  final name = nameController.text.trim();
                  final dose = doseController.text.trim();
                  final frequency = frequencyController.text;
                  final time = timeController.text.trim().isNotEmpty
                      ? timeController.text.trim()
                      : "8:00";
                  final remaining =
                      int.tryParse(remainingDosesController.text) ?? 7;
                  final startDate = startDateController.text.trim();
                  final endDate = endDateController.text.trim();

                  if (name.isEmpty || dose.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please fill required fields")),
                    );
                    return;
                  }

                  context.read<MedicineProvider>().addMedicine(
                        name: name,
                        dose: dose,
                        frequency: frequency,
                        time: time,
                        remainingDoses: remaining,
                        startDate:
                            startDate.isNotEmpty ? startDate : "10 Mar 2026",
                        endDate: endDate,
                      );

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Medicine added successfully!")),
                  );
                },
                child: const Text("Done",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
