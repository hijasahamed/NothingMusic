import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nothing_music/db/model/Favourite_model/fav_db_model.dart';
import 'package:nothing_music/screens/Songs/mini_player.dart';
import 'package:nothing_music/screens/Songs/now_playing_screen.dart';
import 'package:nothing_music/screens/Songs/songs_screen.dart';
import 'package:nothing_music/screens/favourite/favourite_functions.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Favouritescreen extends StatefulWidget {
  const Favouritescreen({super.key,required this.onSongPlayed});
  
  final Function(bool) onSongPlayed;

  @override
  State<Favouritescreen> createState() => _FavouritescreenState();
}

 List allFavSongs=[];

class _FavouritescreenState extends State<Favouritescreen> {

  NowPlayingScreen? nowPlayingScreenInstance;

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
                      height: 120,
                      width: 120,
                    ),
                    const Text(
                      ' No Songs In Favourites',
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
            return ListView.separated(
              itemBuilder: (ctx, index) {
                final  data=favouriteSongs[index];           
                return ListTile(
                  splashColor: Colors.transparent,
                  onTap: (){
                    widget.onSongPlayed(true);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context){
                        return NowPlayingScreen(songsList: allFavSongs, songindex: index);
                      })
                    ); 
                    started=true;
                    miniPlayerData(data,favouriteSongs);                                             
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
                        favBottomSheeet(context,data,index,allFavSongs);                    
                      },
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      )),
                );
              },
              separatorBuilder: ((context, index) =>const SizedBox(height: 10,)), 
              itemCount: favouriteSongs.length,
            );
          }
        )

      ),
    );
  }

}

