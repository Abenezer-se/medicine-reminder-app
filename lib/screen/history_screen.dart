

// lib/screen/history_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/medicine_provider.dart';
import '../models/medicine.dart';
import '../utils/theme_helper.dart';
import '../widgets/notification_button.dart';
import '../widgets/add_medicine_sheet.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  static const Color primary = Color(0xFF2EC4B6);
  static const Color accent = Color(0xFFFF6B6B);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFAA00);

  String _filter = 'All';
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MedicineProvider>();
    final bg = TH.bg(context);
    final card = TH.card(context);
    final text = TH.text(context);
    final isDark = TH.isDark(context);

    var medicines = provider.medicines;
    if (_search.isNotEmpty) {
      medicines = medicines
          .where((m) => m.name.toLowerCase().contains(_search.toLowerCase()))
          .toList();
    }
    if (_filter != 'All') {
      medicines =
          medicines.where((m) => m.status == _filter.toLowerCase()).toList();
    }

    final taken = provider.medicines.where((m) => m.status == 'taken').length;
    final skipped =
        provider.medicines.where((m) => m.status == 'skipped').length;
    final pending =
        provider.medicines.where((m) => m.status == 'pending').length;
    final total = provider.medicines.length;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('History',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: const [NotificationButton()],
      ),
      body: Column(
        children: [
          // Banner with chart
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            decoration: const BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: SizedBox(
              height: 160,
              child: BarChart(BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: total > 0 ? total.toDouble() : 7,
                barGroups: [
                  _bar(0, taken.toDouble(), Colors.white),
                  _bar(1, pending.toDouble(), Colors.white.withOpacity(0.6)),
                  _bar(2, skipped.toDouble(), Colors.white.withOpacity(0.4)),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        final labels = ['Taken', 'Pending', 'Skipped'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(labels[v.toInt()],
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 11)),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
              )),
            ),
          ),

          // Search + filter
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Column(
              children: [
                TextField(
                  onChanged: (v) => setState(() => _search = v),
                  style: TextStyle(color: text),
                  decoration: InputDecoration(
                    hintText: 'Search medicines...',
                    hintStyle: TextStyle(color: TH.subText(context)),
                    prefixIcon: const Icon(Icons.search, color: primary),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: primary, width: 2),
                    ),
                    filled: true,
                    fillColor: card,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', 'Taken', 'Pending', 'Skipped']
                        .map((f) => _chip(f, isDark))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                DateFormat('EEEE, MMMM d, y').format(DateTime.now()),
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14, color: text),
              ),
            ),
          ),
          const SizedBox(height: 8),

          Expanded(
            child: medicines.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                              color: primary.withOpacity(0.1),
                              shape: BoxShape.circle),
                          child: const Icon(Icons.history_rounded,
                              size: 48, color: primary),
                        ),
                        const SizedBox(height: 12),
                        Text('No records found',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: text)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: medicines.length,
                    itemBuilder: (context, index) =>
                        _historyCard(medicines[index], card, text),
                  ),
          ),

          // Bottom buttons
          Container(
            padding: const EdgeInsets.all(16),
            color: card,
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.bolt_rounded, color: primary),
                    label: const Text('Quick Action',
                        style: TextStyle(color: primary)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const AddMedicineSheet(),
                    ),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Add Medicine',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _bar(int x, double y, Color color) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
          toY: y < 0 ? 0 : y,
          color: color,
          width: 36,
          borderRadius: BorderRadius.circular(6))
    ]);
  }

  Widget _chip(String label, bool isDark) {
    final active = _filter == label;
    Color chipColor;
    if (label == 'Taken')
      chipColor = success;
    else if (label == 'Skipped')
      chipColor = accent;
    else if (label == 'Pending')
      chipColor = warning;
    else
      chipColor = primary;

    return GestureDetector(
      onTap: () => setState(() => _filter = label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? chipColor
              : (isDark ? const Color(0xFF21262D) : Colors.white),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: active ? chipColor : Colors.grey.shade400),
          boxShadow: active
              ? [
                  BoxShadow(
                      color: chipColor.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3))
                ]
              : [],
        ),
        child: Text(label,
            style: TextStyle(
                color: active ? Colors.white : Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 13)),
      ),
    );
  }

  Widget _historyCard(Medicine med, Color card, Color text) {
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
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(statusIcon, color: statusColor, size: 24),
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
                        color: text)),
                const SizedBox(height: 2),
                Text('${med.dose} • ${med.time}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10)),
            child: Text(med.status.toUpperCase(),
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: statusColor)),
          ),
        ],
      ),
    );
  }
}
