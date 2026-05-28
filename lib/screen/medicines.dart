// lib/screen/medicines.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/medicine_provider.dart';
import '../models/medicine.dart';
import '../utils/theme_helper.dart';
import '../widgets/notification_button.dart';
import '../widgets/add_medicine_sheet.dart';

class MedicinesScreen extends StatelessWidget {
  const MedicinesScreen({super.key});

  static const Color primary = Color(0xFF2EC4B6);
  static const Color accent = Color(0xFFFF6B6B);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFAA00);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MedicineProvider>();
    final medicines = provider.medicines;
    final bg = TH.bg(context);
    final card = TH.card(context);
    final text = TH.text(context);
    final isDark = TH.isDark(context);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('Medicines',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (medicines.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded),
              tooltip: 'Delete All',
              onPressed: () => _confirmDeleteAll(context, provider),
            ),
          const NotificationButton(),
        ],
      ),
      body: Column(
        children: [
          // ── Header summary ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            decoration: const BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: Row(
              children: [
                _summaryPill('Total', '${medicines.length}'),
                const SizedBox(width: 8),
                _summaryPill('Taken',
                    '${medicines.where((m) => m.status == "taken").length}'),
                const SizedBox(width: 8),
                _summaryPill('Pending',
                    '${medicines.where((m) => m.status == "pending").length}'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── List ──
          Expanded(
            child: medicines.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.medication_rounded,
                              size: 56, color: primary),
                        ),
                        const SizedBox(height: 16),
                        Text('No medicines yet',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: text)),
                        const SizedBox(height: 6),
                        Text('Tap + to add your first medicine',
                            style: TextStyle(
                                color: TH.subText(context), fontSize: 14)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: medicines.length,
                    itemBuilder: (context, index) {
                      return _medicineCard(context, medicines[index], provider,
                          card, text, isDark);
                    },
                  ),
          ),
        ],
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

  Widget _medicineCard(
    BuildContext context,
    Medicine med,
    MedicineProvider provider,
    Color card,
    Color text,
    bool isDark,
  ) {
    Color statusColor;
    String statusLabel;
    if (med.status == 'taken') {
      statusColor = success;
      statusLabel = 'TAKEN';
    } else if (med.status == 'skipped') {
      statusColor = accent;
      statusLabel = 'SKIPPED';
    } else {
      statusColor = warning;
      statusLabel = 'PENDING';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Top info row ──
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.medication_rounded,
                      color: primary, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(med.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: text)),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        children: [
                          _infoChip(Icons.medication, med.dose),
                          _infoChip(Icons.repeat, med.frequency),
                          _infoChip(Icons.access_time, med.time),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(statusLabel,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: statusColor)),
                ),
              ],
            ),
          ),

          // ── Bottom actions row ──
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.04)
                  : const Color(0xFFF0FAFA),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(18)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                // Date info
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 11, color: TH.subText(context)),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          med.startDate.isNotEmpty ? med.startDate : 'No date',
                          style: TextStyle(
                              fontSize: 11, color: TH.subText(context)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                // Action buttons
                Row(
                  children: [
                    _actionBtn('✅', success,
                        () => provider.updateStatus(med, 'taken')),
                    const SizedBox(width: 6),
                    _actionBtn('❌', accent,
                        () => provider.updateStatus(med, 'skipped')),
                    const SizedBox(width: 6),
                    _actionBtn('✏️', const Color(0xFF5B8DEF),
                        () => _showEditDialog(context, med, provider)),
                    const SizedBox(width: 6),
                    _actionBtn('🗑️', Colors.grey,
                        () => _confirmDelete(context, med, provider)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: Colors.grey),
        const SizedBox(width: 3),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _actionBtn(String emoji, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  Widget _summaryPill(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16)),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
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
                _editField(ctx, 'Medicine Name', nameCtrl),
                const SizedBox(height: 12),
                _editField(ctx, 'Dose', doseCtrl),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: frequency,
                  decoration: InputDecoration(
                    labelText: 'Frequency',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: primary, width: 2),
                    ),
                  ),
                  items: frequencies
                      .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                      .toList(),
                  onChanged: (v) => setStateDialog(() => frequency = v!),
                ),
                const SizedBox(height: 12),
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
                    child:
                        _editField(ctx, 'Alarm Time (tap to pick)', timeCtrl),
                  ),
                ),
                const SizedBox(height: 12),
                _editField(ctx, 'Start Date', startCtrl),
                const SizedBox(height: 12),
                _editField(ctx, 'End Date', endCtrl),
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

  Widget _editField(
      BuildContext context, String label, TextEditingController ctrl) {
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

  void _confirmDeleteAll(BuildContext context, MedicineProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete All Medicines?'),
        content:
            const Text('This will remove all medicines and cancel all alarms.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              provider.deleteAll();
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: accent),
            child:
                const Text('Delete All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
