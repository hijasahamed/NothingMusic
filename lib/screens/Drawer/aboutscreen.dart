import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('About'),
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text('Welcome To Nothing Music',style: TextStyle(color: Colors.red,fontSize: 25),), 
                Text('\nNothing Music App, make your life more live.We are dedicated to providing you the very best quality of sound and the music varient,with an emphasis on new features. playlists and favourites,and a rich user experience\n\nFounded in 2023 by Hijas Ahamed . Nothing Music app is our first major project with a basic performance of music hub and creates a better versions in future.Nothing Music gives you the best music experience that you never had. it includes attractivemode of UI\'s and good practices.\n\nIt gives good quality and had increased the settings to power up the system as well as to provide better music rythms.\n\nWe hope you enjoy our music as much as we enjoy offering them to you.If you have any questions or comments, please don\'t hesitate to contact us.\n\nSincerely,\n\nHijas Ahamed',style: TextStyle(color: Colors.white,fontSize: 17),),
                
              ],
            ),
          ),
        )
      ),
    );
  }
}