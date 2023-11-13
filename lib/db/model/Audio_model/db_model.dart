import 'package:hive/hive.dart';
part 'db_model.g.dart';

@HiveType(typeId: 1)
class AudioModel{
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
  
  AudioModel(
    {this.id,
    required this.image,
    required this.title,
    required this.artist,
    required this.uri,
    }
  ); 
}