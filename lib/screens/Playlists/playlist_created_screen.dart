import 'package:flutter/material.dart';
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
          final temp=playlistNameList.reversed.toList();
          playlistNameList=temp.toList();
          if(playlistNameList.isEmpty){
              return const Center(
                child: Text(
                    'No PlayList Available',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15
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
          return GestureDetector(
            onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (contex){ 
                    return Selectedplaylist( 
                      allPlaylistSong: data.songsList!,
                      playlistid: data.id,
                      playlistname: data.name,
                    );
                  })
                );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),              
                color: Color.fromARGB(255, 36, 3, 3),
              ),
              child: Column(
                children: [                             
                  Align(
                    alignment: Alignment.topRight,
                    child: PopupMenuButton(
                      color: Color.fromARGB(255, 60, 58, 58),
                      elevation: 20, 
                      onSelected: (value) { 
                        if (value == 'edit') {
                          playlistNameEdit(context,data.id,data.name,data.songsList);
                        } 
                        else if (value == 'delete') {
                          deleteThePlaylist(data.id, context, data.name);                          
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
                                SizedBox(width: 10,),
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
                                SizedBox(width: 10,),
                                Text('Delete',style: TextStyle(color: Colors.white),),
                              ],
                            ),
                          ),
                        ]; 
                      },
                    ),
                  ),
                  Text(data.name!,style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 210, 206, 206),fontWeight: FontWeight.w500),),
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