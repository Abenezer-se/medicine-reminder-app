// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicineAdapter extends TypeAdapter<Medicine> {
  @override
  final typeId = 0;

  @override
  Medicine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Medicine(
      name: fields[0] as String,
      dose: fields[1] as String,
      frequency: fields[2] as String,
      time: fields[3] as String,
      remainingDoses: (fields[4] as num).toInt(),
      startDate: fields[5] as String,
      endDate: fields[6] as String,
      status: fields[7] == null ? "pending" : fields[7] as String,
      alarmSound: fields[8] == null
          ? 'assets/alarm_sounds/gentle_bell.mp3'
          : fields[8] as String,
      vibrateEnabled: fields[9] == null ? true : fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Medicine obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.dose)
      ..writeByte(2)
      ..write(obj.frequency)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.remainingDoses)
      ..writeByte(5)
      ..write(obj.startDate)
      ..writeByte(6)
      ..write(obj.endDate)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.alarmSound)
      ..writeByte(9)
      ..write(obj.vibrateEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
