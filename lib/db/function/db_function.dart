import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nothing_music/db/model/Audio_model/db_model.dart';
import 'package:on_audio_query/on_audio_query.dart';


late final OnAudioQuery onAudioQuery; //using OnAudioQuery plugin ,fetched all songs in the device //

ValueNotifier<List<AudioModel>> AllSongNotifier=ValueNotifier([]);

Future<void>fetchSong()async{
  final allSongs= await onAudioQuery.querySongs(); //added all songs using the OnAudioQuery plugin and calling querySongs in to a variable allSongs
  final songbox =await Hive.openBox<AudioModel>('songs_db'); //database is "songs_db"//
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
  AllSongNotifier.value.clear();
  AllSongNotifier.value.addAll(favsongbox.values);
  AllSongNotifier.notifyListeners();
}

