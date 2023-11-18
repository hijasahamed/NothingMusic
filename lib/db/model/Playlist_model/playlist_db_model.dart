import 'package:hive_flutter/hive_flutter.dart';
part 'playlist_db_model.g.dart'; 

@HiveType(typeId:3)
class PlayListModel {
  @HiveField(0)
  final String name;
  
  @HiveField(1)
  final List playlistList;

  @HiveField(2)
  int? id;

  @HiveField(3)
  final int? image;

  @HiveField(4)
  final String title;

  @HiveField(5)
  final String artist;

  @HiveField(6)
  final String? uri;

  PlayListModel(
    {
      required this.name,
      required this.playlistList,
      this.id,
      required this.image,
      required this.title,
      required this.artist,
      required this.uri,
    }
  );

  
}