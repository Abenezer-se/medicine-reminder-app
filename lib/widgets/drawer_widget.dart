// lib/widgets/drawer_widget.dart
import 'package:flutter/material.dart';
import '../utils/theme_helper.dart';
import '../screen/setting_screen.dart';
import '../screen/health_screen.dart';
import '../screen/symptom_screen.dart';
import '../screen/medicines.dart';
import '../screen/pharmacies_screen.dart';
import '../screen/emergency_screen.dart';
import '../screen/history_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static const Color primary = Color(0xFF2EC4B6);

  @override
  Widget build(BuildContext context) {
    final card = TH.card(context);
    final text = TH.text(context);
    final isDark = TH.isDark(context);

    return Drawer(
      backgroundColor: card,
      child: Column(
        children: [
          // ── Logo Header ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 28),
            decoration: const BoxDecoration(
              color: primary,
            ),
            child: Column(
              children: [
                // App Logo
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/app_logo.jpg',
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.medical_services,
                          size: 50,
                          color: primary),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                // App Name
                const Text(
                  'Medicare',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Smart Health Assistant',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ── Menu Items ──
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _drawerItem(
                  context,
                  Icons.home_rounded,
                  'Home',
                  text: text,
                  isDark: isDark,
                  onTap: () => Navigator.pop(context),
                ),
                _drawerItem(
                  context,
                  Icons.medication_rounded,
                  'Medicines',
                  text: text,
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const MedicinesScreen()));
                  },
                ),
                _drawerItem(
                  context,
                  Icons.favorite_rounded,
                  'Health',
                  text: text,
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const HealthScreen()));
                  },
                ),
                _drawerItem(
                  context,
                  Icons.monitor_heart_rounded,
                  'Symptoms',
                  text: text,
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SymptomScreen()));
                  },
                ),
                _drawerItem(
                  context,
                  Icons.history_rounded,
                  'History',
                  text: text,
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const HistoryScreen()));
                  },
                ),
                _drawerItem(
                  context,
                  Icons.local_pharmacy_rounded,
                  'Pharmacies',
                  text: text,
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PharmaciesScreen()));
                  },
                ),
                _drawerItem(
                  context,
                  Icons.emergency_rounded,
                  'Emergency',
                  text: text,
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const EmergencyScreen()));
                  },
                ),
                _drawerItem(
                  context,
                  Icons.settings_rounded,
                  'Settings',
                  text: text,
                  isDark: isDark,
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

          // ── Footer ──
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite, color: primary, size: 16),
                const SizedBox(width: 6),
                Text('Stay Healthy',
                    style: TextStyle(fontWeight: FontWeight.w600, color: text)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String title, {
    required Color text,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: primary, size: 20),
      ),
      title: Text(title,
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 15, color: text)),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      horizontalTitleGap: 8,
    );
  }
}
