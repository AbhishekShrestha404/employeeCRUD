// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 0;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      userId: fields[0] as int,
      fullName: fields[1] as String,
      userName: fields[2] as String,
      designation: fields[3] as String,
      emailAddress: fields[4] as String,
      contactNumber: fields[5] as String,
      defaultPradesh: fields[6] as String,
      defaultWork: fields[7] as String,
      workOnHoliday: fields[8] as String,
      overtime: fields[9] as String,
      unreadNotificationCount: fields[10] as int,
      leavesTaken: (fields[11] as Map).cast<String, dynamic>(),
      leaveNotLiable: (fields[12] as Map).cast<String, dynamic>(),
      leaveTransferred: (fields[13] as Map).cast<String, dynamic>(),
      leaveBalance: (fields[14] as Map).cast<String, dynamic>(),
      attendanceHistory: (fields[15] as Map).cast<String, dynamic>(),
      workingArea: (fields[16] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.userName)
      ..writeByte(3)
      ..write(obj.designation)
      ..writeByte(4)
      ..write(obj.emailAddress)
      ..writeByte(5)
      ..write(obj.contactNumber)
      ..writeByte(6)
      ..write(obj.defaultPradesh)
      ..writeByte(7)
      ..write(obj.defaultWork)
      ..writeByte(8)
      ..write(obj.workOnHoliday)
      ..writeByte(9)
      ..write(obj.overtime)
      ..writeByte(10)
      ..write(obj.unreadNotificationCount)
      ..writeByte(11)
      ..write(obj.leavesTaken)
      ..writeByte(12)
      ..write(obj.leaveNotLiable)
      ..writeByte(13)
      ..write(obj.leaveTransferred)
      ..writeByte(14)
      ..write(obj.leaveBalance)
      ..writeByte(15)
      ..write(obj.attendanceHistory)
      ..writeByte(16)
      ..write(obj.workingArea);
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
