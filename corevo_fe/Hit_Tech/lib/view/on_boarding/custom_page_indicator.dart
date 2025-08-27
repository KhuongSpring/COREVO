import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';

class CustomPageIndicator extends StatelessWidget {
  final int currentIndex;

  const CustomPageIndicator({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        if (index == currentIndex) {
          return Container(
            width: AppDimensions.size24,
            height: AppDimensions.size8,
            margin: EdgeInsets.symmetric(horizontal: AppDimensions.paddingXS),
            decoration: BoxDecoration(
              color: AppColors.wWhite,
              borderRadius: BorderRadius.circular(
                AppDimensions.borderRadiusSmall,
              ),
            ),
          );
        } else {
          return Container(
            width: AppDimensions.size8,
            height: AppDimensions.size8,
            margin: EdgeInsets.symmetric(horizontal: AppDimensions.paddingXS),
            decoration: BoxDecoration(
              color: AppColors.wWhite.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
          );
        }
      }),
    );
  }
}
