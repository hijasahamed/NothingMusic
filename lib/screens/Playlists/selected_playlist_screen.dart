import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:nothing_music/db/model/Playlist_model/playlist_db_model.dart';
import 'package:nothing_music/screens/Playlists/playlist_functions.dart';
import 'package:nothing_music/screens/Songs/now_playing_screen.dart';
import 'package:nothing_music/screens/Songs/songs_functions.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Selectedplaylist extends StatefulWidget {
  Selectedplaylist({super.key,required this.allPlaylistSong,required this.playlistname,required this.playlistid}); 
  
  List allPlaylistSong;
  final playlistid; 
  final String? playlistname;

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
        backgroundColor:const Color.fromARGB(255, 35, 35, 35),
        centerTitle: true,
        title: Text(widget.playlistname ?? 'untitled',style:TextStyle(fontWeight: FontWeight.w700,color: Colors.white) ,),
                
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
                          style:const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          "${data.artist}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:const TextStyle(color: Colors.white), 
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              var song=PlayListModel(artist: data.artist,image: data.image,title: data.title,uri: data.uri);
                             
                               playlistSongsOptions(context,song,index,widget.allPlaylistSong,widget.playlistid,widget.playlistname);
                          
                              
                                                                            
                            },
                            icon:const Icon(Icons.more_vert)
                        ),
                      );
            }, 
            separatorBuilder: (context, index) {
              return const SizedBox(height:10 ,); 
            }, 
            itemCount: widget.allPlaylistSong.length
          ),
        ),
      ),
    );
  }

   playlistSongsOptions(context,songs,index,allPlaylistSong,playlistid,playlistname)async {
    showModalBottomSheet(
        backgroundColor:const Color.fromARGB(255, 35, 35, 35),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        )),
        context: context,
        builder: (BuildContext context) {
          return  SizedBox(
            height: 270,
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
                        songs.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Text(
                        "${songs.artist}",
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
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return NowPlayingScreen(
                        songsList: allPlaylistSong,
                        songindex: index,                        
                      );
                    }));
                  },
                  leading:const Icon(
                    Icons.play_circle,
                    color: Colors.white,
                  ),
                  title:const Text('Play',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                ListTile(
                  onTap: () {
                    addToFavDBBottomSheet(songs,context);
                  },
                  leading:const Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                  ),
                  title:const Text('Add to Favourite',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                ListTile(
                  onTap: () async {
                    Navigator.pop(context);                    
                    setState(() {
                       deletePlaylistSongs(index,allPlaylistSong,playlistid,playlistname);
                    });                   
                    await playlistSongdeleted(context);
                  },
                  leading:const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  title:const Text('Remove from Playlist',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ],
            ),
          );
        });
  }

  Future<void>deletePlaylistSongs(index,allPlaylistSong,playlistid,playlistname) async {
    final db = await Hive.openBox<PlayListModel >('playlist');
    allPlaylistSong.removeAt(index);
    setState(() {
      widget.allPlaylistSong = List.from(allPlaylistSong); 
    });
    final updatedValue = PlayListModel (id: playlistid, name: playlistname, songsList: allPlaylistSong);
    await db.put(playlistid,updatedValue);
        
    await getAllPlaylist(); 
  }

  

}