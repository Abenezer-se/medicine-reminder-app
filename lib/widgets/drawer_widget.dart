import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../screen/setting_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 40),

          // 🔹 Logo + Title
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.health_and_safety, color: Colors.white),
            ),
            title: const Text("MediCare"),
            subtitle: const Text("Health Assistant"),
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context); // close drawer
              },
            ),
          ),

          const Divider(),

          // 🔹 Drawer Items
          drawerItem(Icons.home, "Home", active: true),

          drawerItem(Icons.medication, "Medicines"),

          drawerItem(Icons.favorite, "Health"),

          drawerItem(Icons.monitor_heart, "Symptoms"),

          drawerItem(Icons.history, "History"),

          // ✅ Pharmacies navigation
          drawerItem(
            Icons.local_pharmacy,
            "Pharmacies",
            onTap: () {
              Navigator.pop(context);
            },
          ),

          // ✅ Settings navigation
          drawerItem(
            Icons.settings,
            "Settings",
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),

          const Spacer(),

          // 🔹 Bottom box
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 113, 242, 229).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(child: Text("Stay Healthy")),
          ),
        ],
      ),
    );
  }

  // 🔥 Updated drawer item with onTap
  Widget drawerItem(
    IconData icon,
    String title, {
    bool active = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: active ? AppColors.primary : Colors.grey),
      title: Text(
        title,
        style: TextStyle(color: active ? AppColors.primary : Colors.black),
      ),
      onTap: onTap,
    );
  }
}
