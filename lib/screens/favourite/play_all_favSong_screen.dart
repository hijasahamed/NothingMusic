import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:nothing_music/db/model/Favourite_model/fav_db_model.dart';
import 'package:on_audio_query/on_audio_query.dart';



class MiniPlayerScreen extends StatefulWidget {
  const MiniPlayerScreen({super.key,required this.songModelList,required this.audioPlayer});

  final List<FavAudioModel> songModelList;
  final AudioPlayer audioPlayer;
  
 

  @override
  State<MiniPlayerScreen> createState() => _MiniPlayerScreenState();
}

class _MiniPlayerScreenState extends State<MiniPlayerScreen> {

  bool _isPlaying = true;
  Duration duration=Duration.zero;
  Duration position=Duration.zero;

  List<AudioSource> songlist=[];

  int currentindex=0;

  @override
  void initState() {
    super.initState();
    playSong(); 
  }

  playSong(){
    try{
      for(var elements in widget.songModelList){
        songlist.add(AudioSource.uri(
          Uri.parse(elements.uri!)
        ));
      }
      widget.audioPlayer.setAudioSource(ConcatenatingAudioSource(children: songlist));
      widget.audioPlayer.play();
      listenToEvent();
      listenToSongIndex();
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

  void listenToSongIndex() {
    widget.audioPlayer.currentIndexStream.listen(
      (event) {
        setState(
          () {
            if (event != null) {
              currentindex = event;
            }            
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [

              Flexible(
                flex: 5,
                child: Center( 
                  child: QueryArtworkWidget(
                    id: widget.songModelList[currentindex].image!, 
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
                  ),
                ),
              ),

              Flexible(
                flex: 2,
                child: Container(
                  child: Center(
                    child: Column(
                      children: [
                         Text(widget.songModelList[currentindex].title,maxLines: 1,overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white,fontSize: 20  ),),
                         SizedBox(height: 10,),
                         Text(widget.songModelList[currentindex].artist,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontSize: 15 )),
                         SizedBox(height: 30,),                       
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
                      Wrap(
                        spacing: 30 ,
                        children: [
                          IconButton(
                            onPressed: (){}, 
                            icon: Icon(Icons.shuffle,color: Colors.white,)
                          ),
                          IconButton(
                            onPressed: (){
                              if(widget.audioPlayer.hasPrevious){
                                widget.audioPlayer.seekToPrevious();
                              }
                            }, 
                            icon: Icon(Icons.arrow_back_ios_outlined,color: Colors.white,)
                          ),
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
                          IconButton(
                            onPressed: (){
                              if(widget.audioPlayer.hasNext){
                                widget.audioPlayer.seekToNext();
                              }
                            }, 
                            icon: Icon(Icons.arrow_forward_ios_outlined,color: Colors.white,) 
                          ),
                          IconButton(
                            onPressed: (){}, 
                            icon: Icon(Icons.repeat,color: Colors.white,)
                          ),
                        ],
                      ),
                      SizedBox(height: 20,), 
                      Visibility(
                        visible: _isPlaying,
                        child: LottieBuilder.asset('Assets/Animations/mini player wave animation.json',height: 100,width: 100,)
                      )
                    ],
                  ),
                )
              ),

            ],
          ),
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