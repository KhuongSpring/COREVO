import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_color.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_dimension.dart';

class PrivacyAndTermsScreen extends StatelessWidget {
  final String privacyAndTerms;

  const PrivacyAndTermsScreen({super.key, required this.privacyAndTerms});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppAssets.mainBackground, fit: BoxFit.cover),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingSM,
                      vertical: AppDimensions.spacingSM,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_ios),
                          ),
                        ),

                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Chính sách và điều khoản',
                            style: TextStyle(
                              fontSize: AppDimensions.textSizeL,
                              fontWeight: FontWeight.bold,
                              color: AppColors.dark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(AppDimensions.paddingM),
                    child: Text(
                      privacyAndTerms,
                      style: TextStyle(
                        fontSize: AppDimensions.textSizeM,
                        color: AppColors.dark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
