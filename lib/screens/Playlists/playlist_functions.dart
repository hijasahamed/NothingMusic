
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nothing_music/db/model/Playlist_model/playlist_db_model.dart';
import 'package:nothing_music/screens/Songs/now_playing_screen.dart';
import 'package:nothing_music/screens/Songs/songs_functions.dart';
import 'package:nothing_music/screens/Songs/songs_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';


  ValueNotifier<List<PlayListModel>> playlistNameNotifier=ValueNotifier([]);
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final playListNameController = TextEditingController();



  addPlaylist(PlayListModel value)async{
    final playlistNameBox=await Hive.openBox<PlayListModel>('playlist_db');
    final _id= await playlistNameBox.add(value);
    value.id=_id;
    playlistNameBox.put(_id, value);
    getAllPlaylist();
  }
 
  getAllPlaylist()async{
    final playlistNameBox=await Hive.openBox<PlayListModel>('playlist_db');
    playlistNameNotifier.value.clear();
    playlistNameNotifier.value.addAll(playlistNameBox.values);
    playlistNameNotifier.notifyListeners();
  }

  removePlaylist(int id)async{
    final playlistNameBox=await Hive.openBox<PlayListModel>('playlist_db');
    playlistNameBox.delete(id);
    getAllPlaylist();
  }

  playlistEdit(PlayListModel value,int id)async{
    final playlistNameBox=await Hive.openBox<PlayListModel>('playlist_db');
    await playlistNameBox.put(id, value);
    getAllPlaylist();
  }


  createPlaylist(context,playListNameController){
    showDialog(
      context: context, 
      builder: (ctx){
        return AlertDialog(
          title: Text('New Playlist'),
          content: Form(
            key: formkey,
            child: TextFormField(              
              controller: playListNameController,
              validator: (value){
                if(value==null ||value.isEmpty){
                  return 'Enter Playlist Name';
                }
              },
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.edit_outlined),
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
                playListNameController.clear();
              }, 
              child: Text('Cancel')
            ),
            TextButton(
              onPressed: (){
                if(formkey.currentState!.validate()){
                  final playlistname=playListNameController.text.trim();
                  final name=PlayListModel(name: playlistname,songsList: []);
                  if(playlistname.isEmpty){
                    return;
                  }
                  addPlaylist(name);
                  Navigator.of(context).pop();
                  playListNameController.clear();
                  playListCreated(context);
                }
              }, 
              child: Text('Create')
            ),
          ],
        );
      }
    );
  }

  deleteThePlaylist(id,context,name)async{
    return showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text('Do You Want To Delete Playlist $name'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: Text('No')
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                removePlaylist(id);
                playListRemoved(context);
              },
              child: Text('Yes')
            )
          ],
        );
      },
      );
  }


  playlistNameEdit(context,id,name,list)async{
    TextEditingController editNameController = TextEditingController(text: name);
    showDialog(
      context: context, 
      builder: (ctx){
        return AlertDialog(
          title: Text('Edit Playlist'),
          content: Form(
            key: formkey,
            child: TextFormField(
              controller: editNameController,
              validator: (value){
                if(value==null ||value.isEmpty){
                  return 'Enter Playlist Name';
                }
              },
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.edit_outlined),
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
                editNameController.clear();
              }, 
              child: Text('Cancel')
            ),
            TextButton(
              onPressed: (){
                if(formkey.currentState!.validate()){
                  final editedName=editNameController.text.trim();
                  if(editedName.isEmpty){
                    return;
                  }
                  Navigator.pop(context);
                  final value=PlayListModel(name: name,id: id,songsList: list);
                  playlistEdit(value, id);
                  editNameController.clear();
                }
              }, 
              child: Text('Edit')
            ),
          ],
        );
      }
    );
  }

  
  showPlayListInBottomSheet(PlayListModel values, context) {
    showModalBottomSheet(
        backgroundColor: Color.fromARGB(255, 35, 35, 35),
        shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30), 
        )),
        context: context,
        builder: (context) {
          return Container(          
            height: 350,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ValueListenableBuilder(
                  valueListenable: playlistNameNotifier,
                  builder: (context, playlistList, child) {
                    final temp = playlistList.reversed.toList();
                    playlistList = temp.toList();
                    if (playlistList.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('CREATE NEW PLAYLIST',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                          SizedBox(height: 5,), 
                          Ink(
                            height: 70,
                            width: 70,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              color: Color.fromARGB(255, 59, 59, 58), 
                            ),
                            child: InkWell(
                              splashColor: Colors.white12,
                              onTap: () {                              
                                createPlaylist(context,playListNameController);
                              },
                              child: const Icon(
                                Icons.playlist_add,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      );
                    } 
                    else {
                      return ListView.separated(
                          itemBuilder: (ctx, index) {
                            final playlist = playlistList[index];
                            return GestureDetector(
                              onTap: () async {
                                Navigator.pop(context);
                                addlist(playlist.id!, playlist.name!, playlist.songsList,values ,ctx);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 1, 1, 1),
                                    borderRadius: BorderRadius.circular(20)),
                                width: double.infinity,
                                height: 70,
                                child: Row(                                
                                  children: [
                                    SizedBox(width: 20,),
                                    Icon(Icons.add,color: Colors.red,),
                                    SizedBox(width: 10,),
                                    Text(
                                      playlist.name ?? '',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (ctx, index) {
                            return SizedBox(height: 10,);
                          },
                          itemCount: playlistList.length);
                    }
                  }),
            ),
          );
        });
  }

  addlist(int id, String name, list, PlayListModel  value,context) async {
    final db = await Hive.openBox<PlayListModel>('playlist_db');
    if (!list.any((item) => item.uri == value.uri)) {
      list.add(value);    
      final a =PlayListModel (id: id, name: name, songsList: list);
      await db.put(id, a);
      addedToPlaylist(context);
    }
    else{
      alreadyInPlaylist(context);
    }
    getAllPlaylist();
  }

  playlistSongsOptions(context,songs,index,list,id) {
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
            height: 270,
            child: Column(
              children: [
                const SizedBox(
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
                        songsList: list,
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
                    addToFavDBBottomSheet(songs,context);
                  },
                  leading: Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                  ),
                  title: Text('Add to Favourite',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    deleteplaylistsong(list,index);
                    playlistSongdeleted(context);
                  },
                  leading: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  title: Text('Remove from Playlist',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ],
            ),
          );
        });
  }

  // deleteplaylistsongs(list,index, name,id) async {
  // final db = await Hive.openBox<PlayListModel >('playlist');
  // list.removeAt(index);
  // final a = PlayListModel (id: id, name: name, songsList: list);
  // await db.put(id, a);
  // getAllPlaylist(); 
  // }

  deleteplaylistsong(list ,index,)async{
    final refrehingDbList= await Hive.openBox<PlayListModel>('playlist_db');
    list.removeAt(index);
    getAllPlaylist();
  }



//scaffold messages//

  addedToPlaylist(context){
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(
      duration:  Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(50),
      content: Text(
        'Song Added to Playlist',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black, 
        ),
      ),
    ));
  }

  alreadyInPlaylist(context){
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(50),
      content: Text(
        'Song Already in Playlist',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black,
            ),
      ),
    ));
  }

  playListCreated(ctx){
    ScaffoldMessenger.of(ctx).showSnackBar(
       const SnackBar(
        content: Center(child: Text('Playlist Created',style: TextStyle(fontSize: 15),)),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(50),
        duration: Duration(seconds: 2),
      )
    );
  }

  playListRemoved(ctx){
    return ScaffoldMessenger.of(ctx).showSnackBar(
       const SnackBar(        
        content: Center(child: Text('Playlist Removed',style: TextStyle(fontSize: 15),)),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(50),
        duration: Duration(seconds: 2),
      )
    );
  }

  playlistSongdeleted(context){
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(
      duration:  Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(50),
      content: Text(
        'Song Deleted',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black, 
        ),
      ),
    ));
  }