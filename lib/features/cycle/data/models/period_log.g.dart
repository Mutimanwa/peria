// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'period_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PeriodLogAdapter extends TypeAdapter<PeriodLog> {
  @override
  final int typeId = 2;

  @override
  PeriodLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PeriodLog(
      id: fields[0] as String,
      startDate: fields[1] as DateTime,
      endDate: fields[2] as DateTime,
      isEstimated: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PeriodLog obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.startDate)
      ..writeByte(2)
      ..write(obj.endDate)
      ..writeByte(3)
      ..write(obj.isEstimated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PeriodLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
