// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trail_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrailHiveModelAdapter extends TypeAdapter<TrailHiveModel> {
  @override
  final int typeId = 1;

  @override
  TrailHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrailHiveModel(
      trailId: fields[0] as String?,
      name: fields[2] as String,
      location: fields[3] as String,
      duration: fields[4] as double,
      elevation: fields[5] as double,
      difficulty: fields[6] as String,
      images: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TrailHiveModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.trailId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.duration)
      ..writeByte(5)
      ..write(obj.elevation)
      ..writeByte(6)
      ..write(obj.difficulty)
      ..writeByte(7)
      ..write(obj.images);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrailHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
