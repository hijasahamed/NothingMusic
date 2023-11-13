import 'package:flutter/material.dart';

class Recentplayed extends StatelessWidget {
  const Recentplayed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Recent Played'),
        backgroundColor: Color.fromARGB(255, 35, 35, 35),
      ),
      body: SafeArea(
        child: Flexible(
          child: Container(
            child: ListView.separated(
            itemBuilder: (ctx, index) {
              return ListTile(
                leading: Container(
                  width: 60,
                  height: 90,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      image: DecorationImage(
                          image: AssetImage('Assets/images/heeriye.jpg'),
                          fit: BoxFit.fill)),
                ),
                title: Text(
                  'Heeriye-ft Dulquer salman',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Arjith Singh',
                  style: TextStyle(color: Colors.white),
                ), 
              );
            },
            separatorBuilder: ((context, index) => SizedBox(
                  height: 20,
                )),
            itemCount: 1),
          )
        ),
      ),
    );
  }
}