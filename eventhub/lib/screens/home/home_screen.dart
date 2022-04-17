// ignore_for_file: avoid_print

import 'package:easevent/screens/pages/events.dart';
import 'package:easevent/screens/pages/explore.dart';
import 'package:easevent/screens/pages/settings.dart';
// import 'package:easevent/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const UserHome(),
    const UserEvents(),
    const UserSettings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('EventHub'),
      //   backgroundColor: AppColors.blue,
      // ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: const Color(0xff3D56F0),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: GNav(
            backgroundColor: const Color(0xff3D56F0),
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.black.withAlpha(50),
            gap: 8,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
              // print(index);
            },
            padding: const EdgeInsets.all(12),
            tabs: const [
              GButton(
                icon: Icons.explore,
                iconSize: 32,
                text: 'Explore',
                iconActiveColor: Color(0xff39D1F2),
              ),
              GButton(
                icon: Icons.calendar_month_outlined,
                iconSize: 32,
                text: 'Events',
                iconActiveColor: Color(0xff39D1F2),
              ),
              GButton(
                icon: Icons.settings,
                text: 'Settings',
                iconSize: 32,
                iconActiveColor: Color(0xff39D1F2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
