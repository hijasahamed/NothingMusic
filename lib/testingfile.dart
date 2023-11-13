/*import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:const EdgeInsets.all(5),
            child: Column(
              children: [

                Container(
                  width: double.infinity,
                  height: 190 ,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: 160,
                            width: 190,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                  image: AssetImage('images/earphone.webp'),
                                  fit: BoxFit.fill),
                            ),
                            child: const Center(
                                child: Text(
                                  'Recent Played',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20),
                                ),
                          ),
                          ),
                          Container(
                            height: 160,
                            width: 190,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                  image: AssetImage('images/earphone.webp'),
                                  fit: BoxFit.fill),
                            ),
                            child: const Center(
                                child: Text(
                                  'Most Played',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20),
                                ),
                          ),
                          )
                        ],
                      ),
                      Divider(
                        color: Color.fromARGB(255, 110, 19, 19),
                        thickness: 2,
                        height: 30,
                      ),
                    ],
                  ),
                ),


                Container(
                  width: double.infinity,
                  height: 532,
                  child: Stack(
                    children: [  
                      ListView.separated(
                        itemBuilder: (context,index){
                          return Container(
                            height: 75,
                            color: Color.fromARGB(255, 68, 21, 21),
                            
                          );
                        }, 
                        separatorBuilder: (context,index){
                          return Divider();
                        }, 
                        itemCount: 30
                      ),                     
                      Positioned(
                        bottom: 1 ,
                        right: 10,
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color.fromARGB(255, 59, 59, 58),
                          ),
                          child: IconButton(
                              onPressed: () {
                                _createPlaylist(context);
                              },
                              icon: Icon(Icons.playlist_add),
                          ),
                        ),
                      )
                      ],
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createPlaylist(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('New Playlist'),
          content: TextFormField(
            decoration: const InputDecoration(
              suffixIcon: Icon(Icons.edit_outlined),
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }
}*/



/*import 'package:dietplanner_project/screens/bottom_nav_screens/diary.dart';
import 'package:dietplanner_project/screens/bottom_nav_screens/progress.dart';
import 'package:dietplanner_project/screens/bottom_nav_screens/recipes.dart';
import 'package:dietplanner_project/screens/home_screen.dart';
import 'package:flutter/material.dart';

class MainBottom extends StatefulWidget {
  const MainBottom({super.key});

  @override
  State<MainBottom> createState() => _MainButtomState();
}

class _MainButtomState extends State<MainBottom> {
  int myCurrentIndex = 0;
  final List<Widget> pages = const [
    HomeScreen(),
    ScreenDiary(),
    ScreenProgress(),
    ScreenRecipes(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[myCurrentIndex],
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 25,
              offset: Offset(8, 20)),
        ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.black,
            currentIndex: myCurrentIndex,
            onTap: (index) {
              setState(() {
                myCurrentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: Container(
                      height: 30,
                      width: 30,
                      child: Image.asset('assets/dashboard.png')),
                  label: 'Dashboard'),
              BottomNavigationBarItem(
                  icon: Container(
                      height: 30,
                      width: 30,
                      child: Image.asset('assets/diary.png')),
                  label: 'Diary'),
              BottomNavigationBarItem(
                  icon: Container(
                      height: 30,
                      width: 30,
                      child: Image.asset('assets/success.png')),
                  label: 'Progress'),
              BottomNavigationBarItem(
                  icon: Container(
                      height: 30,
                      width: 30,
                      child: Image.asset('assets/recipes.png')),
                  label: 'Recipes'),
            ],
          ),
        ),
      ),
    );
  }
}*/
