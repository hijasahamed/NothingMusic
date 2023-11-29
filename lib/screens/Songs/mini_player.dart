import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nothing_music/screens/Songs/now_playing_screen.dart';
import 'package:nothing_music/screens/Songs/songs_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key,required this.songsList,});
  final songsList;

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

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
      child: Container(
        decoration:const BoxDecoration(
          color: Color.fromARGB(255, 35, 35, 35),
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        width: double.infinity,
        height: 75,       
        child: ListTile(
          leading: QueryArtworkWidget(
              id: widget.songsList[currentindex].image, 
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
            title: Text(widget.songsList[currentindex].title,maxLines: 1,overflow: TextOverflow.ellipsis,),
            subtitle: Text(widget.songsList[currentindex].artist,maxLines: 1,overflow: TextOverflow.ellipsis,),
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
      ),
    );
  }
}