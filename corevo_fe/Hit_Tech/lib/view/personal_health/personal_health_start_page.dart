import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hit_tech/core/constants/app_assets.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/view/personal_health/widget/age_selection_widget.dart';
import 'package:hit_tech/view/personal_health/widget/gender_selection_widget.dart';

import '../../core/constants/app_dimension.dart';

class PersonalHealthStartPage extends StatefulWidget {
  const PersonalHealthStartPage({super.key});

  @override
  State<PersonalHealthStartPage> createState() => _PersonalHealthStartPageState();
}

class _PersonalHealthStartPageState extends State<PersonalHealthStartPage> {
  final PageController _pageController = PageController();
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(const Duration(seconds: 5), () {
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          1,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: BouncingScrollPhysics(),
        children: [
          Stack(
            children: [
              // Ảnh nền
              Positioned.fill(
                child: Image.asset(
                  AppAssets.startBackground,
                  fit: BoxFit.cover,
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Phần 1',
                        style: TextStyle(
                          color: AppColors.wWhite,
                          fontSize: AppDimensions.textSizeM,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: AppDimensions.spacingSM),
                    Row(
                      children: [
                        Text(
                          'Chỉ số cơ thể',
                          style: TextStyle(
                            color: AppColors.wWhite,
                            fontSize: AppDimensions.textSizeXXXL,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Image.asset(AppAssets.customArrowIcon),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          GenderSelectionWidget(),
        ],
      )
    );
  }
}
