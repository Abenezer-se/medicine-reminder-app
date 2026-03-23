import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 Profile
            ListTile(
              leading: const CircleAvatar(child: Text("T")),
              title: const Text("Your Name"),
              subtitle: const Text("email@example.com"),
            ),

            const SizedBox(height: 20),

            // 🔹 Dark Mode
            SwitchListTile(
              title: const Text("Dark Mode"),
              value: themeProvider.isDark,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
