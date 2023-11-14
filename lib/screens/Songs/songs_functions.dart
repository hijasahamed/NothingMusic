
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nothing_music/db/function/db_function.dart';
import 'package:nothing_music/db/model/Favourite_model/fav_db_model.dart';

favAddedsnackbar(ctx){
    return ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        content: Center(child: Text('Added To Favourites',style: TextStyle(fontSize: 15),)),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        width: 300,
      )
    );
}

favAlreadyAddedSnackbar(ctx){
    return ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        content: Center(child: Text('Song Already In Favourites',style: TextStyle(fontSize: 15),)),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        width: 300,
      )
    );
}

addToFavDBBottomSheet(songs,context)async{
    final favsongbox = await Hive.openBox<FavAudioModel>('fav_song_db');
    if(!favsongbox.values.any((element) => element.uri == songs.uri)){
      final _favSong=FavAudioModel(image: songs.image!, title: songs.title, artist: songs.artist, uri: songs.uri);
      addToFav(_favSong);
      favAddedsnackbar(context);
      Navigator.pop(context);
    }
    else{
      favAlreadyAddedSnackbar(context);
      Navigator.pop(context);
    }  
}

  formatTime(Duration duration){
    String twoDigits(int n) => n.toString().padLeft(2,'0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return[
      if(duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }