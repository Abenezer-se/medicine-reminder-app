


// lib/screen/setting_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../providers/setting_provider.dart';
import '../services/alarm_service.dart';
import '../widgets/notification_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const Color primary = Color(0xFF2EC4B6);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final user = Provider.of<UserProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF161B22) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A2E35);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: const [NotificationButton()],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Profile Banner ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              decoration: const BoxDecoration(
                color: primary,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Text(
                      user.userName.isNotEmpty
                          ? user.userName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                          fontSize: 36,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user.userName.isNotEmpty ? user.userName : 'Your Name',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    user.userEmail.isNotEmpty
                        ? user.userEmail
                        : 'Tap Edit to set up profile',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: () => _showEditProfile(context, user),
                    icon: const Icon(Icons.edit_rounded,
                        color: Colors.white, size: 16),
                    label: const Text('Edit Profile',
                        style: TextStyle(color: Colors.white)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Appearance ──
                  _sectionTitle('Appearance', textColor),
                  _card(cardColor, [
                    SwitchListTile(
                      title: Text('Dark Mode',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: textColor)),
                      subtitle: const Text('Switch app theme',
                          style: TextStyle(color: Colors.grey)),
                      secondary: _iconBox(Icons.dark_mode),
                      value: theme.isDark,
                      onChanged: theme.toggleTheme,
                      activeColor: primary,
                    ),
                  ]),

                  const SizedBox(height: 16),

                  // ── Alarm Sound ──
                  _sectionTitle('Alarm Sound', textColor),
                  _card(cardColor, [
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _iconBox(Icons.music_note),
                              const SizedBox(width: 12),
                              Text('Choose Alarm Sound',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: textColor)),
                            ],
                          ),
                          const SizedBox(height: 14),
                          // 3 sound options
                          ...AlarmService.sounds.map((sound) {
                            final isSelected =
                                settings.selectedSound == sound['asset'];
                            return GestureDetector(
                              onTap: () => settings.setSound(sound['asset']!),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? primary
                                      : isDark
                                          ? const Color(0xFF21262D)
                                          : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? primary
                                        : Colors.transparent,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_off,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      sound['name']!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: isSelected
                                              ? Colors.white
                                              : textColor),
                                    ),
                                    const Spacer(),
                                    Icon(Icons.music_note,
                                        size: 16,
                                        color: isSelected
                                            ? Colors.white70
                                            : Colors.grey),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ]),

                  const SizedBox(height: 16),

                  // ── Notifications ──
                  _sectionTitle('Notifications', textColor),
                  _card(cardColor, [
                    SwitchListTile(
                      title: Text('Sound',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: textColor)),
                      subtitle: const Text('Play sound for reminders',
                          style: TextStyle(color: Colors.grey)),
                      secondary: _iconBox(Icons.volume_up),
                      value: settings.soundEnabled,
                      onChanged: settings.setSoundEnabled,
                      activeColor: primary,
                    ),
                    Divider(
                        height: 1,
                        indent: 16,
                        color: isDark ? Colors.white12 : Colors.grey.shade200),
                    SwitchListTile(
                      title: Text('Vibration',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: textColor)),
                      subtitle: const Text('Vibrate on alarm',
                          style: TextStyle(color: Colors.grey)),
                      secondary: _iconBox(Icons.vibration),
                      value: settings.vibrateEnabled,
                      onChanged: settings.setVibrateEnabled,
                      activeColor: primary,
                    ),
                    Divider(
                        height: 1,
                        indent: 16,
                        color: isDark ? Colors.white12 : Colors.grey.shade200),
                    ListTile(
                      leading: _iconBox(Icons.timer),
                      title: Text('Reminder Lead Time',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: textColor)),
                      subtitle: const Text('How early to remind',
                          style: TextStyle(color: Colors.grey)),
                      trailing: DropdownButton<String>(
                        value: settings.reminderLeadTime,
                        underline: const SizedBox(),
                        dropdownColor:
                            isDark ? const Color(0xFF21262D) : Colors.white,
                        style: TextStyle(color: textColor),
                        items: [
                          '5 minutes',
                          '10 minutes',
                          '15 minutes',
                          '30 minutes',
                          '1 hour'
                        ]
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) settings.setLeadTime(v);
                        },
                      ),
                    ),
                  ]),

                  const SizedBox(height: 16),

                  // ── About ──
                  _sectionTitle('About', textColor),
                  _card(cardColor, [
                    ListTile(
                      leading: const Icon(Icons.info_rounded, color: primary),
                      title: Text('MediCare',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: textColor)),
                      subtitle: const Text('Version 1.0.0',
                          style: TextStyle(color: Colors.grey)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(
                        'This app helps you manage medications and track your health. Not a substitute for professional medical advice.',
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 13, height: 1.5),
                      ),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // ── Logout ──
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logout coming soon')),
                      ),
                      icon: const Icon(Icons.logout_rounded,
                          color: Color(0xFFFF6B6B)),
                      label: const Text('Logout',
                          style: TextStyle(
                              color: Color(0xFFFF6B6B),
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFF6B6B)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconBox(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: primary, size: 20),
    );
  }

  Widget _sectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: color)),
    );
  }

  Widget _card(Color color, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  void _showEditProfile(BuildContext context, UserProvider user) {
    final nameCtrl = TextEditingController(text: user.userName);
    final emailCtrl = TextEditingController(text: user.userEmail);

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Edit Profile',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: const Icon(Icons.person, color: primary),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email, color: primary),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel')),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        user.updateUser(
                            name: nameCtrl.text, email: emailCtrl.text);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profile updated!'),
                            backgroundColor: primary,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: primary),
                      child: const Text('Save',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
