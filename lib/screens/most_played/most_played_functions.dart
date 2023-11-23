
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nothing_music/db/model/Audio_model/db_model.dart';
import 'package:nothing_music/db/model/Playlist_model/playlist_db_model.dart';
import 'package:nothing_music/provider/art_work_provider.dart';
import 'package:nothing_music/screens/Playlists/playlist_functions.dart';
import 'package:nothing_music/screens/Songs/now_playing_screen.dart';
import 'package:nothing_music/screens/Songs/songs_functions.dart';
import 'package:provider/provider.dart';

List mostPlayedList=[];

ValueNotifier<List<AudioModel>> mostplayedSongNotifier=ValueNotifier([]);


checkAndAddToMostplayed(value,String uri,songListSong)async{
  mostPlayedList.add(value);
  int playCount=0;
  for(var song in mostPlayedList){
    if(song.uri==uri){
      playCount++;
    }
  }
  if(playCount==3){
    final mostPlayedsongbox= await Hive.openBox<AudioModel>('most_played_song_db');
    if(!mostPlayedsongbox.values.any((element) => element.uri == uri)){
    final mS=AudioModel(image: songListSong.image, title: songListSong.title, artist: songListSong.artist, uri: songListSong.uri);    
    addToMostPlayedSongs(mS);
  }
  }
}


addToMostPlayedSongs(AudioModel value)async{
  final mostPlayedsongbox= await Hive.openBox<AudioModel>('most_played_song_db');
  final id1=await mostPlayedsongbox.add(value);
  value.id=id1;
  mostPlayedsongbox.put(id1, value);
  getAllMostPlayedSongs();
}

getAllMostPlayedSongs()async{
  final mostPlayedSongBox=await Hive.openBox<AudioModel>('most_played_song_db');
  mostplayedSongNotifier.value.clear();
  mostplayedSongNotifier.value.addAll(mostPlayedSongBox.values);
  mostplayedSongNotifier.notifyListeners();
}

removeMostPlayed(int id)async{
  final mostPlayedSongBox=await Hive.openBox<AudioModel>('most_played_song_db');
  await mostPlayedSongBox.delete(id);
  getAllMostPlayedSongs();
}


mostPlayedBottomSheeet(context,data,index,allsongs){
    showModalBottomSheet(
      backgroundColor:const Color.fromARGB(255, 35, 35, 35),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      )),
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 330,
          child: Column(
            children: [
             const SizedBox(
                height: 10,
              ),
              Padding(
                padding:const EdgeInsets.only(right: 35, left: 35),
                child: Column(
                  children: [
                    Text(
                      data.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      data.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:const TextStyle(color: Colors.white),
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
                    return  NowPlayingScreen(songsList: allsongs, songindex: index);
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
                    addToFavDBBottomSheet(data,context);
                },
                leading:const Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
                title: const Text('Add to Favorites',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pop();                
                  removeMostPlayed(data.id);
                  mostPlayedRemovedSnackbar(context);                    
                },
                leading:const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                title: const Text('Remove From Mostplayed',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ],
          ),
        );
      });
  }

  mostPlayedRemovedSnackbar(ctx){
    return ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        content: Center(child: Text('Song Removed From Mostplayed',style: TextStyle(fontSize: 15),)),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(50),
        duration: Duration(seconds: 2),
      )
    );
}


