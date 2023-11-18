import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nothing_music/db/function/db_function.dart';
import 'package:nothing_music/db/model/Playlist_model/playlist_db_model.dart';
import 'package:nothing_music/screens/Playlists/playlist_functions.dart';
import 'package:nothing_music/screens/Playlists/selected_playlist_screen.dart';

class PlaylistCreatedScreen extends StatefulWidget {
  const PlaylistCreatedScreen({super.key});

  @override
  State<PlaylistCreatedScreen> createState() => _PlaylistCreatedScreenState();
}

class _PlaylistCreatedScreenState extends State<PlaylistCreatedScreen> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ValueListenableBuilder(
        valueListenable: playlistNameNotifier, 
        builder: (BuildContext ctx,List<PlayListModel>playlistNameList,Widget? child){
          if(playlistNameList.isEmpty){
              return const Center(
                child: Text(
                    'No PlayList',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
              );
            }
          return GridView.builder( 
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.5
        ),
        itemBuilder: (ctx, index) { 
          final data=playlistNameList[index];                                            
          return Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(255, 68, 21, 21),
            ),
            child: InkWell(                            
              splashColor: Colors.white12,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (contex){ return Selectedplaylist();})); 
              },
              child: Column(
                children: [                             
                  Align(
                    alignment: Alignment.topRight,
                    child: PopupMenuButton(
                      color: Color.fromARGB(255, 60, 58, 58), 
                      elevation: 20, 
                      onSelected: (value) {
                        if (value == 'edit') {
                        
                        } else if (value == 'delete') {
                        
                        }
                      },
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                      itemBuilder: (BuildContext context) {
                        return [
                         const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start ,
                              children: [
                                Icon(Icons.edit,color: Colors.green,), 
                                Text('Edit',style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                         const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start ,
                              children: [
                                Icon(Icons.delete,color: Colors.red,),
                                Text('Delete',style: TextStyle(color: Colors.white),),
                              ],
                            ),
                          ),
                        ]; 
                      },
                    ),
                  ),
                  Text(data.name,style: TextStyle(fontSize: 20, color: Colors.white),),
                ],
              ),
            ),
          );
        },
        itemCount: playlistNameList.length,
      );
        }
      )
    );
  }

  
}