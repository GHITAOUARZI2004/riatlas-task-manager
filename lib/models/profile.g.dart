// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileAdapter extends TypeAdapter<Profile> {
  @override
  final int typeId = 1;

  @override
  Profile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Profile(
      name: fields[0] as String,
      avatarUrl: fields[1] as String?,
      totalXp: fields[2] as int,
      level: fields[3] as int,
      moodEmoji: fields[4] as String,
      moodLabel: fields[5] as String,
      bio: fields[6] as String?,
      joinedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Profile obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.avatarUrl)
      ..writeByte(2)
      ..write(obj.totalXp)
      ..writeByte(3)
      ..write(obj.level)
      ..writeByte(4)
      ..write(obj.moodEmoji)
      ..writeByte(5)
      ..write(obj.moodLabel)
      ..writeByte(6)
      ..write(obj.bio)
      ..writeByte(7)
      ..write(obj.joinedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
