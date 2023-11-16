import 'package:flutter/material.dart';
import 'package:nothing_music/screens/Playlists/selected_playlist_screen.dart';

class PlaylistCreatedScreen extends StatelessWidget {
  const PlaylistCreatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: 460, 
        width: double.infinity , 
        child: GridView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.5
          ),
          itemBuilder: (ctx, index) {                                              
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
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start ,
                                children: [
                                  Icon(Icons.edit,color: Colors.green,), 
                                  Text('Edit',style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                            PopupMenuItem(
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
                    Text('Playlist ${index + 1}',style: TextStyle(fontSize: 20, color: Colors.white),),
                  ],
                ),
              ),
            );
          },
          itemCount: 3,
        ),
      ),
    );
  }
}