import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nothing_music/db/function/db_function.dart';
import 'package:nothing_music/db/model/Audio_model/db_model.dart';
import 'package:nothing_music/db/model/Favourite_model/fav_db_model.dart';
import 'package:nothing_music/db/model/Playlist_model/playlist_db_model.dart';
import 'package:nothing_music/provider/art_work_provider.dart';
import 'package:nothing_music/screens/most_played/most_played_functions.dart';
import 'package:nothing_music/screens/Playlists/playlist_functions.dart';
import 'package:nothing_music/screens/recent_played/recent_played_functions.dart';
import 'package:nothing_music/screens/Songs/songs_functions.dart';
import 'package:nothing_music/screens/favourite/favourite_functions.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';



class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key,required this.audioplayer,required this.songsList,required this.songindex});
 

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
  bool _isshuffle=false;

  List<AudioSource> allSonglist=[];
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
        allSonglist.add(AudioSource.uri(
          Uri.parse(elements.uri)
        ));
      }
      widget.audioplayer.setAudioSource(ConcatenatingAudioSource(children: allSonglist),initialIndex: widget.songindex);
      widget.audioplayer.play();
      listenToSongIndex();
      listenToEvent();
      
    }
    on Exception catch (_){
      if(mounted){
        return; 
      }
    }

    widget.audioplayer.durationStream.listen((d) {
      if(mounted){
        if (d != null) {
      setState(() {
        duration = d;
      });
    }
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
              context.read<ArtWorkProvider>().setId(widget.songsList[currentindex].image!);
              
              var recentsong= AudioModel(
                image: widget.songsList[currentindex].image, 
                title: widget.songsList[currentindex].title, 
                artist: widget.songsList[currentindex].artist, 
                uri: widget.songsList[currentindex].uri); 

                recentPlayedAdding(recentsong);

                addToMostPlayedList(recentsong); 


                                   
              _isFavourite = isSongInDatabase(widget.songsList[currentindex].uri);
            });
          }
        }
      },
    );
  }

  bool isSongInDatabase(String uri) {
  final favSongBox = Hive.box<FavAudioModel>('fav_song_db');
  return favSongBox.values.any((element) => element.uri == uri);
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
          
                Container(                  
                  child: Center( 
                    child: const ArtWorkWidget(),
                  ),
                ),
          
                Container(                  
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
          
                Container( 
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
                                onPressed: (){
                                  showPlayListInBottomSheet(PlayListModel(
                                    title: widget.songsList[currentindex].title,
                                    artist: widget.songsList[currentindex].artist,
                                    image: widget.songsList[currentindex].image,
                                    uri: widget.songsList[currentindex].uri,                                    
                                    ), context);
                                }, 
                                icon: Icon(Icons.playlist_add ,color: Colors.white,),                            
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.white24,
                              child: IconButton(
                                onPressed: (){                                 
                                  addToFavDbNowPlaying(widget.songsList[currentindex],context);
                                                                 
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
                            onPressed: (){
                              // shuffleSongs();                               
                            }, 
                            icon: Icon(Icons.shuffle,color: _isshuffle ? Colors.blue : Colors.white)
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
                ),
          
              ],
            ),
          ),
        ),
      ),
    );
  }


  addToFavDbNowPlaying(song,context)async{
    final favsongbox = await Hive.openBox<FavAudioModel>('fav_song_db');    
    if(!favsongbox.values.any((element) => element.uri == song.uri)){
      final _favSong=FavAudioModel(image: song.image!, title: song.title, artist: song.artist, uri: song.uri,); 
      addToFav(_favSong);
      setState(() {
        _isFavourite=true;
      });
      favAddedSnackbar(context);
    }
    // else if(favsongbox.values.any((element) => element.uri == song.uri)){
    //   removeFavSong(song.id);
    //   setState(() {
    //     _isFavourite=false;
    //   });
    //   favRemovedsnackbar(context);
    // }
    else{
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
      id: context.watch<ArtWorkProvider>().id, 
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