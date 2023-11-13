
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nothing_music/db/function/db_function.dart';
import 'package:nothing_music/db/model/Audio_model/db_model.dart';
import 'package:nothing_music/db/model/Favourite_model/fav_db_model.dart';
import 'package:nothing_music/provider/Audio_model_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

favAddedsnackbar(ctx){
    return ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        content: Center(child: Text('Added To Favourites',style: TextStyle(fontSize: 15),)),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        width: 300,

      )
    );
}
favAlreadyAddedSnackbar(ctx){
    return ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        content: Center(child: Text('Song Already In Favourites',style: TextStyle(fontSize: 15),)),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        width: 300,
      )
    );
}

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key,required this.audioplayer,required this.song});
 

 final AudioModel song;
 final AudioPlayer audioplayer;
 

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {

  bool _isPlaying = true;
  Duration duration=Duration.zero;
  Duration position=Duration.zero;
  bool _isFavourite=false;

  @override
  void initState() {
    super.initState();
    playSong(); 
  }

  playSong(){
    try{
      widget.audioplayer.setAudioSource(AudioSource.uri(Uri.parse(widget.song.uri!)));
      widget.audioplayer.play(); 
      _isPlaying=true; 

      listenToEvent();

    }
    on Exception{
      print('error');
    }
    widget.audioplayer.durationStream.listen((d) {
      setState(() {
        duration=d!;
      });
    });
    widget.audioplayer.positionStream.listen((p) {
      setState(() {
        position=p; 
      });
    });
  }

    void listenToEvent() {
    widget.audioplayer.playerStateStream.listen((state) {
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
  void dispose() {
    widget.audioplayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black ,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [

              Flexible(
                flex: 5,
                child: Center( 
                  child: const ArtWorkWidget(),
                ),
              ),

              Flexible(
                flex: 2,
                child: Container(
                  child: Center(
                    child: Column(
                      children: [
                         Text(widget.song.title,maxLines: 1,overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white,fontSize: 20  ),),
                         SizedBox(height: 10,),
                         Text(widget.song.artist,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontSize: 15 )),
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
                                  await widget.audioplayer.seek(position);
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
                      Padding(
                        padding: const EdgeInsets.only(right: 15,left: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white24,
                              child: IconButton(
                                onPressed: (){}, 
                                icon: Icon(Icons.playlist_add ,color: Colors.white,),                            
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.white24,
                              child: IconButton(
                                onPressed: (){
                                  addToFavDB(widget.song);
                                }, 
                                icon: Icon(Icons.favorite,color: _isFavourite ? Colors.red : Colors.white),                            
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25), 
                      Wrap(
                        spacing: 30 ,
                        children: [
                          IconButton(
                            onPressed: (){}, 
                            icon: Icon(Icons.shuffle,color: Colors.white,)
                          ),
                          IconButton(
                            onPressed: (){
                              
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
                                    widget.audioplayer.pause();
                                  }
                                  else{
                                    widget.audioplayer.play();
                                  }
                                  _isPlaying = !_isPlaying; 
                                });
                              }, 
                              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                            ),
                          ),
                          IconButton(
                            onPressed: (){}, 
                            icon: Icon(Icons.arrow_forward_ios_outlined,color: Colors.white,) 
                          ),
                          IconButton(
                            onPressed: (){}, 
                            icon: Icon(Icons.repeat,color: Colors.white,)
                          ),
                        ],
                      ),
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

  addToFavDB(song)async{
    final favsongbox = await Hive.openBox<FavAudioModel>('fav_song_db');
    if(!favsongbox.values.any((element) => element.uri == song.uri)){
      final _favSong=FavAudioModel(image: widget.song.image!, title: widget.song.title, artist: widget.song.artist, uri: widget.song.uri,id: widget.song.id);
      addToFav(_favSong);
      setState(() {
        _isFavourite=true;
      });
      favAddedsnackbar(context);
    }
    else{
      setState(() {
        _isFavourite=true;
      });
      favAlreadyAddedSnackbar(context);
    }     
  }


}

class ArtWorkWidget extends StatelessWidget {
  const ArtWorkWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: context.watch<AudioModelProvider>().id, 
      type: ArtworkType.AUDIO,
      artworkHeight: 340,
      artworkWidth: 360,
      artworkFit: BoxFit.fill,
      artworkQuality: FilterQuality.high,
      artworkBorder: BorderRadius.circular(20),                    
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