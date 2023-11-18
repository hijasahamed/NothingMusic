import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nothing_music/db/model/Audio_model/db_model.dart';
import 'package:nothing_music/db/model/Favourite_model/fav_db_model.dart';
import 'package:nothing_music/db/model/Playlist_model/playlist_db_model.dart';
import 'package:on_audio_query/on_audio_query.dart';



// song fetching and adding to database function starts//

late final OnAudioQuery onAudioQuery; //using OnAudioQuery plugin ,fetched all songs in the device //

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
}

