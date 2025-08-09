import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:intl/intl.dart';

class RecoverAccountPopUp extends StatefulWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final int dayRecoveryRemaining;

  const RecoverAccountPopUp({
    super.key,
    required this.onCancel,
    required this.onSave,
    required this.dayRecoveryRemaining,
  });

  @override
  State<RecoverAccountPopUp> createState() => _RecoverAccountPopUpState();
}

class _RecoverAccountPopUpState extends State<RecoverAccountPopUp> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width.sp * 0.8.sp,
          decoration: BoxDecoration(
            color: AppColors.wWhite,
            borderRadius: BorderRadius.circular(15.sp),
          ),
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tài khoản đã bị xóa !',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Bạn còn ${widget.dayRecoveryRemaining} ngày để khôi phục tài khoản.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 20),
              const Divider(height: 1, color: AppColors.bLightActive),
              Row(
                children: [
                  Expanded(
                    child: CupertinoButton(
                      onPressed: widget.onCancel,
                      child: const Text(
                        'Hủy bỏ',
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50.sp,
                    child: const VerticalDivider(
                      width: 1,
                      color: AppColors.bLightActive,
                    ),
                  ),
                  Expanded(
                    child: CupertinoButton(
                      onPressed: widget.onSave,
                      child: Text(
                        'Khôi phục',
                        style: TextStyle(
                          color: AppColors.bNormal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
