import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nothing_music/db/model/Audio_model/db_model.dart';
import 'package:nothing_music/db/model/Favourite_model/fav_db_model.dart';
import 'package:nothing_music/provider/audio_model_provider.dart';
import 'package:nothing_music/provider/fav_audio_model_provider.dart';
import 'package:nothing_music/provider/searched_song_provider.dart';
import 'package:nothing_music/screens/Intros/splash_screen.dart';
import 'package:provider/provider.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
    Hive.registerAdapter(AudioModelAdapter());
    Hive.registerAdapter(FavAudioModelAdapter());
  
  await Hive.openBox<AudioModel>('songs_db');
  await Hive.openBox<FavAudioModel>('Fav_song_db');
    runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AudioModelProvider()),
        ChangeNotifierProvider(create: (context) => FavAudioModelProvider()),
        ChangeNotifierProvider(create: (context) => SearchedSongProvider()),
      ],
      child: const MyApp(),
    ),
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