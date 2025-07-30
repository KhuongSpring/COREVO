import 'package:flutter/material.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/view/main_root/custom_bottom_nav_bar.dart';
import 'package:hit_tech/view/main_root/home/home_screen.dart';
import 'package:hit_tech/view/main_root/setting/setting_screen.dart';
import 'package:hit_tech/view/main_root/training_library/view/training_page.dart';

class HomeRoot extends StatefulWidget {
  @override
  _HomeRootState createState() => _HomeRootState();
}

class _HomeRootState extends State<HomeRoot> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    TrainingPage(),
    SettingScreen(),
    SettingScreen(),
    SettingScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: AppColors.bLight,
  //     body: IndexedStack(
  //       index: _selectedIndex,
  //       children: _screens,
  //     ),
  //     bottomNavigationBar: CustomBottomNavBar(
  //       currentIndex: _selectedIndex,
  //       onTap: _onTabTapped,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bLight,
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: CustomBottomNavBar(
                currentIndex: _selectedIndex,
                onTap: _onTabTapped,
              ),
            ),
          ),
        ],
      ),
    );
  }
}