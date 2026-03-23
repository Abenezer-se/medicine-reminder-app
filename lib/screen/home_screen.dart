import 'package:flutter/material.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/stat_card.dart';
import '../widgets/schedule_item.dart';
import '../widgets/add_medicine_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: const Color.fromARGB(255, 130, 249, 255),
      ),

      drawer: const AppDrawer(),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Greeting
            const Text(
              "Good Morning 👋",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // ✅ 4 Cards (Properly aligned grid)
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              childAspectRatio: 1.5, // ✅ ADD THIS LINE
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                StatCard(title: "Active", value: "0"),
                StatCard(title: "Take Today", value: "0"),
                StatCard(title: "Pending", value: "0"),
                StatCard(title: "Skipped", value: "0"),
              ],
            ),

            const SizedBox(height: 20),

            // ✅ Section Title
            const Text(
              "Today's Schedule",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // ✅ Schedule Item
            const ScheduleItem(name: "Aspirin", time: "8:00"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 146, 243, 244),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true, // ✅ ADD THIS LINE
            builder: (_) => const AddMedicineSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
