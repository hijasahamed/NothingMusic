import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nothing_music/db/model/Audio_model/db_model.dart';
import 'package:nothing_music/db/model/Favourite_model/fav_db_model.dart';
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




//Favorite section functions starts//

ValueNotifier<List<FavAudioModel>> favoriteSongNotifier=ValueNotifier([]);

addToFav(FavAudioModel value)async{
  final favsongbox = await Hive.openBox<FavAudioModel>('fav_song_db');
  final id1=await  favsongbox.add(value);
  value.id=id1;
  favsongbox.put(id1,value);
  getAllFavSong();
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
    print(favsongbox);
    getAllFavSong();
}


//recent played song function//

ValueNotifier<List<AudioModel>> recentSongNotifier=ValueNotifier([]);

addToRecentPlayed(AudioModel value)async{
  final recentsongbox= await Hive.openBox<AudioModel>('recent_song_db');
  final id1=await recentsongbox.add(value);
  value.id=id1;
  recentsongbox.put(id1, value);
  gettAllRecentSongs();
}

gettAllRecentSongs()async{
  final recentsongbox= await Hive.openBox<AudioModel>('recent_song_db');
  recentSongNotifier.value.clear();
  recentSongNotifier.value.addAll(recentsongbox.values);
  recentSongNotifier.notifyListeners();
}


//most played song function//

ValueNotifier<List<AudioModel>> MostplayedSongNotifier=ValueNotifier([]);

addToMostPlayedSongs(AudioModel value)async{
  final mostplayedsongbox= await Hive.openBox<AudioModel>('most_played_song_db');
  final id1=await mostplayedsongbox.add(value);
  value.id=id1;
  mostplayedsongbox.put(id1, value);
  getAllMostPlayedSongs();
}

getAllMostPlayedSongs()async{
  final mostPlayedSongBox=await Hive.openBox<AudioModel>('most_played_song_db');
  MostplayedSongNotifier.value.clear();
  MostplayedSongNotifier.value.addAll(mostPlayedSongBox.values);
  MostplayedSongNotifier.notifyListeners(); 
}
