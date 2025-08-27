import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';

class AuthCustomButton extends StatelessWidget {
  final bool isLoading;
  final String text;
  final VoidCallback? onPressed;

  const AuthCustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppDimensions.width * 0.9.w,
      height: AppDimensions.size56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.bNormal,
          disabledBackgroundColor: AppColors.lighter,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: AppDimensions.size24,
                height: AppDimensions.size24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.wWhite),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: AppDimensions.textSizeL,
                  fontWeight: FontWeight.bold,
                  color: AppColors.wWhite,
                ),
              ),
      ),
    );
  }
}
