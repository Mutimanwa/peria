// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 3;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      displayName: fields[0] as String?,
      dateOfBirth: fields[1] as DateTime?,
      averageCycleLengthDays: fields[2] as int,
      periodLengthDays: fields[3] as int,
      lastPeriodStart: fields[4] as DateTime?,
      isCycleRegular: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.displayName)
      ..writeByte(1)
      ..write(obj.dateOfBirth)
      ..writeByte(2)
      ..write(obj.averageCycleLengthDays)
      ..writeByte(3)
      ..write(obj.periodLengthDays)
      ..writeByte(4)
      ..write(obj.lastPeriodStart)
      ..writeByte(5)
      ..write(obj.isCycleRegular);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
