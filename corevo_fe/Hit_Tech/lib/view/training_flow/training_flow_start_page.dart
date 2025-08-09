import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hit_tech/core/constants/app_assets.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/view/training_flow/widget/training_goal_selection_widget.dart';

class TrainingFlowStartPage extends StatefulWidget {
  const TrainingFlowStartPage({super.key});

  @override
  State<TrainingFlowStartPage> createState() => _TrainingFlowStartPageState();
}

class _TrainingFlowStartPageState extends State<TrainingFlowStartPage> {
  final PageController _pageController = PageController();
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(const Duration(seconds: 1), () {
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
                  TrainingAssets.startBackground,
                  fit: BoxFit.cover,
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Phần 2',
                        style: TextStyle(
                          color: AppColors.wWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Kế hoạch tập luyện',
                          style: TextStyle(
                            color: AppColors.wWhite,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Image.asset(TrainingAssets.customArrowIcon),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          TrainingGoalSelectionWidget()
        ],
      )
    );
  }
}
