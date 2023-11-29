import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:nothing_music/db/model/Audio_model/db_model.dart';
import 'package:nothing_music/provider/art_work_provider.dart';
import 'package:nothing_music/screens/most_played/most_played_functions.dart';
import 'package:nothing_music/screens/Songs/now_playing_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class Mostplayed extends StatefulWidget {
  const Mostplayed({super.key});

  @override
  State<Mostplayed> createState() => _MostplayedState();
}

class _MostplayedState extends State<Mostplayed> {


  List allsongs=[];

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title:const Text('Most Played',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 35, 35, 35),
      ),
      body: SafeArea(
        child: Scrollbar( 
          thickness: 2,
          radius:const Radius.circular(20),
          child: ValueListenableBuilder(
            valueListenable: mostplayedSongNotifier, 
            builder: (BuildContext ctx,List<AudioModel>mostPlayedsongslist,Widget? child){
              final temp=mostPlayedsongslist.reversed.toList();
              mostPlayedsongslist=temp.toList();
              if(mostPlayedsongslist.isEmpty){ 
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
                        ' No Songs In Most Played',  
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
              mostPlayedsongslist=mostPlayedsongslist.take(30).toList();
              allsongs.clear();
              allsongs.addAll(mostPlayedsongslist);            
              return ListView.separated(
                itemBuilder: ((context, index) {
                  final data=mostPlayedsongslist[index];
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context){
                          return NowPlayingScreen(songsList: allsongs, songindex: index);
                        }));
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
                      style:const TextStyle(color: Colors.white,),
                    ),
                    subtitle: Text(
                      data.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:const TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                        splashRadius: 25,
                        onPressed: () {
                          mostPlayedBottomSheeet(context, data, index,allsongs);                 
                        },
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        )),
                  );                
                }), 
                separatorBuilder: (ctx,index){
                  return const SizedBox(height: 10,);
                }, 
                itemCount: mostPlayedsongslist.length
              ); 
            }
          ),
        ),
      ),
    );
  }
}