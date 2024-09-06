import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tabaani/chat.dart';
import 'package:tabaani/home.dart';
import 'package:tabaani/profile.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);
  static const String id = 'bottom_navbar';

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _bottomNavIndex = 0;

  final List<IconData> iconList = [
    Icons.search,
    Icons.favorite,
    Icons.chat_bubble_outline,
    Icons.account_circle_rounded
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      HomeScreen(),
      PlaceholderWidget(color: Colors.red), // Placeholder for second tab
      MessageListScreen(),// Placeholder for third tab
      ProfileScreen(),
      
    ];
  }

  final List<String> titles = [
    'Home',
    'Favorites',
    'Messages',
    'Profile',
  ];

  void _onItemTapped(int index) {
    if (index < _widgetOptions.length) {
      setState(() {
        _bottomNavIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: _widgetOptions[_bottomNavIndex],
      ),
      floatingActionButton: FloatingActionButton(
        child: Image.asset('assets/tabaani.jpg', width: 24.0, height: 24.0),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: _onItemTapped,
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  const PlaceholderWidget({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}
