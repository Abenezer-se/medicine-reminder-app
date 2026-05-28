// lib/screen/alarm_ring_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/medicine_provider.dart';
import '../providers/emergency_provider.dart';
import '../services/alarm_service.dart';
import '../models/medicine.dart';

class AlarmRingScreen extends StatefulWidget {
  final String medicineName;
  final String dose;
  final String time;
  final String alarmSound;
  final Medicine? medicine;

  const AlarmRingScreen({
    super.key,
    required this.medicineName,
    required this.dose,
    required this.time,
    required this.alarmSound,
    this.medicine,
  });

  @override
  State<AlarmRingScreen> createState() => _AlarmRingScreenState();
}

class _AlarmRingScreenState extends State<AlarmRingScreen>
    with SingleTickerProviderStateMixin {
  static const Color primary = Color(0xFF2EC4B6);
  late AnimationController _pulseCtrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulse = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    // Play sound
    AlarmService().playSound(widget.alarmSound);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    AlarmService().stopSound();
    super.dispose();
  }

  void _taken() {
    AlarmService().stopSound();
    if (widget.medicine != null) {
      context.read<MedicineProvider>().updateStatus(widget.medicine!, 'taken');
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Great! Medicine marked as taken.'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
  }

  Future<void> _snooze() async {
    AlarmService().stopSound();
    if (widget.medicine != null) {
      final DateTime snoozeTime =
          DateTime.now().add(const Duration(minutes: 10));
      await AlarmService().scheduleAlarm(
        id: widget.medicine!.key.hashCode + 9999,
        medicineName: widget.medicineName,
        dose: widget.dose,
        dateTime: snoozeTime,
        assetAudioPath: widget.alarmSound,
      );
    }
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Snoozed for 10 minutes'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _sendSMS() {
    final contacts = context.read<EmergencyProvider>().contacts;
    if (contacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'No emergency contacts. Add contacts in Emergency screen first.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    AlarmService.sendSMS(
      medicineName: widget.medicineName,
      dose: widget.dose,
      phones: contacts.map((c) => c.phone).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: primary,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Pulsing medicine icon
                  ScaleTransition(
                    scale: _pulse,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 3,
                        ),
                      ),
                      child: const Icon(
                        Icons.medication_rounded,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    'Medicine Reminder',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 14),

                  Text(
                    widget.medicineName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Dose: ${widget.dose}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'Time: ${widget.time}',
                    style: const TextStyle(fontSize: 14, color: Colors.white60),
                  ),

                  const SizedBox(height: 48),

                  // I TOOK IT button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _taken,
                      icon: const Icon(Icons.check_circle_rounded, size: 26),
                      label: const Text(
                        'I Took It — Stop Alarm',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: primary,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // SNOOZE button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _snooze,
                      icon:
                          const Icon(Icons.snooze_rounded, color: Colors.white),
                      label: const Text(
                        'Snooze 10 min',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // SEND SMS button
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: _sendSMS,
                      icon: const Icon(Icons.sms_rounded,
                          color: Colors.white70, size: 20),
                      label: const Text(
                        'Send SMS to Emergency Contacts',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
