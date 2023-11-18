import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:nothing_music/db/function/db_function.dart';
import 'package:nothing_music/db/model/Favourite_model/fav_db_model.dart';
import 'package:nothing_music/provider/art_work_provider.dart';
import 'package:nothing_music/screens/Songs/now_playing_screen.dart';
import 'package:nothing_music/screens/Songs/songs_functions.dart';
import 'package:nothing_music/screens/favourite/favourite_functions.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class Favouritescreen extends StatefulWidget {
  const Favouritescreen({super.key});

  @override
  State<Favouritescreen> createState() => _FavouritescreenState();
}

class _FavouritescreenState extends State<Favouritescreen> {

  final AudioPlayer _audioPlayer = AudioPlayer();


  playSong(String? uri) {
    try {
      _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      _audioPlayer.play();
    } on Exception {
      print('error');
    }
  }

  List allSongs=[];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(        
        child: ValueListenableBuilder(
          valueListenable: favoriteSongNotifier, 
          builder: (BuildContext ctx,List<FavAudioModel>favouriteSongs,Widget? child){
            final temp=favouriteSongs.reversed.toList();
            favouriteSongs=temp.toList();
            if(favouriteSongs.isEmpty){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LottieBuilder.asset(
                      'Assets/Animations/no result animation.json',
                      height: 150,
                    ),
                    const Text(
                      'No Songs In Favourites',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              );
            }
            allSongs.addAll(favouriteSongs);
            return ListView.separated(
              itemBuilder: (ctx, index) {
                final  data=favouriteSongs[index];           
                return ListTile(
                  onTap: (){
                    context.read<ArtWorkProvider>().setId(data.image!);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context){
                        return NowPlayingScreen(audioplayer: _audioPlayer, songsList: allSongs, songindex: index);
                      })
                    );                    
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
                        favBottomSheeet(context,data,index,_audioPlayer);                    
                      },
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      )),
                );
              },
              separatorBuilder: ((context, index) =>const SizedBox(
                    height: 20,
                  )),
              itemCount: favouriteSongs.length,
            );
          }
        )

      ),
    );
  }

}
