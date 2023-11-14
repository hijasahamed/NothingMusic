import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nothing_music/db/model/Audio_model/db_model.dart';
import 'package:nothing_music/screens/Songs/now_playing_screen.dart';
import 'package:nothing_music/screens/Songs/songs_functions.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:lottie/lottie.dart';


class Songsscreen extends StatefulWidget {
  const Songsscreen({super.key});

  @override
  State<Songsscreen> createState() => _SongsscreenState();
}

class _SongsscreenState extends State<Songsscreen> {

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
        body: Scrollbar(
          radius: Radius.circular(20),
          thickness: 2,
          child: FutureBuilder<Box<AudioModel>>(
              future: Hive.openBox<AudioModel>('songs_db'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
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
                      return ListTile(
                        onTap: () {                          
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return NowPlayingScreen(
                              song: songs,
                              audioplayer: _audioPlayer,
                              songsList: allSongs,
                              songindex: index,                              
                            );
                          }));
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
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          "${songs.artist}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              _showBottomSheet(context,songs,index);
                            },
                            icon: Icon(Icons.more_vert)
                        ),
                      );
                    },
                    separatorBuilder: ((context, index) => const SizedBox(
                          height: 20,
                        )),
                    itemCount: songbox.length,
                  );
                }
                else {
                  return CircularProgressIndicator();
                }
              }),
        ));
  }



  void _showBottomSheet(context,songs,index) {
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
            height: 325,
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
                        songs.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Text(
                        "${songs.artist}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 40,
                  thickness: 1,
                  indent: 30,
                  endIndent: 30,
                  color: Colors.white,
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return NowPlayingScreen(
                        song: songs,
                        audioplayer: _audioPlayer,
                        songsList: allSongs,
                        songindex: index,                        
                      );
                    }));
                  },
                  leading: Icon(
                    Icons.play_circle,
                    color: Colors.white,
                  ),
                  title: Text('Play',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                ListTile(
                  onTap: () {
                    addToFavDBBottomSheet(songs, context);
                  },
                  leading: Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                  ),
                  title: Text('Add to Favourite',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(
                    Icons.playlist_add,
                    color: Colors.white,
                  ),
                  title: Text('Add to Playlist',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  title: Text('Delete',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ],
            ),
          );
        });
  }

}