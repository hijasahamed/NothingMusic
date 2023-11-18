
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nothing_music/db/model/Playlist_model/playlist_db_model.dart';


  ValueNotifier<List<PlayListModel>> playlistNameNotifier=ValueNotifier([]);

  addPlaylist(PlayListModel value)async{
    final playlistNameBox=await Hive.openBox<PlayListModel>('playlist_name');
    playlistNameBox.add(value);  
  }

  geAllPlaylist()async{
    final playlistNameBox=await Hive.openBox<PlayListModel>('playlist_name');
    playlistNameNotifier.value.clear();
    playlistNameNotifier.value.addAll(playlistNameBox.values);
    playlistNameNotifier.notifyListeners();
  }
  

  void createPlaylist(context,playListNameController){
    showDialog(
      context: context, 
      builder: (ctx){
        return AlertDialog(
          title: Text('New Playlist'),
          content: TextFormField(
            controller: playListNameController,
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
              onPressed: (){
                // onCreateButtonClicked(context,playListNameController);
              }, 
              child: Text('Create')
            ),
          ],
        );
      }
    );
  }

  // onCreateButtonClicked(context,playListNameController)async{
  //   final playlistname=playListNameController.text.trim();
  //   final name=
  //   addPlaylist(name);
  //   Navigator.of(context).pop();
  //   playListNameController.clear();
  // }