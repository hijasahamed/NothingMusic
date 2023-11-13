import 'package:flutter/material.dart';

class Selectedplaylist extends StatelessWidget {
  const Selectedplaylist({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Playlist'),
        actions: [
          IconButton(
            onPressed: (){}, 
            icon: Icon(Icons.playlist_add)
          )
        ],
      ),
      body: SafeArea(
        child: ListView.separated(
            itemBuilder: (ctx, index) {
              return ListTile(
                leading: Container(
                  width: 60,
                  height: 90,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      image: DecorationImage(
                          image: AssetImage('Assets/images/uyiril.jpg'),
                          fit: BoxFit.fill)),
                ),
                title: Text(
                  'uyiril thodum - kumbalangi nights',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Susin Shyam',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: IconButton(
                  onPressed: (){}, 
                  icon: Icon(Icons.remove_circle_outline,color: Colors.white,)
                ), 
              );
            },
            separatorBuilder: ((context, index) => SizedBox(
                  height: 20,
                )),
            itemCount: 1),
      ),
    );
  }
}