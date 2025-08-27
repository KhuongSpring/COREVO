import 'package:flutter/material.dart';
import 'package:hit_tech/core/constants/app_assets.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/view/personal_health/personal_health_start_page.dart';

import '../core/constants/app_dimension.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppAssets.mainBackground, fit: BoxFit.cover),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppAssets.welcomeHandImage,
                    height: AppDimensions.size152,
                    width: AppDimensions.size152,
                  ),
                  SizedBox(height: AppDimensions.spacingXL),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Xin Chào!',
                      style: TextStyle(
                        fontSize: AppDimensions.textSizeXXXL,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacingSM),
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      style: TextStyle(
                        color: AppColors.dark,
                        fontSize: AppDimensions.textSizeL,
                      ),
                      children: [
                        TextSpan(
                          text: 'Tôi là ',
                          style: TextStyle(
                            color: AppColors.dark,
                            fontSize: AppDimensions.textSizeL,
                          ),
                        ),
                        TextSpan(
                          text: 'Corevo',
                          style: TextStyle(
                            color: AppColors.bNormal,
                            fontSize: AppDimensions.textSizeL,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' - Trợ lý tập luyện của bạn\n\nSau đây là một số câu hỏi để ',
                          style: TextStyle(
                            color: AppColors.dark,
                            fontSize: AppDimensions.textSizeL,
                          ),
                        ),
                        TextSpan(
                          text: 'cá nhân hóa',
                          style: TextStyle(
                            color: AppColors.bNormal,
                            fontSize: AppDimensions.textSizeL,
                          ),
                        ),
                        TextSpan(
                          text: ' kế hoạch tập luyện dành cho bạn.',
                          style: TextStyle(
                            color: AppColors.dark,
                            fontSize: AppDimensions.textSizeL,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacingGiant),
                ],
              ),
            ),
          ),
          Positioned(
            left: AppDimensions.paddingL,
            right: AppDimensions.paddingL,
            bottom: AppDimensions.paddingXL,
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: AppDimensions.size48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonalHealthStartPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.bNormal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusLarge,
                      ),
                    ),
                  ),
                  child: Text(
                    'Bắt đầu',
                    style: TextStyle(
                      fontSize: AppDimensions.textSizeL,
                      color: AppColors.wWhite,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
