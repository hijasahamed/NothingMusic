import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nothing_music/db/model/Audio_model/db_model.dart';
import 'package:nothing_music/db/model/Favourite_model/fav_db_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

ValueNotifier<List<FavAudioModel>> favoriteSongNotifier=ValueNotifier([]);



late final OnAudioQuery onAudioQuery; //using OnAudioQuery plugin ,fetched all songs in the device //

Future<void>fetchSong()async{
  final allSongs= await onAudioQuery.querySongs(); //added all songs using the OnAudioQuery plugin and calling querySongs in to a variable allSongs
  final songbox =await Hive.openBox<AudioModel>('songs_db'); //database is "songs_db"//
  for(var songs in allSongs){
      final value =AudioModel(
        image: songs.id, 
        title: songs.displayNameWOExt,   
        artist: songs.artist?? '', 
        uri: songs.uri,
      );
      songbox.put(songs.id, value);
  }
}




//Favorite section functions starts//

addToFav(FavAudioModel value)async{
  final favsongbox = await Hive.openBox<FavAudioModel>('fav_song_db');
  final id1=await  favsongbox.add(value);
  value.id=id1;
  favoriteSongNotifier.value.add(value);
  favoriteSongNotifier.notifyListeners();  
  print(favsongbox);
}

getAllFavSong()async{
  final favsongbox= await Hive.openBox<FavAudioModel>('Fav_song_db');
  favoriteSongNotifier.value.clear();
  favoriteSongNotifier.value.addAll(favsongbox.values);
  favoriteSongNotifier.notifyListeners();
}

removeFavSong(int id)async{
    final favsongbox= await Hive.openBox<FavAudioModel>('Fav_song_db');
    await favsongbox.delete(id);
    getAllFavSong();
}


