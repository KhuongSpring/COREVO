import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_color.dart';

import '../../core/constants/app_assets.dart';

class OnBoardingScreen1 extends StatelessWidget {
  final PageController controller;

  const OnBoardingScreen1({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(TrainingAssets.splashImage1, fit: BoxFit.cover),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              TrainingAssets.splashChildImage,
              width: double.infinity,
              height: 400.sp,
            ),
          ),
          Positioned(
            bottom: 70,
            left: 30,
            right: 30,
            child: Column(
              children: [
                const Text(
                  'Tập trung vào mục tiêu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7.sp,
                  child: Text(
                    'Cá nhân hóa lộ trình tập luyện phù hợp với thể trạng và mục tiêu của bạn, giúp bạn duy trì động lực và tiến bộ mỗi ngày.',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 60.sp),
                ElevatedButton(
                  onPressed: () {
                    controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3.sp,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tiếp theo',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        Icon(Icons.keyboard_arrow_right, color: AppColors.bNormal, size: 30,)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
