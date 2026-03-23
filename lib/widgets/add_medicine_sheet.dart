import 'package:flutter/material.dart';

class AddMedicineSheet extends StatelessWidget {
  const AddMedicineSheet({super.key});

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
            // 🔹 Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Add Medicine",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // 🔹 Medicine Name
            const Text("Medicine Name*"),
            const SizedBox(height: 5),
            const TextField(
              decoration: InputDecoration(
                hintText: "e.g. Aspirin",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // 🔹 Dose + Frequency
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Dose*"),
                      SizedBox(height: 5),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "e.g. 500mg",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Frequency"),
                      SizedBox(height: 5),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Once Daily",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // 🔹 Time
            const Text("Time"),
            const SizedBox(height: 5),
            const TextField(
              decoration: InputDecoration(
                hintText: "8:00 in the morning",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text("Add Time"),
            ),

            const SizedBox(height: 15),

            // 🔹 Dates
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Start Date"),
                      SizedBox(height: 5),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "10 Mar 2026",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("End Date"),
                      SizedBox(height: 5),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Optional",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // 🔹 Reminder
            const Text("Reminder Times"),
            const SizedBox(height: 5),
            const TextField(
              decoration: InputDecoration(
                hintText: "optional",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Done Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(18),
                ),
                onPressed: () {},
                child: const Text("Done"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
