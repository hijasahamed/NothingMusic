import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nothing_music/db/function/db_function.dart';
import 'package:nothing_music/db/model/Audio_model/db_model.dart';
import 'package:nothing_music/provider/art_work_provider.dart';
import 'package:nothing_music/screens/Songs/mini_player.dart';
import 'package:nothing_music/screens/Songs/now_playing_screen.dart';
import 'package:nothing_music/screens/Songs/songs_functions.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


final AudioPlayer audioPlayerAudio= AudioPlayer();

class Songsscreen extends StatefulWidget {
  const Songsscreen({super.key});

  @override
  State<Songsscreen> createState() => _SongsscreenState();
}

List allSongs=[];
bool started=false;

class _SongsscreenState extends State<Songsscreen> {

  bool isPlaying=true; 
  

  @override
  void initState() {
    listenToEvent();
    super.initState();   
  }

  void checkStartedStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      started = prefs.getBool('started') ?? false;
    });
  }

  void setStartedStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('started', value);
  }

  void listenToEvent() {
    audioPlayerAudio.playerStateStream.listen((state) {
      if (mounted) {
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
            // setStartedStatus(false);
          });
        }
      }
    });
  }


  // bool isIndexPlaying(int index) {
  //   return audioPlayerAudio.currentIndex == index && audioPlayerAudio.playing;
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
              child: Scrollbar(
                radius:const Radius.circular(20),
                thickness: 2,                
                child: ValueListenableBuilder(
                  valueListenable: allSongNotifier, 
                  builder: (BuildContext ctx,List<AudioModel>allSongsList,Widget? child){
                    allSongsList.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
                    allSongs.addAll(allSongsList);
                    if(allSongsList.isEmpty){
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LottieBuilder.asset(
                              'Assets/Animations/no result animation.json',
                              height: 120,
                              width: 120,
                            ),
                            const Text(
                              ' No Songs',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    return RefreshIndicator(
                      color: Colors.blue,
                      backgroundColor: Colors.white,
                      displacement: 20,
                      onRefresh: _refresh,
                      child: ListView.separated(
                        itemBuilder: (ctx, index) {
                          final songs = allSongsList[index];
                          // final playingIndex=isIndexPlaying(index); 
                          return ListTile(
                            onTap: () {                       
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return NowPlayingScreen(                               
                                  songsList: allSongs,
                                  songindex: index,                              
                                );
                              }));
                              context.read<ArtWorkProvider>().setId(songs.image!);
                              // started=true;
                              // setStartedStatus(true);                                                 
                            },                    
                            leading: QueryArtworkWidget(
                              id: songs.image!,
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
                              songs.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              songs.artist,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:const TextStyle(color: Colors.white),
                            ), 
                            // trailing: isPlaying ==true && playingIndex?  
                            // Visibility(
                            //   visible: isPlaying, 
                            //   child: LottieBuilder.asset('Assets/Animations/mini player wave animation.json',height: 35,width: 35,)
                            // )
                            // :IconButton(
                            //   onPressed: () {
                            //     songsBottomSheet(context, songs, index, audioPlayerAudio);
                            //   }, 
                            //   icon:const  Icon(Icons.more_vert)
                            // ),
                            trailing: IconButton(
                              onPressed: () {
                                songsBottomSheet(context, songs, index, audioPlayerAudio);
                              }, 
                              icon:const  Icon(Icons.more_vert)
                            ),
                          );
                        },
                        separatorBuilder: ((context, index) => const SizedBox(height: 10,)),
                        itemCount: allSongsList.length,
                      ),
                    );
                  }
                ),
              ),
            ),
            // Visibility(
            //   visible: started,              
            //   child: MiniPlayer(songsList: allSongs,)
            // )
          ], 
        ));
  }

 Future<void> _refresh()async{
    await fetchSong();
    refreshSongsList(); 
    setState(() {
       Future.delayed(const Duration(seconds: 2)); 
    });  
        
  }

  Future<void> refreshSongsList() async {
    final songBox = await Hive.openBox<AudioModel>('songs_db');
    final songs = songBox.values.toList();
    songs.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    setState(() {
      allSongs.clear();
      allSongs.addAll(songs);
    });
  }
}


