import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nothing_music/db/model/Audio_model/db_model.dart';
import 'package:on_audio_query/on_audio_query.dart';


ValueNotifier<List<AudioModel>> allSongNotifier=ValueNotifier([]);

 final OnAudioQuery onAudioQuery= OnAudioQuery();
Future<void>fetchSong()async{
  final allSongs= await onAudioQuery.querySongs(); 
  final songbox =await Hive.openBox<AudioModel>('songs_db');
  for(var songs in allSongs){
      final value =AudioModel(
        id: songs.id, 
        image: songs.id, 
        title: songs.displayNameWOExt,   
        artist: songs.artist?? '', 
        uri: songs.uri,
      );     
       songbox.put(songs.id, value);
  }
  getAllSongs();  
}

getAllSongs()async{
  final favsongbox= await Hive.openBox<AudioModel>('songs_db');
  allSongNotifier.value.clear();
  allSongNotifier.value.addAll(favsongbox.values);
  allSongNotifier.notifyListeners();
}

