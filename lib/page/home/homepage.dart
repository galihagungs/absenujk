import 'package:absenpraujk/page/home/dashboard.dart';
import 'package:absenpraujk/page/loginpage.dart';
import 'package:absenpraujk/service/pref_handler.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:one_clock/one_clock.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  List<Widget> tabItems = [
    Dashboard(),
    Center(child: Text("1")),
    Center(child: Text("2")),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: tabItems[_selectedIndex]),
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        items: [
          FlashyTabBarItem(icon: Icon(Icons.home), title: Text('Dashboard')),
          FlashyTabBarItem(
            icon: Icon(Icons.history),
            title: Text('Riwayat Absen'),
          ),
          FlashyTabBarItem(icon: Icon(Icons.person), title: Text('Profile')),
        ],
        onItemSelected:
            (index) => setState(() {
              _selectedIndex = index;
            }),
      ),
    );
  }
}
