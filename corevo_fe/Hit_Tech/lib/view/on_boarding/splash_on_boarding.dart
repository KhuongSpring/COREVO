import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hit_tech/view/on_boarding/on_boarding_screen_1.dart';

import 'custom_page_indicator.dart';
import 'on_boarding_screen_2.dart';
import 'on_boarding_screen_3.dart';

class SplashOnboarding extends StatefulWidget {
  const SplashOnboarding({super.key});

  @override
  State<SplashOnboarding> createState() => _SplashOnboardingState();
}

class _SplashOnboardingState extends State<SplashOnboarding> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: _onPageChanged,
            children: [
              OnBoardingScreen1(controller: _controller), // Trang 1
              OnBoardingScreen2(controller: _controller), // Trang 2
              OnBoardingScreen3(controller: _controller), // Trang 3
            ],
          ),
          // Indicator
          Positioned(
            bottom: 140,
            left: 0,
            right: 0,
            child: CustomPageIndicator(currentIndex: _currentIndex),
          ),
        ],
      ),
    );
  }
}
