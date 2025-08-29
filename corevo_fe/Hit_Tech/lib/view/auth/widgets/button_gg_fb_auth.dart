import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_color.dart';

import '../../../core/constants/app_dimension.dart';

class ButtonGgFbAuth extends StatelessWidget {
  final double width;
  final Image image;
  final String text;
  final VoidCallback onPressed;
  const ButtonGgFbAuth({
    super.key,
    required this.image,
    required this.text,
    required this.onPressed,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: AppDimensions.size48,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.moreLighter, width: 1.w),
        color: AppColors.wWhite,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: AppDimensions.borderRadiusSmall,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: AppDimensions.size32,
              height: AppDimensions.size32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.wWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: AppDimensions.borderRadiusSmall,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: image,
            ),
            SizedBox(width: AppDimensions.spacingM),
            Text(
              text,
              style: TextStyle(
                fontSize: AppDimensions.textSizeM,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
