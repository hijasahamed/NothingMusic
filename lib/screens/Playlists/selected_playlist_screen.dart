import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:nothing_music/db/model/Playlist_model/playlist_db_model.dart';
import 'package:nothing_music/screens/Playlists/playlist_functions.dart';
import 'package:nothing_music/screens/Songs/now_playing_screen.dart';
import 'package:nothing_music/screens/Songs/songs_functions.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Selectedplaylist extends StatefulWidget {
  Selectedplaylist({super.key,required this.allPlaylistSong,required this.name,required this.playlistid}); 
  
   List allPlaylistSong;
   var  playlistid;
   final String? name;

  @override
  State<Selectedplaylist> createState() => _SelectedplaylistState();
}

class _SelectedplaylistState extends State<Selectedplaylist> {


  @override
  Widget build(BuildContext context) {
     widget.allPlaylistSong=widget.allPlaylistSong.reversed.toList();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(widget.name ?? 'untitled'),        
      ),
      body: SafeArea(        
        child: widget.allPlaylistSong.isEmpty?
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LottieBuilder.asset(
                'Assets/Animations/no result animation.json',
                height: 120,
                width: 120,
              ),
              const Text(
                ' No Songs In Playlist',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15
                ),
              )
            ],
          ),
        )
        :Scrollbar(         
          child: ListView.separated(
            
            itemBuilder: (context, index) {             
              final data=widget.allPlaylistSong[index];              
              return ListTile(
                        onTap: () {                        
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return NowPlayingScreen(                              
                              songsList: widget.allPlaylistSong,
                              songindex: index,                              
                            );
                          }));
                        },
                        leading: QueryArtworkWidget(
                          id: data.image!,
                          type: ArtworkType.AUDIO,
                          artworkHeight: 90,
                          artworkWidth: 60,
                          artworkFit: BoxFit.fill,
                          artworkQuality: FilterQuality.high,
                          artworkBorder: BorderRadius.circular(5),
                          quality: 100,
                          nullArtworkWidget: Container(
                            width: 60,
                            height: 90,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                image: DecorationImage(
                                    image: AssetImage(
                                        'Assets/images/music logo.png'),
                                    fit: BoxFit.fill)),
                          ),
                        ),
                        title: Text(
                          data.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          "${data.artist}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white), 
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              var song=PlayListModel(artist: data.artist,image: data.image,title: data.title,uri: data.uri);
                             
                               playlistSongsOptions(context,song,index,widget.allPlaylistSong,widget.playlistid,widget.name);
                          
                              
                                                                            
                            },
                            icon: Icon(Icons.more_vert)
                        ),
                      );
            }, 
            separatorBuilder: (context, index) {
              return Divider();
            }, 
            itemCount: widget.allPlaylistSong.length
          ),
        ),
      ),
    );
  }

   playlistSongsOptions(context,songs,index,list,id,name) {
    print('hashiq $id');
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
                const SizedBox(
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
                    addToFavDBBottomSheet(songs,context);
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
                    setState(() {
                       deleteplaylistsongs(list, index, name, id);
                    });                   
                    playlistSongdeleted(context);
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

   deleteplaylistsongs(list,index, name,int id) async {
  final db = await Hive.openBox<PlayListModel >('playlist');
  list.removeAt(index);
  final a = PlayListModel (id: id, name: name, songsList: list);
  await db.put(id, a);
  setState(() {
    widget.allPlaylistSong=list;
  });
  getAllPlaylist(); 
  }



}