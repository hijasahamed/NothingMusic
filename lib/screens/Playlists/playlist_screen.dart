import 'package:flutter/material.dart';
import 'package:nothing_music/screens/most_played/most_played_screen.dart';
import 'package:nothing_music/screens/Playlists/playlist_created_screen.dart';
import 'package:nothing_music/screens/Playlists/playlist_functions.dart';
import 'package:nothing_music/screens/recent_played/recent_played_screen.dart';

class Playlistscreen extends StatefulWidget {
  const Playlistscreen({super.key});

  @override
  State<Playlistscreen> createState() => _PlaylistscreenState();
}

class _PlaylistscreenState extends State<Playlistscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Wrap(
              spacing: 12,
              children: [
                Ink(
                  height: 160,
                  width: 180,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    image: DecorationImage(
                        image: AssetImage('Assets/images/earphone.webp'),
                        fit: BoxFit.fill),
                  ),
                  child: InkWell(
                    splashColor: Colors.white12,
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (contex) {
                        return const Recentplayed();
                      }));
                    },
                    child: Container(
                      height: 160,
                      width: double.infinity,
                      color: Colors.black12,
                      child: const Center(
                        child: Text(
                          'Recent Played',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
                Ink(
                  height: 160,
                  width: 180,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    image: DecorationImage(
                        image: AssetImage('Assets/images/earphone.webp'),
                        fit: BoxFit.fill),
                  ),
                  child: InkWell(
                    splashColor: Colors.white12,
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (contex) {
                        return const Mostplayed();
                      }));
                    },
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.black12,
                      child: const Center(
                          child: Text(
                        'Most Played',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 20),
                      )),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              color: Color.fromARGB(255, 110, 19, 19),
              thickness: 2,
              height: 25,
            ),
            Expanded(flex: 8, child: PlaylistCreatedScreen()),
            Expanded(
              flex: 2,
              child: SizedBox(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Ink(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color.fromARGB(255, 59, 59, 58),
                    ),
                    child: InkWell(
                      splashColor: Colors.white12,
                      onTap: () {
                        createPlaylist(context, playListNameController);
                      },
                      child: const Icon(
                        Icons.playlist_add,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
