import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/medicine_provider.dart';

class MedicinesScreen extends StatelessWidget {
  const MedicinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final medicines = context.watch<MedicineProvider>().medicines;

    return Scaffold(
      appBar: AppBar(title: const Text("Medicines")),
      body: medicines.isEmpty
          ? const Center(child: Text("No medicines added"))
          : ListView.builder(
              itemCount: medicines.length,
              itemBuilder: (context, index) {
                final med = medicines[index];

                return ListTile(
                  title: Text(med.name),
                  subtitle: Text("Dose: ${med.dose}"),
                );
              },
            ),
    );
  }
}
