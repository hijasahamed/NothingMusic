import 'package:hive/hive.dart';
part 'fav_db_model.g.dart';

@HiveType(typeId: 2)
class FavAudioModel{
  @HiveField(0)
  int? id;

  @HiveField(1)
  final int? image;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String artist;

  @HiveField(4)
  final String? uri;
  
  FavAudioModel(
    {this.id,
    required this.image,
    required this.title,
    required this.artist,
    required this.uri,
    }
  ); 
}