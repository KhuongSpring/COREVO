import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_dimension.dart';

class ActiveDialog {
  void showPauseDialog(BuildContext context, VoidCallback exit) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog.fullscreen(
          backgroundColor: AppColors.bNormal.withOpacity(0.9),
          child: Padding(
            padding: EdgeInsets.only(
              top: AppDimensions.size184,
              left: AppDimensions.paddingL,
              right: AppDimensions.paddingL,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tạm dừng',
                  style: TextStyle(
                    fontSize: AppDimensions.textSizeXL,
                    color: AppColors.wWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppDimensions.spacingSM),
                _buildDialogButton(
                  label: 'Thoát',
                  color: AppColors.bLightActive2,
                  textColor: AppColors.wWhite,
                  onPressed: exit,
                ),
                SizedBox(height: AppDimensions.spacingSM),
                _buildDialogButton(
                  label: 'Tiếp tục',
                  color: AppColors.wWhite,
                  textColor: AppColors.bNormal,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogButton({
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: AppDimensions.spacingWidthInfinite,
      height: AppDimensions.size48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          ),
        ),
        onPressed: onPressed,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: TextStyle(fontSize: AppDimensions.textSizeM),
          ),
        ),
      ),
    );
  }
}
