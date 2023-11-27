import 'package:flutter/material.dart';
import 'package:nothing_music/provider/art_work_provider.dart';
import 'package:nothing_music/screens/Songs/now_playing_screen.dart';
import 'package:nothing_music/screens/Songs/songs_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key,required this.songsList,});
  final songsList;

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return NowPlayingScreen(
            songsList: allSongs,
            songindex: audioPlayerAudio.currentIndex ?? 0,
          );
        }));
      },
      child: Container(
        decoration:const BoxDecoration(
          color: Color.fromARGB(255, 35, 35, 35),
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        width: double.infinity,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            QueryArtworkWidget(
              id: context.watch<ArtWorkProvider>().id, 
              type: ArtworkType.AUDIO,
              artworkHeight: 60,
              artworkWidth: 60,
              artworkFit: BoxFit.fill,
              artworkQuality: FilterQuality.high,
              artworkBorder: BorderRadius.circular(20),                    
              quality: 100,                    
              nullArtworkWidget: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    image: DecorationImage(
                        image: AssetImage('Assets/images/music logo.png'),                           
                        fit: BoxFit.fill)),
              ),
            ),
            Container(
              width: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.songsList[currentindex].title,maxLines: 1,overflow: TextOverflow.ellipsis,),
                  SizedBox(height: 10,),
                  Text(widget.songsList[currentindex].artist,maxLines: 1,overflow: TextOverflow.ellipsis,),
                ],
              ),
            ),
            IconButton(
              onPressed: (){
                setState(() {
                  if(isPlaying){
                    audioPlayerAudio.pause();
                  }
                  else{
                    audioPlayerAudio.play();
                  }
                  isPlaying = !isPlaying; 
                });
              }, 
              icon: Transform.translate(
                offset: Offset(-15,-10),
                child: Expanded(
                  child: Icon(isPlaying ? Icons.pause : Icons.play_arrow,size: 50,),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}