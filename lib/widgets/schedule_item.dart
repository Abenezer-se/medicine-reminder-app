import 'package:flutter/material.dart';

class ScheduleItem extends StatelessWidget {
  final String name;
  final String time;

  const ScheduleItem({super.key, required this.name, required this.time});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text(time),
      trailing: const Icon(Icons.check),
    );
  }
}
