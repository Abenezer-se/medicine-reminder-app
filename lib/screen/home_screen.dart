// lib/screen/home_screen.dart
/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/medicine_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/notification_button.dart';
import '../widgets/add_medicine_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  String getEmoji() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "☀️";
    if (hour < 17) return "🌞";
    return "🌙";
  }

  @override
  Widget build(BuildContext context) {
    final medicineProvider = context.watch<MedicineProvider>();
    final userProvider = context.watch<UserProvider>();

    final medicines = medicineProvider.medicines;
    final displayName =
        userProvider.userName.isNotEmpty ? userProvider.userName : "🫡";

    final now = DateTime.now();
    final dayName = DateFormat('EEEE').format(now);
    final dateStr = DateFormat('MMMM d, y').format(now);

    final activeCount = medicines.length;
    final takenToday = medicines.where((m) => m.status == "taken").length;
    final pendingCount = medicines.where((m) => m.status == "pending").length;
    final skippedCount = medicines.where((m) => m.status == "skipped").length;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: const Color(0xFF2EC4B6),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: const [NotificationButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Text(
              "${getGreeting()}, $displayName ${getEmoji()}",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              "$dayName, $dateStr",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withOpacity(0.7),
                  ),
            ),

            const SizedBox(height: 32),

            // Stats Grid - Fixed layout
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
              childAspectRatio: 1.35, // Better proportion to avoid overflow
              children: [
                _buildStatCard(context, "ACTIVE MEDICINES", "$activeCount",
                    Icons.medication, Colors.blue),
                _buildStatCard(context, "TAKE TODAY", "$takenToday",
                    Icons.check_circle, Colors.green,
                    subtitle: "of 7 doses"),
                _buildStatCard(context, "PENDING", "$pendingCount",
                    Icons.access_time, Colors.orange,
                    subtitle: "Doses remaining"),
                _buildStatCard(context, "SKIPPED", "$skippedCount",
                    Icons.warning_amber, Colors.red,
                    subtitle: "today"),
              ],
            ),

            const SizedBox(height: 32),

            const Text(
              "Today's Schedule",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            if (medicines.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 60),
                  child: Text(
                    "No medicines added yet\nTap + to add your first medicine",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: medicines.length,
                itemBuilder: (context, index) {
                  final med = medicines[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2EC4B6).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.medication,
                            color: Color(0xFF2EC4B6)),
                      ),
                      title: Text(med.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(med.time),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              // Mark as Skipped
                              med.status = "skipped";
                              medicineProvider.notifyListeners(); // Refresh UI
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () {
                              // Mark as Taken
                              med.status = "taken";
                              medicineProvider.notifyListeners(); // Refresh UI
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 100), // Space for FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2EC4B6),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const AddMedicineSheet(),
          );
        },
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value,
      IconData icon, Color iconColor,
      {String? subtitle}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 28),
                const Spacer(),
                if (title == "TAKE TODAY")
                  const Icon(Icons.check_circle, color: Colors.green, size: 22),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 14)),
            if (subtitle != null)
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
*/
// lib/screen/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/medicine_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/notification_button.dart';
import '../widgets/add_medicine_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  String getEmoji() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "☀️";
    if (hour < 17) return "🌞";
    return "🌙";
  }

  @override
  Widget build(BuildContext context) {
    final medicineProvider = context.watch<MedicineProvider>();
    final userProvider = context.watch<UserProvider>();

    final medicines = medicineProvider.medicines;
    final displayName =
        userProvider.userName.isNotEmpty ? userProvider.userName : "🫡";

    final now = DateTime.now();
    final dayName = DateFormat('EEEE').format(now);
    final dateStr = DateFormat('MMMM d, y').format(now);

    final activeCount = medicines.length;
    final takenToday = medicines.where((m) => m.status == "taken").length;
    final pendingCount = medicines.where((m) => m.status == "pending").length;
    final skippedCount = medicines.where((m) => m.status == "skipped").length;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: const Color(0xFF2EC4B6),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: const [NotificationButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${getGreeting()}, $displayName ${getEmoji()}",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              "$dayName, $dateStr",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withOpacity(0.7),
                  ),
            ),
            const SizedBox(height: 32),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
              childAspectRatio: 1.35,
              children: [
                _buildStatCard(context, "ACTIVE MEDICINES", "$activeCount",
                    Icons.medication, Colors.blue),
                _buildStatCard(context, "TAKEN TODAY", "$takenToday",
                    Icons.check_circle, Colors.green,
                    subtitle: "of ${medicines.length} doses"),
                _buildStatCard(context, "PENDING", "$pendingCount",
                    Icons.access_time, Colors.orange,
                    subtitle: "Doses remaining"),
                _buildStatCard(context, "SKIPPED", "$skippedCount",
                    Icons.warning_amber, Colors.red,
                    subtitle: "today"),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              "Today's Schedule",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (medicines.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 60),
                  child: Text(
                    "No medicines added yet\nTap + to add your first medicine",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: medicines.length,
                itemBuilder: (context, index) {
                  final med = medicines[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2EC4B6).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.medication,
                            color: Color(0xFF2EC4B6)),
                      ),
                      title: Text(med.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(med.time),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Status badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: med.status == "taken"
                                  ? Colors.green[100]
                                  : med.status == "skipped"
                                      ? Colors.red[100]
                                      : Colors.orange[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              med.status.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: med.status == "taken"
                                    ? Colors.green[700]
                                    : med.status == "skipped"
                                        ? Colors.red[700]
                                        : Colors.orange[700],
                              ),
                            ),
                          ),
                          // FIX: use updateStatus() so Hive saves the change
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () =>
                                medicineProvider.updateStatus(med, "skipped"),
                          ),
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () =>
                                medicineProvider.updateStatus(med, "taken"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2EC4B6),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const AddMedicineSheet(),
          );
        },
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value,
      IconData icon, Color iconColor,
      {String? subtitle}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 28),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 13)),
            if (subtitle != null)
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
