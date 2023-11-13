import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:nothing_music/db/function/db_function.dart';
import 'package:nothing_music/db/model/Favourite_model/fav_db_model.dart';
import 'package:nothing_music/provider/Fav_Audio_Model_provider.dart';
import 'package:nothing_music/screens/favourite/play_all_favSong_screen.dart';
import 'package:nothing_music/screens/favourite/favnowplaying.dart';
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
            return Stack(
              children: [
                ListView.separated(
                  itemBuilder: (ctx, index) {
                    final data=favouriteSongs[index];             
                    return ListTile(
                      onTap: (){
                        context.read<FavAudioModelProvider>().setId(data.image!);
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context){
                            return FavNowPlayingScreen(song: data, audioplayer: _audioPlayer);
                          })
                        );
                        playSong(data.uri);
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
                            FavBottomSheeet(context,data);                    
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
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context){
                          return MiniPlayerScreen(audioPlayer: _audioPlayer,songModelList: favouriteSongs,);
                        })
                      );
                      favSongPlayAll(ctx);
                    },
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)), 
                      margin: const EdgeInsets.fromLTRB(0, 0, 15, 15),
                      child:  CircleAvatar(                       
                        radius: 35,
                        backgroundColor: Color.fromARGB(255, 44, 43, 43),                         
                        child: LottieBuilder.asset('Assets/Animations/playallfavsong animation.json'),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        )

      ),
    );
  }



  FavBottomSheeet(context,data){
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
                  context.read<FavAudioModelProvider>().setId(data.image!);
                  playSong(data.uri);
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return FavNowPlayingScreen(song: data, audioplayer: _audioPlayer);
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
                  if(data != null){
                    removeFavSong(data.id,);
                    Navigator.of(context).pop();
                    favRemovedsnackbar(context);
                  }
                },
                leading:const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                title: const Text('Remove From Favourites',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ],
          ),
        );
      });
  }


  favRemovedsnackbar(ctx){
    return ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        content: Center(child: Text('Song Removed From Favourites',style: TextStyle(fontSize: 15),)),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        width: 300,

      )
    );
  }

  favSongPlayAll(ctx){
    return ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        content: Center(child: Text('Playing All Favourite Songs',style: TextStyle(fontSize: 15,),)),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        width: 300,
      )
    );
  }



}
