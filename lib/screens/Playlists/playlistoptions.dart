import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nothing_music/db/model/Playlist_model/playlist_db_model.dart';
import 'package:nothing_music/screens/Playlists/playlist_functions.dart';
import 'package:nothing_music/screens/Songs/now_playing_screen.dart';
import 'package:nothing_music/screens/Songs/songs_functions.dart';

playlistSongsOptions(context,songs,index,audioPlayer,list,name,int id) {
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
                        audioplayer: audioPlayer,
                        songsList: list,
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
                    // deleteplaylistsongs(list, index, name, id); 
                  },
                  leading: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  title: Text('Remove from Playlist',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ],
            ),
          );
        });
  }

  deleteplaylistsongs(list, int index, name, int id) async {
  final db = await Hive.openBox<PlayListModel >('playlist');
  list.removeAt(index);
  final a = PlayListModel (id: id, name: name, songsList: list);
  await db.put(id, a);
  getAllPlaylist(); 
  }