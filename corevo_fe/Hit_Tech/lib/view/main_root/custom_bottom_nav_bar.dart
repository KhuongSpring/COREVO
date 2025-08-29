import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_assets.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';

import '../../core/constants/app_color.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingS,
        vertical: AppDimensions.paddingS,
      ),
      margin: EdgeInsets.only(
        left: AppDimensions.paddingXXXL,
        top: AppDimensions.paddingM,
        right: AppDimensions.paddingXXXL,
        bottom: AppDimensions.paddingM,
      ),
      decoration: BoxDecoration(
        color: AppColors.bNormal,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(5, (index) {
          return _buildNavItem(index);
        }),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final icons = [
      AppAssets.homeIcon,
      AppAssets.libraryIcon,
      AppAssets.chartIcon,
      AppAssets.feedsIcon,
      AppAssets.profileIcon,
    ];

    final labels = [
      "Tổng quan",
      "Thư viện",
      "Luyện tập",
      "Cộng đồng",
      "Cá nhân",
    ];

    final isSelected = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? AppDimensions.paddingS : 0.w,
          vertical: AppDimensions.paddingS,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.bLightActive2 : AppColors.wWhite,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        ),
        constraints: BoxConstraints(minWidth: AppDimensions.size40, minHeight: AppDimensions.size40),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(left: isSelected ? 0 : AppDimensions.paddingS),
              child: Image.asset(
                icons[index],
                color: isSelected ? AppColors.wWhite : AppColors.dark,
                width: AppDimensions.iconSizeXL,
                height: AppDimensions.iconSizeXL,
              ),
            ),
            if (isSelected)
              Padding(
                padding: EdgeInsets.only(left: AppDimensions.paddingXS - 4.w),
                child: Text(
                  labels[index],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimensions.textSizeXS,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
