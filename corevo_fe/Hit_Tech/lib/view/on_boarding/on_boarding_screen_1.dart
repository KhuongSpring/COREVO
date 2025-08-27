import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_color.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_dimension.dart';

class OnBoardingScreen1 extends StatelessWidget {
  final PageController controller;

  const OnBoardingScreen1({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppAssets.splashImage1, fit: BoxFit.cover),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              AppAssets.splashChildImage,
              width: AppDimensions.spacingWidthInfinite,
              height: 400.w,
            ),
          ),
          Positioned(
            bottom: 60.w,
            left: 30.w,
            right: 30.w,
            child: Column(
              children: [
                Text(
                  'Tập trung vào mục tiêu',
                  style: TextStyle(
                    color: AppColors.wWhite,
                    fontSize: AppDimensions.textSizeL,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppDimensions.spacingM),
                SizedBox(
                  width: AppDimensions.width * 0.7.w,
                  child: Text(
                    'Cá nhân hóa lộ trình tập luyện phù hợp với thể trạng và mục tiêu của bạn, giúp bạn duy trì động lực và tiến bộ mỗi ngày.',
                    style: TextStyle(
                      color: AppColors.wWhite,
                      fontSize: AppDimensions.textSizeS,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: AppDimensions.spacingGiant),
                ElevatedButton(
                  onPressed: () {
                    controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.wWhite,
                    foregroundColor: AppColors.bNormal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusLarge,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingL,
                      vertical: AppDimensions.paddingM,
                    ),
                  ),
                  child: SizedBox(
                    width: AppDimensions.width * 0.3.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tiếp theo',
                          style: TextStyle(
                            fontSize: AppDimensions.textSizeM,
                            color: AppColors.dark,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: AppColors.bNormal,
                          size: AppDimensions.iconSizeXXXL,
                        ),
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
