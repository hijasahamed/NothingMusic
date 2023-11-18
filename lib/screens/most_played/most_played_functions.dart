
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nothing_music/db/model/Audio_model/db_model.dart';
import 'package:nothing_music/provider/art_work_provider.dart';
import 'package:nothing_music/screens/Songs/now_playing_screen.dart';
import 'package:nothing_music/screens/Songs/songs_functions.dart';
import 'package:provider/provider.dart';

List mostPlayedList=[];

ValueNotifier<List<AudioModel>> MostplayedSongNotifier=ValueNotifier([]);

addToMostPlayedList(value)async{
  mostPlayedList.add(value);
  mostPlayedSelecting();
}

mostPlayedSelecting()async{
  final songs=mostPlayedList.toSet().toList();
   int count=0;

   for(int i=0;i<songs.length;i++){
    for(int j=0;j<mostPlayedList.length;j++){
      if(songs[i]==mostPlayedList[j]){
        count++;
      }
    }
    if(count==3){
      final mostplayedsongbox= await Hive.openBox<AudioModel>('most_played_song_db');
      if(!mostplayedsongbox.values.any((element) => element.uri == songs[i].uri)){
        addToMostPlayedSongs(songs[i]);
        mostPlayedList.clear();
        getAllMostPlayedSongs();
      }
      
    }
   }
}


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

removeMostPlayed(int id)async{
  final mostPlayedSongBox=await Hive.openBox<AudioModel>('most_played_song_db');
  await mostPlayedSongBox.delete(id);
  getAllMostPlayedSongs();
}


mostPlayedBottomSheeet(context,data,index,_audioPlayer,allsongs){
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
          height: 330,
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
        duration: Duration(seconds: 2),
        width: 300,
      )
    );
}


