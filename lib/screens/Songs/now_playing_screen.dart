import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:nothing_music/db/model/Audio_model/db_model.dart';
import 'package:nothing_music/db/model/Favourite_model/fav_db_model.dart';
import 'package:nothing_music/db/model/Playlist_model/playlist_db_model.dart';
import 'package:nothing_music/provider/art_work_provider.dart';
import 'package:nothing_music/screens/Songs/mini_player.dart';
import 'package:nothing_music/screens/Songs/songs_screen.dart';
import 'package:nothing_music/screens/favourite/favourite_screen.dart';
import 'package:nothing_music/screens/most_played/most_played_functions.dart';
import 'package:nothing_music/screens/Playlists/playlist_functions.dart';
import 'package:nothing_music/screens/recent_played/recent_played_functions.dart';
import 'package:nothing_music/screens/Songs/songs_functions.dart';
import 'package:nothing_music/screens/favourite/favourite_functions.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NowPlayingScreen extends StatefulWidget {
   NowPlayingScreen({super.key,required this.songsList,required this.songindex,});
 

  final List songsList;
  final int songindex;
  

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}
bool isPlaying = true;
int currentindex=0;

class _NowPlayingScreenState extends State<NowPlayingScreen> {

  
  Duration duration=Duration.zero;
  Duration position=Duration.zero;
  bool _isFavourite=false;
  bool isshuffle=false;
  bool loopMode=false;

  late StreamSubscription<Duration?> _durationSubscription;
  late StreamSubscription<Duration?> _positionSubscription;
  late StreamSubscription<PlayerState> _playerStateSubscription;

  List<AudioSource> allSonglist=[];
  

  Map<String, Duration> playbackPositions = {};

  bool isFavoriteScreenSong = false;

  @override
  void initState() { 
    listenToSongIndex();     
    playSong();
    checkmount();
    isFavoriteScreenSong = widget.songsList == allFavSongs;
    super.initState();    
  }

  @override
  void dispose() {
    getAllRecentSongFromDb();
    allSonglist.clear();
    final currentUri = widget.songsList[currentindex].uri;
    playbackPositions[currentUri] = position;
    savePlaybackPosition(currentUri, position);
    audioPlayerAudio.setShuffleModeEnabled(false);
    audioPlayerAudio.setLoopMode(LoopMode.off); 
    _durationSubscription.cancel();
    _positionSubscription.cancel();
    _playerStateSubscription.cancel(); 
    // currentindex=0; 
    super.dispose();
  }

  playSong()async{
    if(!mounted){
      return;
    }
    try{
      for(var elements in widget.songsList){
        allSonglist.add(AudioSource.uri(
          Uri.parse(elements.uri.toString()),
          tag: MediaItem(
            id: elements.id.toString(), 
            album: elements.artist.toString(), 
            title: elements.title.toString(),
          ),
        ));
      }

      bool isCurrentlyPlayingSong =audioPlayerAudio.currentIndex == widget.songindex &&audioPlayerAudio.playing;
      Duration initialPosition =isCurrentlyPlayingSong ? audioPlayerAudio.position: Duration.zero;

       await audioPlayerAudio.setAudioSource(ConcatenatingAudioSource(children: allSonglist),initialIndex: widget.songindex,initialPosition: initialPosition);
      if (!isCurrentlyPlayingSong) {
        audioPlayerAudio.play();
      }

      
      listenToEvent();
      
      
    }
    on Exception catch (_){
      if(mounted){
        return; 
      }
    }

    audioPlayerAudio.durationStream.listen((d) {
      if(mounted){
        if (d != null) {
      setState(() {
        duration = d;
      });
    }
      }
    });
    audioPlayerAudio.positionStream.listen((p) {
      if(mounted){
        setState(() {
        position=p; 
      });
      }
    });

  }

  void listenToEvent() {
      _playerStateSubscription=  audioPlayerAudio.playerStateStream.listen((state) {
      if(mounted){
        if (state.playing) {
        setState(() {
          isPlaying = true;
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

  checkmount() {
    if (mounted) {
      _durationSubscription =
          audioPlayerAudio.durationStream.listen((duration) {
        if (duration != null) {
          setState(() {
            duration = duration;
          });
        }
      });
      _positionSubscription =
          audioPlayerAudio.positionStream.listen((position) {
        setState(() {
          position = position;
        });
      });
    }
  }

  void listenToSongIndex() {
    audioPlayerAudio.currentIndexStream.listen(
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
                miniPlayerData(recentsong,widget.songsList);
                checkAndAddToMostplayed(recentsong,widget.songsList[currentindex].uri,widget.songsList[currentindex]);
                                   
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

  Future<Duration> getStoredPlaybackPosition(String uri) async {
    final prefs = await SharedPreferences.getInstance();
    final storedPosition = prefs.getInt('playback_position_$uri') ?? 0;
    return Duration(seconds: storedPosition);
  }

  Future<void> savePlaybackPosition(String uri, Duration position) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('playback_position_$uri', position.inSeconds);
  }

  @override
  Widget build(BuildContext context) {
    if (currentindex < 0 || currentindex >= widget.songsList.length) {
    return Placeholder();
    }
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
          
               const SizedBox(                  
                  child: Center( 
                    child: ArtWorkWidget(),
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
                              activeColor: Colors.blue,
                              min: 0,
                              max: duration.inSeconds.toDouble(),
                              value: position.inSeconds.toDouble(), 
                              onChanged: (value)async{
                                final position = Duration(seconds: value.toInt());
                                await audioPlayerAudio.seek(position);
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
                                icon:const Icon(Icons.playlist_add ,color: Colors.white,),                            
                              ),
                            ),
                            if(!isFavoriteScreenSong)
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
                      const SizedBox(height: 25), 
                      Wrap(
                        spacing: 30 ,
                        children: [
                          IconButton(
                            onPressed: (){
                              isshuffle=!isshuffle;
                              if(isshuffle){
                                audioPlayerAudio.setShuffleModeEnabled(true);
                                shuffleOnSnackbar(context);
                              }
                              else{
                                audioPlayerAudio.setShuffleModeEnabled(false);
                                shuffleOffSnackbar(context);
                              }                           
                            }, 
                            icon: isshuffle==true?const Icon(Icons.shuffle,color: Colors.blue,) :const Icon(Icons.shuffle),
                          ),
                          IconButton(
                            onPressed: (){
                              if(audioPlayerAudio.hasPrevious){
                                audioPlayerAudio.seekToPrevious();
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
                                  if(isPlaying){
                                    audioPlayerAudio.pause();
                                  }
                                  else{
                                    audioPlayerAudio.play();
                                  }
                                  isPlaying = !isPlaying; 
                                });
                              }, 
                              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,color: Colors.black,),
                            ),
                          ),
                          IconButton(
                            onPressed: (){
                              if(audioPlayerAudio.hasNext){
                                audioPlayerAudio.seekToNext();
                              }
                            }, 
                            icon: Icon(Icons.arrow_forward_ios_outlined,color: Colors.white,) 
                          ),
                          IconButton(
                            onPressed: (){
                              loopMode=!loopMode;
                              if(loopMode){
                                audioPlayerAudio.setLoopMode(LoopMode.all);
                                loopOnSnackbar(context);
                              }
                              else{
                                audioPlayerAudio.setLoopMode(LoopMode.off);
                                loopOffSnackbar(context);
                              }           
                            }, 
                            icon: loopMode? Icon(Icons.repeat,color: Colors.blue,) :Icon(Icons.repeat)
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
    int? id;
    final favsongbox = await Hive.openBox<FavAudioModel>('fav_song_db');

    var a=favsongbox.values.toList();
    for(int i=0;i<a.length;i++){
      if(song.uri==a[i].uri){
         id=a[i].id;
      }
    }
    if(!favsongbox.values.any((element) => element.uri == song.uri)){
      final favSong=FavAudioModel(image: song.image!, title: song.title, artist: song.artist, uri: song.uri,); 
      addToFav(favSong);
      setState(() {
        _isFavourite=true;
      });
      favAddedSnackbar(context);
    }
    else if(favsongbox.values.any((element) => element.uri == song.uri)){
      removeFavSong(id!);
      setState(() {
        _isFavourite=false;
      });
      favRemovedsnackbar(context);
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