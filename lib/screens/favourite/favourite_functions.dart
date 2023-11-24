import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nothing_music/db/model/Favourite_model/fav_db_model.dart';
import 'package:nothing_music/db/model/Playlist_model/playlist_db_model.dart';
import 'package:nothing_music/provider/art_work_provider.dart';
import 'package:nothing_music/screens/Playlists/playlist_functions.dart';
import 'package:nothing_music/screens/Songs/now_playing_screen.dart';

import 'package:provider/provider.dart';


ValueNotifier<List<FavAudioModel>> favoriteSongNotifier=ValueNotifier([]);

addToFav(FavAudioModel value)async{
  final favsongbox = await Hive.openBox<FavAudioModel>('fav_song_db');
  final id1=await  favsongbox.add(value);
  value.id=id1;
  favsongbox.put(id1,value);
  getAllFavSong();
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

// removeWithUri(String uri)async{ 
//   final favsongbox= await Hive.openBox<FavAudioModel>('Fav_song_db');
//   await favsongbox.delete(uri);
//   getAllFavSong();
// }


favBottomSheeet(context,data,index,audioPlayer,allSongsvv){
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
          height: 275,
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
                      data.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      data.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 40,
                thickness: 1,
                indent: 30,
                endIndent: 30,
                color: Colors.white,
              ),
              ListTile(
                onTap: () {
                  context.read<ArtWorkProvider>().setId(data.image!); 
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return  NowPlayingScreen(songsList: allSongsvv, songindex: index);
                  }));
                },
                leading: const Icon(
                  Icons.play_circle,
                  color: Colors.white,
                ),
                title: const Text('Play',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),              
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                    final value=PlayListModel(title: data.title,artist: data.artist,image: data.image,uri: data.uri);
                    showPlayListInBottomSheet(value,context); 
                },
                leading: const Icon(
                  Icons.playlist_add,
                  color: Colors.white,
                ),
                title: const Text('Add to Playlist',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              ListTile(
                onTap: () {                
                    removeFavSong(data.id);
                    Navigator.of(context).pop();
                    favRemovedsnackbar(context);
                },
                leading:const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                title: const Text('Remove From Favourites',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ],
          ),
        );
      });
  }

  favRemovedsnackbar(ctx){
    return ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        content: Center(child: Text('Song Removed From Favourites',style: TextStyle(fontSize: 15),)),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(50),
        duration: Duration(seconds: 2),
      )
    );
  }

  favAddedSnackbar(ctx){
    return ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        content: Center(child: Text('Added To Favourites',style: TextStyle(fontSize: 15),)),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(50),
        duration: Duration(seconds: 2),
      )
    );
  }

  favAlreadyAddedSnackbar(ctx){
      return ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Center(child: Text('Song Already In Favourites',style: TextStyle(fontSize: 15),)),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(50),
          duration: Duration(seconds: 2),
        )
      );
  }