// lib/screen/emergency_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/emergency_provider.dart';
import '../models/emergency_contact.dart';
import '../widgets/notification_button.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EmergencyProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency"),
        backgroundColor: const Color(0xFF2EC4B6),
        foregroundColor: Colors.white,
        actions: const [NotificationButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Alert Icon
            Container(
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                  color: Colors.red, shape: BoxShape.circle),
              child: const Icon(Icons.warning_amber_rounded,
                  size: 90, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text("Emergency Alert",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.red)),
            const Text(
              "Press the button to send an emergency alert to all your contacts",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () => _sendEmergencyAlert(context, provider),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 62),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.white),
                  SizedBox(width: 10),
                  Text("Send Emergency Alert",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ],
              ),
            ),

            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Emergency Contacts",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: () => _showAddContactDialog(context, provider),
                  icon: const Icon(Icons.add),
                  label: const Text("Add"),
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (provider.contacts.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Text("No emergency contacts added yet",
                    style: TextStyle(color: Colors.grey, fontSize: 16)),
              )
            else
              ...provider.contacts.map((contact) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF2EC4B6),
                        child: Text(
                          contact.relation.isNotEmpty
                              ? contact.relation[0].toUpperCase()
                              : "?",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(contact.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${contact.relation}\n${contact.phone}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _confirmDeleteContact(context, provider, contact),
                      ),
                    ),
                  )),

            const SizedBox(height: 32),

            const Text("Quick Actions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: _quickActionButton(
                        "Call", Icons.phone, Colors.red, () {})),
                const SizedBox(width: 16),
                Expanded(
                    child: _quickActionButton(
                        "Health Hotline", Icons.phone, Colors.green, () {})),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddContactDialog(BuildContext context, EmergencyProvider provider) {
    final nameCtrl = TextEditingController();
    final relationCtrl = TextEditingController();
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
              const Text("Add Emergency Contact",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                      labelText: "Full Name", border: OutlineInputBorder())),
              const SizedBox(height: 16),
              TextField(
                  controller: relationCtrl,
                  decoration: const InputDecoration(
                      labelText: "Relation", border: OutlineInputBorder())),
              const SizedBox(height: 16),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    labelText: "Phone Number", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text("Cancel")),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (nameCtrl.text.isNotEmpty &&
                            phoneCtrl.text.isNotEmpty) {
                          provider.addContact(
                            EmergencyContact(
                              name: nameCtrl.text.trim(),
                              relation: relationCtrl.text.trim().isEmpty
                                  ? "Contact"
                                  : relationCtrl.text.trim(),
                              phone: phoneCtrl.text.trim(),
                            ),
                          );
                          Navigator.pop(ctx);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2EC4B6)),
                      child: const Text("Add Contact"),
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

  void _confirmDeleteContact(BuildContext context, EmergencyProvider provider,
      EmergencyContact contact) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Contact?"),
        content: Text("Remove ${contact.name} from emergency contacts?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              provider.removeContact(contact);
              Navigator.pop(ctx);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _sendEmergencyAlert(BuildContext context, EmergencyProvider provider) {
    if (provider.contacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please add at least one emergency contact first")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Opening SMS for all contacts..."),
          backgroundColor: Colors.red),
    );
  }

  Widget _quickActionButton(
      String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 18),
      ),
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
