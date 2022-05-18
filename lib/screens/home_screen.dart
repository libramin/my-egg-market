import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_egg_market/screens/home/home_page.dart';
import 'package:my_egg_market/states/user_notifier.dart';
import 'package:my_egg_market/widget/action_button.dart';
import 'package:my_egg_market/widget/expandable_fab.dart';
import 'package:provider/provider.dart';

import '../router/locations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('장위동'),
        centerTitle: false,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(CupertinoIcons.bell)),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomePage(),
          Container(
            color: Colors.accents[1],
          ),
          Container(
            color: Colors.accents[2],
          ),
          Container(
            color: Colors.accents[3],
          ),
          Container(
            color: Colors.accents[4],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _itemTapped,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black38,
        items: [
          BottomNavigationBarItem(
              icon:
                  Icon(_selectedIndex == 0 ? Icons.home : Icons.home_outlined),
              label: '홈'),
          BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 1
                  ? CupertinoIcons.news_solid
                  : CupertinoIcons.news),
              label: '동네생활'),
          BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 2
                  ? CupertinoIcons.location_solid
                  : CupertinoIcons.location),
              label: '내 근처'),
          BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 3
                  ? CupertinoIcons.chat_bubble_2_fill
                  : CupertinoIcons.chat_bubble_2),
              label: '채팅'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.profile_circled), label: '나의에그'),
        ],
      ),
      floatingActionButton: ExpandableFab(distance: 90, children: [
        MaterialButton(
          shape: CircleBorder(),
            onPressed: (){
            context.beamToNamed(LOCATION_INPUT);
            },child: Icon(Icons.add),
        color: Colors.orange[300],),
        MaterialButton(
          shape: CircleBorder(),
          onPressed: (){},child: Icon(Icons.zoom_out_map_rounded),
          color: Colors.orange[300],),
        MaterialButton(
          shape: CircleBorder(),
          onPressed: (){},child: Icon(Icons.zoom_out_map_rounded),
          color: Colors.orange[300],),
      ]),
    );
  }

  void _itemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
