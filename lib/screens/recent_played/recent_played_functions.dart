import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nothing_music/db/model/Audio_model/db_model.dart';
import 'package:nothing_music/provider/art_work_provider.dart';
import 'package:nothing_music/screens/Songs/now_playing_screen.dart';
import 'package:nothing_music/screens/Songs/songs_functions.dart';
import 'package:provider/provider.dart';

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

removeRecentplayed(int id)async{
  final recentsongbox= await Hive.openBox<AudioModel>('recent_song_db');
  await recentsongbox.delete(id);
  gettAllRecentSongs();
}

recentPlayedAdding(song)async{
    final recentsongbox= await Hive.openBox<AudioModel>('recent_song_db');
    final existingSong = recentsongbox.values.firstWhere(
    (element) => element.uri == song.uri,orElse: () {
     return AudioModel(artist: '',image: 0,title: '',uri: '',id: 0);
    },
  );
  if (existingSong.uri ==song.uri ) {
    await removeRecentplayed(existingSong.id!);
     addToRecentPlayed(song);
  }
  else{
    addToRecentPlayed(song);  
  }
}

recentPlayedBottomSheeet(context,data,index,_audioPlayer,allsongs){
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
        height: 270 ,
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
                  return  NowPlayingScreen(audioplayer: _audioPlayer, songsList: allsongs, songindex: index);
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
              onTap: () {},
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
            // ListTile(
            //   onTap: () {
            //     Navigator.of(context).pop();                
            //     removeRecentplayed(data.id);
            //     recentPlayedRemovedSnackbar(context);                    
            //   },
            //   leading:const Icon(
            //     Icons.delete,
            //     color: Colors.white,
            //   ),
            //   title: const Text('Remove From Recents',
            //       style: TextStyle(color: Colors.white, fontSize: 20)),
            // ),
          ],
        ),
      );
    });
}

  recentPlayedRemovedSnackbar(ctx){
    return ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        content: Center(child: Text('Song Removed From Recent',style: TextStyle(fontSize: 15),)),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        width: 300,
      )
    );
}