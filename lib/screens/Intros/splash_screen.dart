import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nothing_music/screens/homescreen/home_screen.dart';
import 'package:nothing_music/screens/Intros/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    checkIfGetStarted();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black,), 
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.translate(
                offset: Offset(0,-50),
                child: ElevatedCircularAvatar(),
              )
            ],
          ),
        )
        ),
    );
  }


  Future<void> checkIfGetStarted() async{
    final _sharedprefs = await SharedPreferences.getInstance();
    final _istrue=_sharedprefs.getBool(key);
    if(_istrue==null||_istrue==false){
      await Future.delayed(Duration(seconds:2));
      Navigator.of(context). pushReplacement(
        MaterialPageRoute(
          builder: (ctx){
            return Welcomescreen();
        }
        )
      );
    }
    else{
      await Future.delayed(Duration(milliseconds: 1950));
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>Homescreen()));
    }
  }

}



class ElevatedCircularAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.black,
      radius: 100,
      child: LottieBuilder.asset('Assets/Animations/music logo animation.json',repeat: false,filterQuality: FilterQuality.high,),
    );
  }
}

