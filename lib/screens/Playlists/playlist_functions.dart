
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nothing_music/db/model/Playlist_model/playlist_db_model.dart';
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
                            height: 60,
                            width: 60,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
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
                                addlist(playlist.id!, playlist.name!, playlist.songsList,values );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 1, 1, 1),
                                    borderRadius: BorderRadius.circular(20)),
                                width: double.infinity,
                                height: 50,
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

Future<void> addlist(
    int id, String name, list, PlayListModel  value) async {
  final db = await Hive.openBox<PlayListModel>('playlist_db');
   print(list);
  if (!list.any((item) => item.uri == value.uri)) {
    list.add(value);
   
    final a =
        PlayListModel (id: id, name: name, songsList: list);
    await db.put(id, a);
    print(list);
  }
  getAllPlaylist();
}





//scaffold messages//

  addedToPlaylist(context){
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(
      duration:  Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(50),
      content: Text(
        'Added to Playlist',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black, 
            fontFamily: 'SLASHI'),
      ),
    ));
    Navigator.of(context).pop();
  }

  alreadyInPlaylist(context){
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(50),
      content: Text(
        'Already in Playlist',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black,
            ),
      ),
    ));
    Navigator.of(context).pop();
  }

    playListCreated(ctx){
    ScaffoldMessenger.of(ctx).showSnackBar(
       const SnackBar(
        content: Center(child: Text('Playlist Created',style: TextStyle(fontSize: 15),)),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        width: 300,
      )
    );
  }

  playListRemoved(ctx){
    return ScaffoldMessenger.of(ctx).showSnackBar(
       const SnackBar(        
        content: Center(child: Text('Playlist Removed',style: TextStyle(fontSize: 15),)),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        width: 300,
      )
    );
  }