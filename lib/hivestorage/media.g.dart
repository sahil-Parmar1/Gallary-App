// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MediaAdapter extends TypeAdapter<Media> {
  @override
  final int typeId = 0;

  @override
  Media read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Media(
      path: fields[0] as String,
      model: fields[1] as String?,
      make: fields[2] as String?,
      width: fields[3] as String?,
      height: fields[4] as String?,
      orientation: fields[5] as String?,
      dateCreated: fields[6] as String?,
      timeCreated: fields[7] as String?,
      fNumber: fields[8] as String?,
      isoSpeed: fields[9] as String?,
      flash: fields[10] as String?,
      focalLength: fields[11] as String?,
      date: fields[12] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Media obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.path)
      ..writeByte(1)
      ..write(obj.model)
      ..writeByte(2)
      ..write(obj.make)
      ..writeByte(3)
      ..write(obj.width)
      ..writeByte(4)
      ..write(obj.height)
      ..writeByte(5)
      ..write(obj.orientation)
      ..writeByte(6)
      ..write(obj.dateCreated)
      ..writeByte(7)
      ..write(obj.timeCreated)
      ..writeByte(8)
      ..write(obj.fNumber)
      ..writeByte(9)
      ..write(obj.isoSpeed)
      ..writeByte(10)
      ..write(obj.flash)
      ..writeByte(11)
      ..write(obj.focalLength)
      ..writeByte(12)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
