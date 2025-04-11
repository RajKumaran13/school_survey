// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schoold_data_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SchoolDataAdapter extends TypeAdapter<SchoolData> {
  @override
  final int typeId = 1;

  @override
  SchoolData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SchoolData(
      name: fields[0] as String,
      type: fields[1] as String,
      curriculum: (fields[2] as List).cast<String>(),
      establishedOn: fields[3] as DateTime,
      grades: (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, SchoolData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.curriculum)
      ..writeByte(3)
      ..write(obj.establishedOn)
      ..writeByte(4)
      ..write(obj.grades);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchoolDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
