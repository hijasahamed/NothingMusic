import 'package:flutter/material.dart';
import 'package:nothing_music/screens/Playlists/most_played_screen.dart';
import 'package:nothing_music/screens/Playlists/playlist_created_screen.dart';
import 'package:nothing_music/screens/Playlists/recent_played_screen.dart';
import 'package:nothing_music/screens/Playlists/selected_playlist_screen.dart';

class Playlistscreen extends StatelessWidget {
  const Playlistscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(7),
            child: Column(
              children: [

                Container(                   
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Ink(
                            height: 160,
                            width: 190,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                  image: AssetImage('Assets/images/earphone.webp'),
                                  fit: BoxFit.fill),
                            ),
                            child: InkWell(
                              splashColor: Colors.white12,
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (contex){ return Recentplayed();}));
                              },
                              child: Container(
                                height: 160,
                                width: double.infinity,
                                color: Colors.black12 ,
                                child: const Center(
                                  child:  Text(
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
                            width: 190,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                  image: AssetImage('Assets/images/earphone.webp'),
                                  fit: BoxFit.fill),
                            ),
                            child: InkWell(
                              splashColor: Colors.white12,
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (contex){ return Mostplayed();})); 
                              },
                              child: Container(
                                height: double.infinity,
                                width: double.infinity,
                                color: Colors.black12 ,
                                child: Center(
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
                      Divider(
                        color: Color.fromARGB(255, 110, 19, 19),
                        thickness: 2,
                        height: 30,
                      ),
                    ],
                  ),
                ),
              

                Container(
                  height: 460,
                  width: double.infinity,
                  child: PlaylistCreatedScreen(), 
                ),
  
                Container(
                  width: double.infinity,
                  height: 72,                
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
                          _createPlaylist(context);
                        },
                        child: Icon(
                          Icons.playlist_add,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
            
            
              ],
            ),
          ),
        )
      ),
    );
  }

  void _createPlaylist(context){
    showDialog(
      context: context, 
      builder: (ctx){
        return AlertDialog(
          title: Text('New Playlist'),
          content: TextFormField(
            decoration: const InputDecoration(
              suffixIcon: Icon(Icons.edit_outlined),
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words,
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              }, 
              child: Text('Cancel')
            ),
            TextButton(
              onPressed: (){}, 
              child: Text('Create')
            ),
          ],
        );
      }
    );
  }

}