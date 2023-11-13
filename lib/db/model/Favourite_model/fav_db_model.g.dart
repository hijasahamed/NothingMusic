// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fav_db_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavAudioModelAdapter extends TypeAdapter<FavAudioModel> {
  @override
  final int typeId = 2;

  @override
  FavAudioModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavAudioModel(
      id: fields[0] as int?,
      image: fields[1] as int?,
      title: fields[2] as String,
      artist: fields[3] as String,
      uri: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FavAudioModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.image)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.artist)
      ..writeByte(4)
      ..write(obj.uri);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavAudioModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
