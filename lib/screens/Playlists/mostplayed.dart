import 'package:flutter/material.dart';

class Mostplayed extends StatelessWidget {
  const Mostplayed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Most Played'),
        backgroundColor: const Color.fromARGB(255, 35, 35, 35),
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