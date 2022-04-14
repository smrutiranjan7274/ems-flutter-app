// ignore_for_file: avoid_print

import 'package:eventhub/pages/events.dart';
import 'package:eventhub/pages/home.dart';
import 'package:eventhub/pages/search.dart';
import 'package:eventhub/pages/settings.dart';
import 'package:eventhub/utils/app_color.dart';
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
    const Search(),
    const UserSettings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EventHub'),
        backgroundColor: AppColors.blue,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: const Color(0xff3D56F0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
            padding: const EdgeInsets.all(8),
            tabs: const [
              GButton(
                icon: Icons.home_filled,
                text: 'Home',
              ),
              GButton(
                icon: Icons.calendar_month_outlined,
                text: 'Events',
              ),
              GButton(
                icon: Icons.search,
                text: 'Search',
              ),
              GButton(
                icon: Icons.settings,
                text: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
