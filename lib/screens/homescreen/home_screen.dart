import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:nothing_music/db/model/Audio_model/db_model.dart';
import 'package:nothing_music/provider/art_work_provider.dart';
import 'package:nothing_music/screens/Drawer/about_screen.dart';
import 'package:nothing_music/screens/Playlists/playlist_functions.dart';
import 'package:nothing_music/screens/most_played/most_played_functions.dart';
import 'package:nothing_music/screens/recent_played/recent_played_functions.dart';
import 'package:nothing_music/screens/Songs/now_playing_screen.dart';
import 'package:nothing_music/screens/favourite/favourite_functions.dart';
import 'package:nothing_music/screens/favourite/favourite_screen.dart';
import 'package:nothing_music/screens/Playlists/playlist_screen.dart';
import 'package:nothing_music/screens/Drawer/privacy_policy_screen.dart';
import 'package:nothing_music/screens/Songs/songs_screen.dart';
import 'package:nothing_music/screens/Drawer/terms_and_conditions_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../Intros/splash_screen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  void initState() {
    getAllFavSong();
    gettAllRecentSongs();
    getAllMostPlayedSongs();
    getAllPlaylist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 35, 35, 35),
            shadowColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20))),
            leading: Builder(builder: (context) {
              return IconButton(
                splashRadius: 27,
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(
                  Icons.menu,
                ),
                iconSize: 40,
              );
            }),
            centerTitle: true,
            title: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'NOTHING',
                  style: TextStyle(
                    color: Color.fromARGB(255, 250, 5, 5),
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, -8),
                  child: Text(
                    'Music',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                  splashRadius: 27,
                  onPressed: () {
                    showSearch(context: context, delegate: search());
                  },
                  icon: const Icon(
                    Icons.search,
                    size: 30,
                  ))
            ],
            bottom: TabBar(
                splashFactory: NoSplash.splashFactory,
                overlayColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Colors.transparent;
                  },
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: UnderlineTabIndicator(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(width: 30, color: Colors.white12),
                    insets: EdgeInsetsDirectional.symmetric(horizontal: 9)),
                indicatorPadding: EdgeInsets.only(bottom: 11),
                tabs: [
                  Tab(
                    child: Text(
                      'Songs',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Playlist',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Favourites',
                      style: TextStyle(fontSize: 17),
                    ),
                  )
                ]),
          ),
          drawer: Drawer(
            shape: const Border(right: BorderSide(color: Colors.white12)),
            backgroundColor: Colors.black,
            elevation: 10,
            width: 280,
            child: SafeArea(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(flex: 2, child: ElevatedCircularAvatar()),
                      Flexible(
                          flex: 6,
                          child: Container(
                            child: Column(
                              children: [
                                Ink(
                                  height: 60,
                                  width: 300,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (contex) {
                                        return About();
                                      }));
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          size: 30,
                                        ),
                                        Text(
                                          '  About',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Ink(
                                  height: 60,
                                  width: 300,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (contex) {
                                        return Termsandconditions();
                                      }));
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.receipt_rounded,
                                          size: 30,
                                        ),
                                        Text(
                                          '  Terms and Conditions ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Ink(
                                  height: 60,
                                  width: 300,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (contex) {
                                        return Privacyandpolicy();
                                      }));
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.privacy_tip_outlined,
                                          size: 30,
                                        ),
                                        Text(
                                          '  Privacy and Policy',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Flexible(
                          flex: 1,
                          child: Container(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                'Version 1.0',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: const SafeArea(
            child: TabBarView(children: [
              // First tab
              Songsscreen(),
              // Second tab
              Playlistscreen(),
              // Third tab
              Favouritescreen(),
            ]),
          ),
        ));
  }
}

class search extends SearchDelegate {
  List data = [];

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
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear_rounded))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<Box<AudioModel>>(
        future: Hive.openBox<AudioModel>('songs_db'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final songbox = snapshot.data!.values.toList();
            final filteredSongs = songbox
                .where((data) =>
                    data.title.toLowerCase().contains(query.toLowerCase()))
                .toList();
            if (query.isEmpty) {
              return Center(
                child: LottieBuilder.asset(
                  'Assets/Animations/searching song animation.json',
                  height: 200,
                  width: 200,
                ),
              );
            }
            else if(filteredSongs.isEmpty){
              return Center(
                child: Column(
                children: [
                  LottieBuilder.asset('Assets/Animations/no searched song animation.json',height: 150,width: 150,), 
                  Text('Sorry Searched Song Not Found',style: TextStyle(fontWeight: FontWeight.w500),),
                ],
              ),);  
            }
            return ListView.builder(
              itemBuilder: (ctx, index) {
                final data = filteredSongs[index];
                String namevalue = data.title;
                if (namevalue.toLowerCase().contains(query.toLowerCase())) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          context.read<ArtWorkProvider>().setId(data.image!);
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {                           
                            return NowPlayingScreen(songsList: filteredSongs, songindex: index);
                          }));
                        },
                        title: Text(
                          data.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                image: DecorationImage(
                                    image:
                                        AssetImage('Assets/images/music logo.png'),
                                    fit: BoxFit.fill)),
                          ),
                        ),
                      ),
                      const Divider(),
                    ],
                  );
                } 
                else {
                  return SizedBox();
                }
              },
              itemCount: filteredSongs.length,
            );
          } 
          else {
            return SizedBox();
          }
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<Box<AudioModel>>(
        future: Hive.openBox<AudioModel>('songs_db'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final songbox = snapshot.data!.values.toList();
            final filteredSongs = songbox
                .where((data) => data.title
                    .toLowerCase()
                    .contains(query.toLowerCase().trim()))
                .toList();
            if(filteredSongs.isEmpty){
              return Center(
                child: Column(
                children: [
                  LottieBuilder.asset('Assets/Animations/no searched song animation.json',height: 150,width: 150,), 
                  Text('Sorry Searched Song Not Found',style: TextStyle(fontWeight: FontWeight.w500),),
                ],
              ),); 
            }    
            return ListView.builder(
              itemBuilder: (ctx, index) {
                final data = filteredSongs[index];
                String namevalue = data.title;
                if (namevalue
                    .toLowerCase()
                    .contains(query.toLowerCase().trim())) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          context.read<ArtWorkProvider>().setId(data.image!);
                            Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return NowPlayingScreen(songsList: filteredSongs, songindex: index);
                          }));
                        },
                        title: Text(data.title,maxLines: 1,overflow: TextOverflow.ellipsis,),
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
                      ),
                      const Divider(),
                    ],
                  );
                } else {
                  return Container();
                }
              },
              itemCount: filteredSongs.length,
            );
          }
          return SizedBox();
        });
  }
}
