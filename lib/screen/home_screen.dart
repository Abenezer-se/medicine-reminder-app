// lib/screen/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/medicine_provider.dart';
import '../providers/user_provider.dart';
import '../models/medicine.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/notification_button.dart';
import '../widgets/add_medicine_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color primary = Color(0xFF2EC4B6);
  static const Color accent = Color(0xFFFF6B6B);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFAA00);

  String getGreeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String getEmoji() {
    final h = DateTime.now().hour;
    if (h < 12) return '☀️';
    if (h < 17) return '🌤️';
    return '🌙';
  }

  @override
  Widget build(BuildContext context) {
    final medProvider = context.watch<MedicineProvider>();
    final userProvider = context.watch<UserProvider>();
    final medicines = medProvider.medicines;
    final name =
        userProvider.userName.isNotEmpty ? userProvider.userName : 'Friend';
    final now = DateTime.now();
    final dayName = DateFormat('EEEE').format(now);
    final dateStr = DateFormat('MMMM d, y').format(now);
    final total = medicines.length;
    final taken = medicines.where((m) => m.status == 'taken').length;
    final pending = medicines.where((m) => m.status == 'pending').length;
    final skipped = medicines.where((m) => m.status == 'skipped').length;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0D1117) : const Color(0xFFF0FAFA);
    final cardColor = isDark ? const Color(0xFF161B22) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('MediCare',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        actions: const [NotificationButton()],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header Banner ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              decoration: const BoxDecoration(
                color: primary,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${getGreeting()}, $name ${getEmoji()}',
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('$dayName, $dateStr',
                      style:
                          const TextStyle(fontSize: 14, color: Colors.white70)),
                  if (total > 0) ...[
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$taken of $total doses taken today',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13)),
                        Text(
                            '${total > 0 ? ((taken / total) * 100).toInt() : 0}%',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                        value: total > 0 ? taken / total : 0,
                        backgroundColor: Colors.white30,
                        valueColor: const AlwaysStoppedAnimation(Colors.white),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Stats ──
                  Row(
                    children: [
                      _statCard('Total', '$total', Icons.medication_rounded,
                          const Color(0xFF5B8DEF), cardColor),
                      const SizedBox(width: 10),
                      _statCard('Taken', '$taken', Icons.check_circle_rounded,
                          success, cardColor),
                      const SizedBox(width: 10),
                      _statCard('Pending', '$pending',
                          Icons.access_time_rounded, warning, cardColor),
                      const SizedBox(width: 10),
                      _statCard('Skipped', '$skipped', Icons.cancel_rounded,
                          accent, cardColor),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Today's Schedule ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Today's Schedule",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1A2E35))),
                      TextButton.icon(
                        onPressed: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const AddMedicineSheet(),
                        ),
                        icon: const Icon(Icons.add, color: primary),
                        label:
                            const Text('Add', style: TextStyle(color: primary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (medicines.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.medication_rounded,
                                  size: 48, color: primary),
                            ),
                            const SizedBox(height: 16),
                            Text('No medicines added yet',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white70
                                        : const Color(0xFF1A2E35))),
                            const SizedBox(height: 4),
                            const Text('Tap + to get started',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14)),
                          ],
                        ),
                      ),
                    )
                  else
                    ...medicines.map((med) => _medicineCard(
                        context, med, medProvider, cardColor, isDark)),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const AddMedicineSheet(),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add Medicine',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _medicineCard(BuildContext context, Medicine med,
      MedicineProvider provider, Color cardColor, bool isDark) {
    Color statusColor;
    IconData statusIcon;
    if (med.status == 'taken') {
      statusColor = success;
      statusIcon = Icons.check_circle_rounded;
    } else if (med.status == 'skipped') {
      statusColor = accent;
      statusIcon = Icons.cancel_rounded;
    } else {
      statusColor = warning;
      statusIcon = Icons.access_time_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(Icons.medication_rounded,
                      color: primary, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(med.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1A2E35))),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 12, color: Colors.grey),
                          const SizedBox(width: 3),
                          Text(med.time,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12)),
                          const SizedBox(width: 8),
                          const Icon(Icons.medication,
                              size: 12, color: Colors.grey),
                          const SizedBox(width: 3),
                          Text(med.dose,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 12, color: statusColor),
                      const SizedBox(width: 4),
                      Text(med.status.toUpperCase(),
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: statusColor)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Action Buttons Row ──
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.04)
                  : const Color(0xFFF8FFFE),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Taken
                _actionBtn(context, '✅ Taken', success, () {
                  provider.updateStatus(med, 'taken');
                }),
                // Skipped
                _actionBtn(context, '❌ Skip', accent, () {
                  provider.updateStatus(med, 'skipped');
                }),
                // Edit
                _actionBtn(context, '✏️ Edit', const Color(0xFF5B8DEF),
                    () => _showEditDialog(context, med, provider)),
                // Delete
                _actionBtn(context, '🗑️ Delete', Colors.grey,
                    () => _confirmDelete(context, med, provider)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(
      BuildContext context, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 12, color: color, fontWeight: FontWeight.w600)),
      ),
    );
  }

  void _showEditDialog(
      BuildContext context, Medicine med, MedicineProvider provider) {
    final nameCtrl = TextEditingController(text: med.name);
    final doseCtrl = TextEditingController(text: med.dose);
    final timeCtrl = TextEditingController(text: med.time);
    final startCtrl = TextEditingController(text: med.startDate);
    final endCtrl = TextEditingController(text: med.endDate);
    String frequency = med.frequency;

    final frequencies = [
      'Once Daily',
      'Twice Daily',
      'Three Times Daily',
      'Every 8 Hours',
      'Every 12 Hours',
      'As Needed'
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Edit Medicine',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _editField('Medicine Name', nameCtrl),
                const SizedBox(height: 12),
                _editField('Dose', doseCtrl),
                const SizedBox(height: 12),
                // Frequency dropdown
                DropdownButtonFormField<String>(
                  value: frequency,
                  decoration: InputDecoration(
                    labelText: 'Frequency',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  items: frequencies
                      .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                      .toList(),
                  onChanged: (v) => setStateDialog(() => frequency = v!),
                ),
                const SizedBox(height: 12),
                // Time picker field
                GestureDetector(
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: ctx,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) {
                      final h =
                          picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
                      final m = picked.minute.toString().padLeft(2, '0');
                      final p = picked.period == DayPeriod.am ? 'AM' : 'PM';
                      timeCtrl.text = '$h:$m $p';
                    }
                  },
                  child: AbsorbPointer(
                    child: _editField('Alarm Time (tap to pick)', timeCtrl),
                  ),
                ),
                const SizedBox(height: 12),
                _editField('Start Date', startCtrl),
                const SizedBox(height: 12),
                _editField('End Date', endCtrl),
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
                          provider.updateMedicine(
                            med,
                            name: nameCtrl.text.trim(),
                            dose: doseCtrl.text.trim(),
                            frequency: frequency,
                            time: timeCtrl.text.trim(),
                            startDate: startCtrl.text.trim(),
                            endDate: endCtrl.text.trim(),
                          );
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Medicine updated!'),
                              backgroundColor: primary,
                            ),
                          );
                        },
                        style:
                            ElevatedButton.styleFrom(backgroundColor: primary),
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
      ),
    );
  }

  Widget _editField(String label, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, Medicine med, MedicineProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Medicine?'),
        content: Text('Remove ${med.name} and cancel its alarm?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              provider.deleteMedicine(med);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: accent),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _statCard(
      String label, String value, IconData icon, Color color, Color cardColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
