

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/medicine_provider.dart';
import '../providers/setting_provider.dart';
import '../services/alarm_service.dart';
import '../utils/theme_helper.dart';

class AddMedicineSheet extends StatefulWidget {
  const AddMedicineSheet({super.key});

  @override
  State<AddMedicineSheet> createState() => _AddMedicineSheetState();
}

class _AddMedicineSheetState extends State<AddMedicineSheet> {
  static const Color primary = Color(0xFF2EC4B6);

  final nameController = TextEditingController();
  final doseAmountController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  String _doseUnit = 'mg';
  String _frequency = 'Once Daily';
  String? _selectedSound;
  bool _vibrateEnabled = true;
  final List<TimeOfDay> _times = [];

  final List<String> _doseUnits = ['mg', 'ml', 'g', 'Pills', 'Drops', 'Units'];

  // frequency → how many times required
  final Map<String, int> _frequencyTimes = {
    'Once Daily': 1,
    'Twice Daily': 2,
    'Three Times Daily': 3,
    'Every 8 Hours': 3,
    'Every 12 Hours': 2,
    'As Needed': 0,
  };

  final List<String> _frequencies = [
    'Once Daily',
    'Twice Daily',
    'Three Times Daily',
    'Every 8 Hours',
    'Every 12 Hours',
    'As Needed',
  ];

  int get _requiredTimes => _frequencyTimes[_frequency] ?? 1;

  String get _timesHint {
    switch (_frequency) {
      case 'Once Daily':
        return 'Add 1 time (e.g. Morning)';
      case 'Twice Daily':
      case 'Every 12 Hours':
        return 'Add 2 times (e.g. Morning & Night)';
      case 'Three Times Daily':
      case 'Every 8 Hours':
        return 'Add 3 times (e.g. Morning, Afternoon & Night)';
      case 'As Needed':
        return 'Add at least 1 time';
      default:
        return 'Add time';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedSound ??=
        Provider.of<SettingsProvider>(context, listen: false).selectedSound;
  }

  Future<void> _pickTime() async {
    final int required = _frequency == 'As Needed' ? 99 : _requiredTimes;

    if (_times.length >= required) {
      _snack('You can only add $_requiredTimes time(s) for $_frequency');
      return;
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _times.add(picked));
  }

  Future<void> _pickDate(TextEditingController ctrl) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      ctrl.text = '${picked.day} ${_monthName(picked.month)} ${picked.year}';
    }
  }

  String _monthName(int m) => const [
        '',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ][m];

  String _fmtTime(TimeOfDay t) {
    final int h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final String m = t.minute.toString().padLeft(2, '0');
    final String p = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $p';
  }

  // Validate times match frequency
  String? _validateTimes() {
    if (_frequency == 'As Needed') {
      if (_times.isEmpty) {
        return 'Please add at least one alarm time';
      }
      return null;
    }
    final int required = _requiredTimes;
    if (_times.length < required) {
      final int remaining = required - _times.length;
      return 'Please add $remaining more time(s) for $_frequency';
    }
    return null;
  }

  void _save() {
    final String name = nameController.text.trim();
    final String doseAmt = doseAmountController.text.trim();

    if (name.isEmpty) {
      _snack('Please enter medicine name');
      return;
    }
    if (doseAmt.isEmpty) {
      _snack('Please enter dose amount');
      return;
    }

    final String? timeError = _validateTimes();
    if (timeError != null) {
      _snack(timeError);
      return;
    }

    final String dose = '$doseAmt $_doseUnit';
    // Use first time as primary; schedule alarm for all times
    final String primaryTime = _fmtTime(_times.first);

    final MedicineProvider provider = context.read<MedicineProvider>();

    // Add one medicine entry per time slot
    for (int i = 0; i < _times.length; i++) {
      final String timeStr = _fmtTime(_times[i]);
      provider.addMedicine(
        name: name,
        dose: dose,
        frequency: _frequency,
        time: timeStr,
        remainingDoses: 7,
        startDate: startDateController.text.isNotEmpty
            ? startDateController.text
            : '${DateTime.now().day} ${_monthName(DateTime.now().month)} ${DateTime.now().year}',
        endDate: endDateController.text,
        alarmSound: _selectedSound ?? AlarmService.sounds[0]['asset']!,
        vibrateEnabled: _vibrateEnabled,
      );
    }

    Navigator.pop(context);
    _snack(
      '✅ $name saved — ${_times.length} alarm(s) set',
      success: true,
    );
  }

  void _snack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: success ? primary : Colors.red.shade600,
    ));
  }

  InputDecoration _inputDec(String label, {IconData? icon}) => InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: TH.subText(context)),
        prefixIcon: icon != null ? Icon(icon, color: primary) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        filled: true,
        fillColor: TH.inputFill(context),
      );

  @override
  Widget build(BuildContext context) {
    final Color card = TH.card(context);
    final Color text = TH.text(context);
    final bool isDark = TH.isDark(context);

    return Container(
      decoration: BoxDecoration(
        color: card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(99)),
          ),

          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 8, 16),
            decoration: const BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                const Icon(Icons.medication, color: Colors.white, size: 26),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Add Medicine',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Medicine Name
                  TextField(
                    controller: nameController,
                    style: TextStyle(color: text),
                    decoration:
                        _inputDec('Medicine Name *', icon: Icons.medication),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),

                  // Dose
                  _label('Dose *', text),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: doseAmountController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: text),
                          decoration: _inputDec('Amount'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(12),
                            color: TH.inputFill(context),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _doseUnit,
                              isExpanded: true,
                              dropdownColor: card,
                              style: TextStyle(color: text),
                              icon:
                                  const Icon(Icons.expand_more, color: primary),
                              items: _doseUnits
                                  .map((u) => DropdownMenuItem(
                                      value: u, child: Text(u)))
                                  .toList(),
                              onChanged: (v) => setState(() => _doseUnit = v!),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Frequency
                  _label('Frequency', text),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                      color: TH.inputFill(context),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _frequency,
                        isExpanded: true,
                        dropdownColor: card,
                        style: TextStyle(color: text),
                        icon: const Icon(Icons.expand_more, color: primary),
                        items: _frequencies
                            .map((f) =>
                                DropdownMenuItem(value: f, child: Text(f)))
                            .toList(),
                        onChanged: (v) {
                          setState(() {
                            _frequency = v!;
                            // Clear times when frequency changes
                            _times.clear();
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Alarm Times
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _label('Alarm Time *', text),
                      // Progress indicator
                      if (_frequency != 'As Needed')
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _times.length == _requiredTimes
                                ? primary.withOpacity(0.15)
                                : Colors.orange.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_times.length} / $_requiredTimes',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _times.length == _requiredTimes
                                  ? primary
                                  : Colors.orange,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Hint text
                  Text(
                    _timesHint,
                    style: TextStyle(fontSize: 12, color: TH.subText(context)),
                  ),
                  const SizedBox(height: 8),

                  // Time chips
                  if (_times.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: _times
                          .asMap()
                          .entries
                          .map((e) => Chip(
                                avatar: const Icon(Icons.alarm,
                                    size: 16, color: primary),
                                label: Text(_fmtTime(e.value),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                backgroundColor: primary.withOpacity(0.1),
                                deleteIcon: const Icon(Icons.close, size: 16),
                                onDeleted: () =>
                                    setState(() => _times.removeAt(e.key)),
                              ))
                          .toList(),
                    ),
                  const SizedBox(height: 8),

                  // Add time button — disabled when max reached
                  OutlinedButton.icon(
                    onPressed: (_frequency != 'As Needed' &&
                            _times.length >= _requiredTimes)
                        ? null
                        : _pickTime,
                    icon: const Icon(Icons.add_alarm, color: primary),
                    label: Text(
                      _frequency == 'As Needed'
                          ? 'Add Time'
                          : _times.length >= _requiredTimes
                              ? 'All times added ✓'
                              : 'Add Time (${_requiredTimes - _times.length} remaining)',
                      style: const TextStyle(color: primary),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: _times.length == _requiredTimes
                            ? primary
                            : Colors.orange,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Alarm Sound
                  _label('Alarm Sound', text),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                      color: TH.inputFill(context),
                    ),
                    child: Column(
                      children: [
                        ...AlarmService.sounds.map((sound) {
                          final bool isSelected =
                              _selectedSound == sound['asset'];
                          return GestureDetector(
                            onTap: () => setState(
                                () => _selectedSound = sound['asset']!),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? primary
                                    : (isDark
                                        ? const Color(0xFF21262D)
                                        : Colors.white),
                                border: Border.all(
                                    color: isSelected
                                        ? primary
                                        : Colors.transparent),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    color:
                                        isSelected ? Colors.white : Colors.grey,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    sound['name']!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color:
                                            isSelected ? Colors.white : text),
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

                        Divider(color: TH.divider(context)),

                        // Vibrate toggle
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              const Icon(Icons.vibration,
                                  color: primary, size: 20),
                              const SizedBox(width: 8),
                              Text('Vibration',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: text)),
                            ]),
                            Switch(
                              value: _vibrateEnabled,
                              activeColor: primary,
                              onChanged: (v) =>
                                  setState(() => _vibrateEnabled = v),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Duration
                  _label('Duration', text),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: startDateController,
                          readOnly: true,
                          style: TextStyle(color: text),
                          decoration: _inputDec('Start Date',
                                  icon: Icons.calendar_today)
                              .copyWith(
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.edit_calendar,
                                  color: primary),
                              onPressed: () => _pickDate(startDateController),
                            ),
                          ),
                          onTap: () => _pickDate(startDateController),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: endDateController,
                          readOnly: true,
                          style: TextStyle(color: text),
                          decoration:
                              _inputDec('End Date', icon: Icons.event).copyWith(
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.edit_calendar,
                                  color: primary),
                              onPressed: () => _pickDate(endDateController),
                            ),
                          ),
                          onTap: () => _pickDate(endDateController),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _save,
                      icon: const Icon(Icons.alarm_add, color: Colors.white),
                      label: const Text(
                        'Save & Set Alarm',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String t, Color color) => Text(t,
      style:
          TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color));
}
