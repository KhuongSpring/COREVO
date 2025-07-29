import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_assets.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';

import '../../cubit/setting_cubit.dart';
import '../../cubit/setting_state.dart';

/// 5. DELETE /api/v1/user/delete-my-account - Xóa tài khoản
class AccountDeletionPage extends StatefulWidget {
  const AccountDeletionPage({super.key});

  @override
  State<AccountDeletionPage> createState() => _AccountDeletionPageState();
}

class _AccountDeletionPageState extends State<AccountDeletionPage> {
  final _confirmationController = TextEditingController();
  bool _isLoading = false;
  bool _isConfirmed = false;

  @override
  void dispose() {
    _confirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bLight,
      body: BlocConsumer<SettingCubit, SettingState>(
        listener: (context, state) {
          if (state is SettingAccountDeleted) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tài khoản đã được xóa thành công!'),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate to login or exit app
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else if (state is SettingError) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Stack(
              children: [
                // Background image
                Positioned.fill(
                  child: Image.asset(
                    TrainingAssets.mainBackground,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: 50.h),
                    // Header
                    _buildHeader(context),
                    SizedBox(height: 20.h),
                    // Content
                    Expanded(child: _buildContent(context)),
                  ],
                ),
                // Loading overlay
                if (_isLoading) _buildLoadingOverlay(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios,
              size: 24.r,
              color: AppColors.bDarkHover,
            ),
          ),
          Expanded(
            child: Text(
              'Xóa tài khoản',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.bDarkHover,
              ),
            ),
          ),
          SizedBox(width: 24.r), // Balance for back button
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        ),
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Warning Icon
            Center(
              child: Container(
                width: 80.r,
                height: 80.r,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(40.r),
                ),
                child: Icon(
                  Icons.warning_rounded,
                  size: 40.r,
                  color: Colors.red,
                ),
              ),
            ),
            SizedBox(height: 24.h),

            Text(
              'Xóa tài khoản vĩnh viễn',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 16.h),

            // Warning content
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.05),
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusSmall,
                ),
                border: Border.all(color: Colors.red.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CẢNH BÁO: Hành động này không thể hoàn tác!',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Khi bạn xóa tài khoản, tất cả dữ liệu sau sẽ bị mất vĩnh viễn:',
                    style: TextStyle(fontSize: 14.sp, color: AppColors.dark),
                  ),
                  SizedBox(height: 8.h),
                  _buildWarningItem('• Thông tin cá nhân và hồ sơ'),
                  _buildWarningItem('• Dữ liệu luyện tập và tiến độ'),
                  _buildWarningItem('• Lịch sử hoạt động'),
                  _buildWarningItem('• Các thiết lập và tùy chỉnh'),
                  _buildWarningItem('• Tất cả dữ liệu khác trong ứng dụng'),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Confirmation checkbox
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _isConfirmed,
                  onChanged: (value) {
                    setState(() {
                      _isConfirmed = value ?? false;
                    });
                  },
                  activeColor: Colors.red,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isConfirmed = !_isConfirmed;
                      });
                    },
                    child: Text(
                      'Tôi hiểu rằng việc xóa tài khoản này là vĩnh viễn và không thể hoàn tác. Tôi muốn tiếp tục xóa tài khoản của mình.',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.dark,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Confirmation text field
            Text(
              'Để xác nhận, vui lòng nhập "XÓA TÀI KHOẢN" vào ô bên dưới:',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.dark,
              ),
            ),
            SizedBox(height: 8.h),

            TextFormField(
              controller: _confirmationController,
              decoration: InputDecoration(
                hintText: 'Nhập "XÓA TÀI KHOẢN"',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusSmall,
                  ),
                  borderSide: BorderSide(color: Colors.red.withOpacity(0.5)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusSmall,
                  ),
                  borderSide: BorderSide(color: Colors.red.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusSmall,
                  ),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
                filled: true,
                fillColor: AppColors.wWhite,
              ),
            ),
            SizedBox(height: 32.h),

            // Delete button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    (_isConfirmed &&
                        _confirmationController.text.trim() ==
                            'XÓA TÀI KHOẢN' &&
                        !_isLoading)
                    ? _deleteAccount
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusSmall,
                    ),
                  ),
                ),
                child: Text(
                  _isLoading
                      ? 'Đang xóa tài khoản...'
                      : 'XÓA TÀI KHOẢN VĨNH VIỄN',
                  style: TextStyle(
                    color: AppColors.wWhite,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // Cancel button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _isLoading ? null : () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.bNormal),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusSmall,
                    ),
                  ),
                ),
                child: Text(
                  'Hủy bỏ',
                  style: TextStyle(
                    color: AppColors.bNormal,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Text(
        text,
        style: TextStyle(fontSize: 13.sp, color: AppColors.lightHover),
      ),
    );
  }

  void _deleteAccount() {
    // Show final confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Xác nhận cuối cùng',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: Text(
            'Bạn có chắc chắn muốn xóa tài khoản? Hành động này không thể hoàn tác!',
            style: TextStyle(fontSize: 14.sp, color: AppColors.dark),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Hủy bỏ',
                style: TextStyle(
                  color: AppColors.bNormal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isLoading = true;
                });
                context.read<SettingCubit>().deleteUserAccount();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(
                'Xóa tài khoản',
                style: TextStyle(
                  color: AppColors.wWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
