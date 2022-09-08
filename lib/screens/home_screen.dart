import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_egg_market/data/user_model.dart';
import 'package:my_egg_market/screens/home/home_page.dart';
import 'package:my_egg_market/screens/home/map_page.dart';
import 'package:my_egg_market/screens/home/user_profile_page.dart';
import 'package:my_egg_market/states/user_notifier.dart';
import 'package:my_egg_market/widget/expandable_fab.dart';
import 'package:provider/provider.dart';

import '../router/locations.dart';
import 'home/chat_list_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    UserModel? userModel = context.read<UserNotifier>().userModel;
    return Scaffold(
        appBar: AppBar(
          //todo: 주소 Parse
          title: Text('장위동'),
          centerTitle: false,
          actions: [
            IconButton(
                onPressed: () {
                  context.beamToNamed('/$LOCATION_SEARCH');
                },
                icon: const Icon(CupertinoIcons.search))
          ],
        ),
        body: userModel == null
            ? Container()
            : IndexedStack(
                index: _selectedIndex,
                children: [
                  HomePage(
                    userKey: userModel.userKey,
                  ),
                  MapPage(userModel),
                  ChatListPage(
                    userKey: userModel.userKey,
                  ),
                  UserProfilePage(userModel: userModel,),
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
                icon: Icon(
                    _selectedIndex == 0 ? Icons.home : Icons.home_outlined),
                label: '홈'),
            BottomNavigationBarItem(
                icon: Icon(_selectedIndex == 1
                    ? CupertinoIcons.location_solid
                    : CupertinoIcons.location),
                label: '내 근처'),
            BottomNavigationBarItem(
                icon: Icon(_selectedIndex == 3
                    ? CupertinoIcons.chat_bubble_2_fill
                    : CupertinoIcons.chat_bubble_2),
                label: '채팅'),
            const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.profile_circled), label: '내정보'),
          ],
        ),
        floatingActionButton: _selectedIndex == 0
            ? FloatingActionButton(
          heroTag: 'home',
                onPressed: () {
                  context.beamToNamed(LOCATION_INPUT);
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              )
            : Container()
        // floatingActionButton: ExpandableFab(distance: 90, children: [
        //   MaterialButton(
        //     shape: CircleBorder(),
        //     onPressed: () {
        //       context.beamToNamed(LOCATION_INPUT);
        //     },
        //     child: Icon(Icons.add),
        //     color: Colors.orange[300],
        //   ),
        //   MaterialButton(
        //     shape: CircleBorder(),
        //     onPressed: () {},
        //     child: Icon(Icons.zoom_out_map_rounded),
        //     color: Colors.orange[300],
        //   ),
        //   MaterialButton(
        //     shape: CircleBorder(),
        //     onPressed: () {},
        //     child: Icon(Icons.zoom_out_map_rounded),
        //     color: Colors.orange[300],
        //   ),
        // ]),
        );
  }

  void _itemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
