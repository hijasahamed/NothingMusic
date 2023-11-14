import 'package:flutter/material.dart';
import 'package:nothing_music/db/function/db_function.dart';
import 'package:nothing_music/screens/homescreen/home_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

const key='success';

class Welcomescreen extends StatefulWidget {
  const Welcomescreen({super.key});

  @override
  State<Welcomescreen> createState() => _WelcomescreenState();
}

class _WelcomescreenState extends State<Welcomescreen> {


  @override
  void initState() {
    super.initState();
     requestpermission();
  }

  void requestpermission()async{
     final PermissionStatus status= await Permission.audio.request();
     if(status.isGranted){
      onAudioQuery=OnAudioQuery();
      await fetchSong();
     }
     if(status.isDenied){
      openAppSettings();
     }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Flexible(
                flex: 6,
                child: Container(
                  width: double.infinity,
                  height: 350,          
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                      ),
                      image: DecorationImage(image: AssetImage('Assets/images/earphone.webp'),fit: BoxFit.fill)
                  ),
                ),
              ),
              Flexible(
                flex: 6,
                child: Column(
                  children: [ 
                    SizedBox(height: 30,),
                    Text('NOTHING',style: TextStyle(color: Color.fromARGB(255, 250, 5, 5),fontSize: 60,fontWeight: FontWeight.w900,fontFamily: "nothingfonts",letterSpacing: 2),),
                    Transform.translate(
                      offset: Offset(83, -19 ),
                      child: Text('Music',style: TextStyle(color: Colors.white,fontSize: 35,fontWeight: FontWeight.w500,),),
                    ),
                  ],
                )
              ),
              Flexible(
                flex: 1,
                child: ElevatedButton(           
                  onPressed: () {
                    checkifstarted(context);
                  },
                  style: ButtonStyle( 
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35)
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(Size(160, 60)),
                    backgroundColor: MaterialStateProperty.all(Colors.white)
                  ),
                  child: Text('GET STARTED',style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.w900,fontFamily: "nothingfonts",letterSpacing: 2),),
                ),
              )
            ],
          ),
        )
        ),
    );
  }

  checkifstarted(BuildContext ctx)async{    
      final _sharedprefs = await SharedPreferences.getInstance();
      await _sharedprefs.setBool(key, true);
      Navigator.of(ctx).pushReplacement(MaterialPageRoute(builder: (ctx)=>Homescreen()));
  }
    
}
