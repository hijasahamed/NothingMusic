import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nothing_music/provider/art_work_provider.dart';
import 'package:nothing_music/screens/Playlists/playlist_functions.dart';
import 'package:nothing_music/screens/Songs/now_playing_screen.dart';
import 'package:nothing_music/screens/Songs/songs_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class Selectedplaylist extends StatefulWidget {
  Selectedplaylist({super.key,required this.allPlaylistSong,required this.name});
  
   List allPlaylistSong;
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
                          context.read<ArtWorkProvider>().setId(data.image!);                         
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
                              playlistSongsOptions(context,data,index,widget.allPlaylistSong,data.id);                   
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
}