import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:nothing_music/db/model/Audio_model/db_model.dart';
import 'package:nothing_music/db/model/Favourite_model/fav_db_model.dart';
import 'package:nothing_music/db/model/Playlist_model/playlist_db_model.dart';
import 'package:nothing_music/provider/art_work_provider.dart';
import 'package:nothing_music/screens/Intros/splash_screen.dart';
import 'package:provider/provider.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
   runApp(ChangeNotifierProvider(create: (context) => ArtWorkProvider(), 
   child: const MyApp(),
  )
);
    Hive.registerAdapter(AudioModelAdapter());
    Hive.registerAdapter(FavAudioModelAdapter());
    Hive.registerAdapter(PlayListModelAdapter());
  await Hive.openBox<AudioModel>('songs_db');
  await Hive.openBox<FavAudioModel>('Fav_song_db');

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );  
  
 
    
   
 
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const Splashscreen(),
    );
  }
}