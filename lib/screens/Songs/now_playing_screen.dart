import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nothing_music/db/function/db_function.dart';
import 'package:nothing_music/db/model/Audio_model/db_model.dart';
import 'package:nothing_music/db/model/Favourite_model/fav_db_model.dart';
import 'package:nothing_music/provider/audio_model_provider.dart';
import 'package:nothing_music/screens/Songs/songs_functions.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';



class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key,required this.audioplayer,required this.song,required this.songsList,required this.songindex});
 

 final AudioModel song;
 final AudioPlayer audioplayer;
 final List songsList;
 final int songindex;


  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {

  bool _isPlaying = true;
  Duration duration=Duration.zero;
  Duration position=Duration.zero;
  bool _isFavourite=false;

  List<AudioSource> songlist=[];
  int currentindex=0;

  @override
  void initState() {
    super.initState();
    playSong(); 
  }

  playSong(){
    if(!mounted){
      return;
    }
    try{
      for(var elements in widget.songsList){
        songlist.add(AudioSource.uri(
          Uri.parse(elements.uri!)
        ));
      }
      listenToSongIndex();
      widget.audioplayer.setAudioSource(ConcatenatingAudioSource(children: songlist),initialIndex: widget.songindex);
      widget.audioplayer.play();
      listenToEvent();
      
    }
    on Exception catch (_){
      if(mounted){
        return; 
      }
    }

    widget.audioplayer.durationStream.listen((d) {
      if(mounted){
        setState(() {
        duration=d!;
      });
      }
    });
    widget.audioplayer.positionStream.listen((p) {
      if(mounted){
        setState(() {
        position=p; 
      });
      }
    });

  }

  void listenToEvent() {
    widget.audioplayer.playerStateStream.listen((state) {
      if(mounted){
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
      }
    });
  } 

  void listenToSongIndex() {
    widget.audioplayer.currentIndexStream.listen(
      (event) {
        if(mounted){
          if(event != null && event >=0 && event <widget.songsList.length){
            setState(() {
              currentindex=event;
              context.read<AudioModelProvider>().setId(widget.songsList[currentindex].image!);
            });
          }
        }
      },
    );
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
                         Text(widget.songsList[currentindex].title,maxLines: 1,overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white,fontSize: 20  ),),
                         SizedBox(height: 10,),
                         Text(widget.songsList[currentindex].artist,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontSize: 15 )),
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
                                  addToFavDbNowPlaying(widget.song,);
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
                              if(widget.audioplayer.hasPrevious){
                                widget.audioplayer.seekToPrevious();
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
                            onPressed: (){
                              if(widget.audioplayer.hasNext){
                                widget.audioplayer.seekToNext();
                              }
                            }, 
                            icon: Icon(Icons.arrow_forward_ios_outlined,color: Colors.white,) 
                          ),
                          IconButton(
                            onPressed: (){                              
                            }, 
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


  addToFavDbNowPlaying(song)async{
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