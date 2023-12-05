import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nothing_music/db/model/Audio_model/db_model.dart';
import 'package:nothing_music/screens/songs/mini_player.dart';
import 'package:nothing_music/screens/songs/songs_screen.dart';
import 'package:nothing_music/screens/recent_played/recent_played_functions.dart';
import 'package:nothing_music/screens/songs/now_playing_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Recentplayed extends StatefulWidget {
  const Recentplayed({super.key});

  @override
  State<Recentplayed> createState() => _RecentplayedState();
}

List allRecentSongs=[];


class _RecentplayedState extends State<Recentplayed> {

  @override
  void initState() {
   gettAllRecentSongs();
    super.initState();
  }
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Recent Played',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.white),),
        backgroundColor: Color.fromARGB(255, 35, 35, 35),
      ),
      body: SafeArea(
        child: Scrollbar( 
          thickness: 2,
          radius: Radius.circular(20),
          child: ValueListenableBuilder(
            valueListenable: recentSongNotifier, 
            builder: (BuildContext ctx,List<AudioModel>recentsongslist,Widget? child){
              final temp=recentsongslist.reversed.toList();
              recentsongslist=temp.toList();
              if(recentsongslist.isEmpty){
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
                        ' No Songs In Recent Played',
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
               recentsongslist=recentsongslist.take(30).toList();                  
              return ListView.separated(
                itemBuilder: ((context, index) {
                  final data=recentsongslist[index];
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context){
                          return NowPlayingScreen(songsList: allRecentSongs, songindex: index);
                        }));
                        started=true;
                        miniPlayerData(data, recentsongslist);
                    },                 
                    leading: QueryArtworkWidget(
                      id: data.image!,
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
                      data.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white,),
                    ),
                    subtitle: Text(
                      data.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                        splashRadius: 25,
                        onPressed: () {
                          recentPlayedBottomSheeet(context, data, index,allRecentSongs);                   
                        },
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        )),
                  );                
                }), 
                separatorBuilder: (ctx,index){
                  return SizedBox(height: 10,);
                }, 
                itemCount: recentsongslist.length
              ); 
            }
          ),
        ),
      ),
    );
  }

  
}