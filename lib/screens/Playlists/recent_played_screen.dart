import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:nothing_music/db/function/db_function.dart';
import 'package:nothing_music/db/model/Audio_model/db_model.dart';
import 'package:nothing_music/provider/art_work_provider.dart';
import 'package:nothing_music/screens/Songs/now_playing_screen.dart';
import 'package:nothing_music/screens/Songs/songs_functions.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class Recentplayed extends StatefulWidget {
  const Recentplayed({super.key});

  @override
  State<Recentplayed> createState() => _RecentplayedState();
}

class _RecentplayedState extends State<Recentplayed> {

  final AudioPlayer _audioPlayer = AudioPlayer();


  List allsongs=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Recent Played'),
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
                        height: 150,
                      ),
                      const Text(
                        'No Recent Songs',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                );
              }
              recentsongslist=recentsongslist.take(30).toList();
              allsongs.clear();
              allsongs.addAll(recentsongslist);            
              return ListView.separated(
                itemBuilder: ((context, index) {
                  final data=recentsongslist[index];
                  return ListTile(
                    onTap: () {
                      context.read<ArtWorkProvider>().setId(data.image!);
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context){
                          return NowPlayingScreen(audioplayer: _audioPlayer, songsList: allsongs, songindex: index);
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
                          recentBottomSheeet(context, data, index);                   
                        },
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        )),
                  );                
                }), 
                separatorBuilder: (ctx,index){
                  return Divider();
                }, 
                itemCount: recentsongslist.length
              ); 
            }
          ),
        ),
      ),
    );
  }

  recentBottomSheeet(context,data,index){
    showModalBottomSheet(
      backgroundColor: Color.fromARGB(255, 35, 35, 35),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      )),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 275,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(right: 35, left: 35),
                child: Column(
                  children: [
                    Text(
                      data.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      data.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 40,
                thickness: 1,
                indent: 30,
                endIndent: 30,
                color: Colors.white,
              ),
              ListTile(
                onTap: () {
                  context.read<ArtWorkProvider>().setId(data.image!); 
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return  NowPlayingScreen(audioplayer: _audioPlayer, songsList: allsongs, songindex: index);
                  }));
                },
                leading: const Icon(
                  Icons.play_circle,
                  color: Colors.white,
                ),
                title: const Text('Play',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),              
              ListTile(
                onTap: () {},
                leading: const Icon(
                  Icons.playlist_add,
                  color: Colors.white,
                ),
                title: const Text('Add to Playlist',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              ListTile(
                onTap: () {                
                    addToFavDBBottomSheet(data,context);
                },
                leading:const Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
                title: const Text('Add to Favorites',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ],
          ),
        );
      });
  }
}