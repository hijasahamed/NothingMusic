import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nothing_music/db/model/Audio_model/db_model.dart';
import 'package:nothing_music/provider/art_work_provider.dart';
import 'package:nothing_music/screens/Songs/now_playing_screen.dart';
import 'package:nothing_music/screens/Songs/songs_functions.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

final AudioPlayer audioPlayerAudio= AudioPlayer();


class Songsscreen extends StatefulWidget {
  const Songsscreen({super.key});

  @override
  State<Songsscreen> createState() => _SongsscreenState();
}

List allSongs=[];

class _SongsscreenState extends State<Songsscreen> {

  bool isPlaying=true;

  NowPlayingScreen? nowPlayingScreen;


  @override
  void initState() {
    super.initState();
    listenToEvent();
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
          });
        }
      }
    });
  }

  bool isIndexPlaying(int index) {
    return audioPlayerAudio.currentIndex == index && audioPlayerAudio.playing;
  }
  
  bool resume=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Scrollbar(
          radius:const Radius.circular(20),
          thickness: 2,
          child: FutureBuilder<Box<AudioModel>>(
              future: Hive.openBox<AudioModel>('songs_db'),
              builder: (context, snapshot) {
               if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasData) {
                  final songbox = snapshot.data!.values.toList();         
                  if (songbox.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LottieBuilder.asset(
                            'Assets/Animations/no result animation.json',
                            height: 150,
                          ),
                          const Text(
                            'No Song Found In Device',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  songbox.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase())); //sorted songs in the list songbox//
                  allSongs.addAll(songbox);
                  return ListView.separated(
                    itemBuilder: (ctx, index) {
                      final songs = songbox[index];
                      final playingIndex=isIndexPlaying(index); 
                      return ListTile(
                        onTap: () {                      
                          // Navigator.of(context)
                          //     .push(MaterialPageRoute(builder: (context) {
                          //   return NowPlayingScreen(                              
                          //     songsList: allSongs,
                          //     songindex: index,                              
                          //   );
                          // }));
                          if(nowPlayingScreen==null){
                            Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return NowPlayingScreen(                              
                              songsList: allSongs,
                              songindex: index,                              
                            );
                          }));
                          }
                          else{
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                              return nowPlayingScreen!;
                            }));
                          }
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
                        trailing: isPlaying ==true && playingIndex?  
                        Visibility(
                          visible: isPlaying, 
                          child: LottieBuilder.asset('Assets/Animations/mini player wave animation.json',height: 35,width: 35,)
                        )
                        :IconButton(
                          onPressed: () {
                            songsBottomSheet(context, songs, index, audioPlayerAudio);
                          }, 
                          icon:const  Icon(Icons.more_vert)
                        ),
                      );
                    },
                    separatorBuilder: ((context, index) => const SizedBox(height: 10,)),
                    itemCount: songbox.length,
                  );
                }
                else {
                  return const CircularProgressIndicator();
                }
              }),
        ));
  }

}
