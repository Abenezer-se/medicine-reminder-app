 // lib/widgets/drawer_widget.dart
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../screen/setting_screen.dart';
import '../screen/health_screen.dart';
import '../screen/symptom_screen.dart';
import '../screen/medicines.dart';
import '../screen/pharmacies_screen.dart';
import '../screen/emergency_screen.dart';
import '../screen/history_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header with Logo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
            decoration: const BoxDecoration(
              color: Color(0xFF2EC4B6),
            ),
            child: Column(
              children: [
                // Your Logo
                Image.asset(
                  'assets/images/app_logo.jpg',
                  width: 90,
                  height: 90,
                ),
                const SizedBox(height: 16),
                const Text(
                  "MediCare",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "Health Assistant",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Menu Items
          Expanded(
            child: ListView(
              children: [
                drawerItem(Icons.home, "Home",
                    active: true, onTap: () => Navigator.pop(context)),
                drawerItem(
                  Icons.medication,
                  "Medicines",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const MedicinesScreen()));
                  },
                ),
                drawerItem(
                  Icons.favorite,
                  "Health",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const HealthScreen()));
                  },
                ),
                drawerItem(
                  Icons.monitor_heart,
                  "Symptoms",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SymptomScreen()));
                  },
                ),
                drawerItem(Icons.history, "History", onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const HistoryScreen()));
                }),
                drawerItem(
                  Icons.local_pharmacy,
                  "Pharmacies",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PharmaciesScreen()));
                  },
                ),
                drawerItem(
                  Icons.emergency,
                  "Emergency",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const EmergencyScreen()));
                  },
                ),
                drawerItem(
                  Icons.settings,
                  "Settings",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SettingsScreen()));
                  },
                ),
              ],
            ),
          ),

          // Footer
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF2EC4B6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text(
                "Stay Healthy",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget drawerItem(IconData icon, String title,
      {bool active = false, VoidCallback? onTap}) {
    return ListTile(
      leading:
          Icon(icon, color: active ? const Color(0xFF2EC4B6) : Colors.grey),
      title: Text(
        title,
        style:
            TextStyle(color: active ? const Color(0xFF2EC4B6) : Colors.black),
      ),
      onTap: onTap,
    );
  }
}
