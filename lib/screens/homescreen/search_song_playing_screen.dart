import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:nothing_music/db/model/Audio_model/db_model.dart';
import 'package:nothing_music/provider/Searched_Song_Provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class SerachSongPlayingScreen extends StatefulWidget {
  const SerachSongPlayingScreen({super.key,required this.song,required this.audioPlayer});

  final AudioModel song;
  final AudioPlayer audioPlayer;

  @override
  State<SerachSongPlayingScreen> createState() => _SerachSongPlayingScreenState();
}

class _SerachSongPlayingScreenState extends State<SerachSongPlayingScreen> {

  bool _isPlaying=true;
  Duration duration=Duration.zero;
  Duration position=Duration.zero;

  @override
  void initState() {
    playSong();
    super.initState();
  }

  @override
  void dispose() {
    widget.audioPlayer.stop();
    super.dispose();
  }

  playSong(){
    try{
      widget.audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(widget.song.uri!)));
      widget.audioPlayer.play();
      _isPlaying=true;
    }
    on Exception{
      print('error');
    }

    widget.audioPlayer.durationStream.listen((d) {
      setState(() {
        duration=d!;
      });
    });
    widget.audioPlayer.positionStream.listen((p) {
      setState(() {
        position=p; 
      });
    });
  }

  void listenToEvent() {
    widget.audioPlayer.playerStateStream.listen((state) {
      if (state.playing) {
        setState(() {
          _isPlaying = true;
        });
      } else {
        setState(() {
          _isPlaying = false;
        });
      }
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black,),
      body: SafeArea(
        child: Column(
          children: [

            Flexible(
              flex: 5,
              child: Center( 
                child: ArtWorkWidget(),
              ),
            ),

            Flexible(
              flex: 2,
              child: Container(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 25,
                        width: double.infinity,
                        child: Marquee(
                          text: widget.song.title,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          scrollAxis: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          blankSpace: 20.0,
                          velocity: 50.0,
                          pauseAfterRound: Duration(seconds: 1),
                          startPadding: 10.0,
                          accelerationDuration: Duration(seconds: 1),
                          accelerationCurve: Curves.linear,
                          decelerationDuration: Duration(milliseconds: 500),
                          decelerationCurve: Curves.easeOut, 
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(widget.song.artist,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontSize: 15 )),                     
                      Row(
                        children: [
                          Text(formatTime(position)),
                          Expanded(
                            child: Slider(
                              min: 0,
                              max: duration.inSeconds.toDouble(),
                              value: position.inSeconds.toDouble(), 
                              onChanged: (value)async{
                                final position = Duration(seconds: value.toInt());
                                await widget.audioPlayer.seek(position);
                              }
                            )
                          ),
                          Text(formatTime(duration)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),

            Flexible(
              flex: 3,
              child: Container( 
                child: Column(
                  children: [                      
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        onPressed: (){
                          setState(() {
                            if(_isPlaying){
                              widget.audioPlayer.pause();
                            }
                            else{
                              widget.audioPlayer.play();
                            }
                            _isPlaying = !_isPlaying;
                          });
                        }, 
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                      ),
                    ),
                  ],
                ),
              )
            ),

          ],
        ),
      ),
    );
  }

  formatTime(Duration duration){
    String twoDigits(int n) => n.toString().padLeft(2,'0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return[
      if(duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

}



class ArtWorkWidget extends StatelessWidget {
  const ArtWorkWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: context.watch<SearchedSongProvider>().id,  
      type: ArtworkType.AUDIO,
      artworkHeight: 340,
      artworkWidth: 360,
      artworkFit: BoxFit.fill,
      artworkQuality: FilterQuality.high,
      artworkBorder: BorderRadius.circular(15),                    
      quality: 100,                    
      nullArtworkWidget: Container(
        width: 360,
        height: 340,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            image: DecorationImage(
                image: AssetImage('Assets/images/music logo.png'),                           
                fit: BoxFit.fill)),
      ), 
    );
  }
}