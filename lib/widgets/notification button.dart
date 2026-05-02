// lib/widgets/notification_button.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/medicine_provider.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  void _showNotifications(BuildContext context) {
    final provider = context.read<MedicineProvider>();
    final medicines = provider.medicines;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Reminders",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (medicines.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Icon(Icons.notifications_off,
                          size: 60, color: Colors.grey),
                      SizedBox(height: 12),
                      Text(
                        "No reminders yet",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      Text(
                        "Add medicines to see upcoming reminders",
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                ...medicines.map((med) => ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2EC4B6).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.medication,
                            color: Color(0xFF2EC4B6)),
                      ),
                      title: Text(med.name,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(med.time),
                      trailing: const Icon(Icons.notifications_active,
                          color: Colors.orange),
                    )),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.notifications),
      onPressed: () => _showNotifications(context),
      tooltip: "Notifications",
    );
  }
}