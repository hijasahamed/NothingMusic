import 'package:flutter/material.dart';
import 'package:nothing_music/screens/Playlists/most_played_screen.dart';
import 'package:nothing_music/screens/Playlists/recent_played_screen.dart';
import 'package:nothing_music/screens/Playlists/selected_playlist_screen.dart';

class Playlistscreen extends StatelessWidget {
  const Playlistscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
          
          
              Flexible(
                flex: 3,
                child: Container(
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
                              child: Center(
                                  child: Text(
                                'Recent Played',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20),
                              )),
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
                        ],
                      ),
                      Divider(
                        color: Color.fromARGB(255, 110, 19, 19),
                        thickness: 2,
                        height: 30,
                      ),
                    ],
                  ),
                )
              ),
              
              
              Flexible(
                flex: 6,
                child: Container(
                  height: double.infinity,
                  width: double.infinity , 
                  child: GridView.builder(
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
              ),
        
        
             /* Flexible(
                flex: 6,
                child: ListView.separated(
                  itemBuilder: (context,index){
                   return Container(
                      height: 75, 
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Color.fromARGB(255, 68, 21, 21),
                      ),
                    );
                  }, 
                  separatorBuilder: (context,index){
                    return Divider();
                  }, 
                  itemCount: 3
                ),
              ),*/
              
                
              Flexible(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  height: 70,
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
              ),
          
          
            ],
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