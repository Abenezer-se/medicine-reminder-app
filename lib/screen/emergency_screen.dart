

// lib/screen/emergency_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/emergency_provider.dart';
import '../models/emergency_contact.dart';
import '../utils/theme_helper.dart';
import '../widgets/notification_button.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  static const Color primary = Color(0xFF2EC4B6);
  static const Color danger = Color(0xFFFF6B6B);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EmergencyProvider>();
    final bg = TH.bg(context);
    final card = TH.card(context);
    final text = TH.text(context);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('Emergency',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: const [NotificationButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Alert button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B6B), Color(0xFFFF4444)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                      color: danger.withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 8))
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle),
                    child: const Icon(Icons.warning_amber_rounded,
                        size: 52, color: Colors.white),
                  ),
                  const SizedBox(height: 14),
                  const Text('Emergency Alert',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 6),
                  const Text(
                      'Press to send an emergency SMS\nto all your contacts',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _sendAlert(context, provider),
                      icon: const Icon(Icons.send_rounded, color: danger),
                      label: const Text('Send Emergency Alert',
                          style: TextStyle(
                              color: danger,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick actions
            Row(
              children: [
                Expanded(
                    child: _quickAction('Ambulance', Icons.local_hospital,
                        const Color(0xFF5B8DEF), card, () => _call('911'))),
                const SizedBox(width: 12),
                Expanded(
                    child: _quickAction('Health Hotline', Icons.phone,
                        const Color(0xFF4CAF50), card, () => _call('8338'))),
              ],
            ),
            const SizedBox(height: 24),

            // Contacts header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Emergency Contacts',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: text)),
                TextButton.icon(
                  onPressed: () => _showAddDialog(context, provider),
                  icon: const Icon(Icons.add, color: primary),
                  label: const Text('Add', style: TextStyle(color: primary)),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (provider.contacts.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                    color: card, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    Icon(Icons.contacts_rounded,
                        size: 48, color: TH.subText(context)),
                    const SizedBox(height: 10),
                    Text('No emergency contacts yet',
                        style: TextStyle(
                            color: TH.subText(context), fontSize: 15)),
                    Text('Tap Add to add a contact',
                        style: TextStyle(
                            color: TH.subText(context), fontSize: 13)),
                  ],
                ),
              )
            else
              ...provider.contacts.map((c) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 3))
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      leading: CircleAvatar(
                        backgroundColor: primary.withOpacity(0.15),
                        child: Text(
                            c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                            style: const TextStyle(
                                color: primary, fontWeight: FontWeight.bold)),
                      ),
                      title: Text(c.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: text)),
                      subtitle: Text('${c.relation} • ${c.phone}',
                          style: TextStyle(
                              fontSize: 12, color: TH.subText(context))),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.phone_rounded,
                                  color: primary, size: 20),
                              onPressed: () => _call(c.phone)),
                          IconButton(
                              icon: const Icon(Icons.delete_rounded,
                                  color: Color(0xFFFF6B6B), size: 20),
                              onPressed: () =>
                                  _confirmDelete(context, provider, c)),
                        ],
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _quickAction(String label, IconData icon, Color color, Color card,
      VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(label,
                style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Future<void> _call(String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _sendAlert(BuildContext context, EmergencyProvider provider) {
    if (provider.contacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please add at least one emergency contact'),
        backgroundColor: Color(0xFFFF6B6B),
      ));
      return;
    }
    final phones = provider.contacts.map((c) => c.phone).join(',');
    final uri = Uri.parse(
        'sms:$phones?body=🚨 EMERGENCY! I need help. Please contact me immediately.');
    launchUrl(uri);
  }

  void _showAddDialog(BuildContext context, EmergencyProvider provider) {
    final nameCtrl = TextEditingController();
    final relCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Add Contact',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _dField('Full Name', Icons.person, nameCtrl),
              const SizedBox(height: 12),
              _dField('Relation', Icons.people, relCtrl),
              const SizedBox(height: 12),
              _dField('Phone Number', Icons.phone, phoneCtrl, phone: true),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'))),
                  const SizedBox(width: 12),
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () {
                      if (nameCtrl.text.isNotEmpty &&
                          phoneCtrl.text.isNotEmpty) {
                        provider.addContact(EmergencyContact(
                          name: nameCtrl.text.trim(),
                          relation: relCtrl.text.trim().isEmpty
                              ? 'Contact'
                              : relCtrl.text.trim(),
                          phone: phoneCtrl.text.trim(),
                        ));
                        Navigator.pop(ctx);
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: primary),
                    child: const Text('Add',
                        style: TextStyle(color: Colors.white)),
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dField(String label, IconData icon, TextEditingController ctrl,
      {bool phone = false}) {
    return TextField(
      controller: ctrl,
      keyboardType: phone ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, EmergencyProvider provider, EmergencyContact c) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Contact?'),
        content: Text('Remove ${c.name} from emergency contacts?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              provider.removeContact(c);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: danger),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
