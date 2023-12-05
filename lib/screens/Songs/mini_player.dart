import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nothing_music/screens/songs/now_playing_screen.dart';
import 'package:nothing_music/screens/songs/songs_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MiniPlayer extends StatefulWidget {
  MiniPlayer({super.key,});
  
  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}
var allSongs;
var singingSong;
class _MiniPlayerState extends State<MiniPlayer> {

  @override
  void initState() {
    listenToEvent();
    super.initState();
  }

  void listenToEvent() {
    audioPlayerAudio.playerStateStream.listen((state) {
      if(mounted){
        if (state.playing) {
        setState(() {
          isPlaying = true;
          currentindex = audioPlayerAudio.currentIndex ?? 0; 
        });
      } else {
        setState(() {
          isPlaying = false;
        });
      }
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          isPlaying = false; 
        });
      }
      }
    });
  } 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return NowPlayingScreen(
            songsList: allSongs,
            songindex: currentindex,
          );
        }));
      },     
        child: ListTile(
          leading: QueryArtworkWidget(
              id: singingSong.image, 
              type: ArtworkType.AUDIO,
              artworkHeight: 60,
              artworkWidth: 60,
              artworkFit: BoxFit.fill,
              artworkQuality: FilterQuality.high,
              artworkBorder: BorderRadius.circular(5),                    
              quality: 100,                    
              nullArtworkWidget: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    image: DecorationImage(
                        image: AssetImage('Assets/images/music logo.png'),                           
                        fit: BoxFit.fill)),
              ),
            ),
            title: Text(singingSong.title,maxLines: 1,overflow: TextOverflow.ellipsis,),
            subtitle: Text(singingSong.artist,maxLines: 1,overflow: TextOverflow.ellipsis,),
            trailing: IconButton( 
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
              icon: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(isPlaying ? Icons.pause : Icons.play_arrow,color: Colors.black,)
              )
            )
        ),
      );
  }

}

  miniPlayerData(song,songslist){
    singingSong=song;
    allSongs=songslist;
  }