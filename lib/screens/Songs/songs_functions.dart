
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nothing_music/db/model/Favourite_model/fav_db_model.dart';
import 'package:nothing_music/db/model/Playlist_model/playlist_db_model.dart';
import 'package:nothing_music/screens/Playlists/playlist_functions.dart';
import 'package:nothing_music/screens/Songs/now_playing_screen.dart';
import 'package:nothing_music/screens/Songs/songs_screen.dart';
import 'package:nothing_music/screens/favourite/favourite_functions.dart';


addToFavDBBottomSheet(songs,context)async{
    final favsongbox = await Hive.openBox<FavAudioModel>('fav_song_db');
    if(!favsongbox.values.any((element) => element.uri == songs.uri)){
      final _favSong=FavAudioModel(image: songs.image!, title: songs.title, artist: songs.artist, uri: songs.uri);
      addToFav(_favSong);
      favAddedSnackbar(context);
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

songsBottomSheet(context,songs,index,audioPlayer) {
    showModalBottomSheet(
        backgroundColor: Color.fromARGB(255, 35, 35, 35),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        )),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 270,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 35, left: 35),
                  child: Column(
                    children: [
                      Text(
                        songs.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Text(
                        "${songs.artist}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 40,
                  thickness: 1,
                  indent: 30,
                  endIndent: 30,
                  color: Colors.white,
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return NowPlayingScreen(
                        songsList: allSongs,
                        songindex: index,                        
                      );
                    }));
                  },
                  leading: Icon(
                    Icons.play_circle,
                    color: Colors.white,
                  ),
                  title: Text('Play',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                ListTile(
                  onTap: () {
                    addToFavDBBottomSheet(songs, context);
                  },
                  leading: Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                  ),
                  title: Text('Add to Favourite',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    final value=PlayListModel(title: songs.title,artist: songs.artist,image: songs.image,uri: songs.uri);
                    showPlayListInBottomSheet(value,context);  
                  },
                  leading: Icon(
                    Icons.playlist_add,
                    color: Colors.white,
                  ),
                  title: Text('Add to Playlist',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ],
            ),
          );
        });
  }
  

  shuffleOnSnackbar(ctx){
    return ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        content: Center(child: Text('Shuffle On',style: TextStyle(fontSize: 15,),)),
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 1500),
        width: 150,
      )
    );
  }

  shuffleOffSnackbar(ctx){
    return ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        content: Center(child: Text('Shuffle Off',style: TextStyle(fontSize: 15,),)), 
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 1500),
        width: 150,
      )
    );
  }

  loopOnSnackbar(ctx){
    return ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        content: Center(child: Text('Loop On',style: TextStyle(fontSize: 15,),)), 
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 1500),
        width: 150,
      )
    );
  }

  loopOffSnackbar(ctx){
    return ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        content: Center(child: Text('Loop Off',style: TextStyle(fontSize: 15,),)), 
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 1500),
        width: 150,
      )
    );
  }