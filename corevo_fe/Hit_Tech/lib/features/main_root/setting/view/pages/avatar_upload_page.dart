import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_assets.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';

import '../../cubit/setting_cubit.dart';
import '../../cubit/setting_state.dart';

/// 3. POST /api/v1/user/upload-avatar - Upload avatar
class AvatarUploadPage extends StatefulWidget {
  const AvatarUploadPage({super.key});

  @override
  State<AvatarUploadPage> createState() => _AvatarUploadPageState();
}

class _AvatarUploadPageState extends State<AvatarUploadPage> {
  File? _selectedImage;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bLight,
      body: BlocConsumer<SettingCubit, SettingState>(
        listener: (context, state) {
          if (state is SettingAvatarUploaded) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Upload avatar thành công!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
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
              'Upload Avatar',
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
          children: [
            // Current/Selected Avatar Display
            Container(
              width: 200.r,
              height: 200.r,
              decoration: BoxDecoration(
                color: AppColors.bLight,
                borderRadius: BorderRadius.circular(100.r),
                border: Border.all(color: AppColors.bNormal, width: 2.w),
              ),
              child: _selectedImage != null
                  ? ClipOval(
                      child: Image.file(
                        _selectedImage!,
                        width: 200.r,
                        height: 200.r,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(Icons.person, size: 100.r, color: AppColors.bNormal),
            ),
            SizedBox(height: 32.h),

            // Image Selection Buttons
            Text(
              'Chọn ảnh từ:',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.bDarkHover,
              ),
            ),
            SizedBox(height: 16.h),

            Row(
              children: [
                Expanded(
                  child: _buildImageSourceButton(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () => _showImagePickerNotAvailable(),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildImageSourceButton(
                    icon: Icons.photo_library,
                    label: 'Thư viện',
                    onTap: () => _showImagePickerNotAvailable(),
                  ),
                ),
              ],
            ),

            if (_selectedImage != null) ...[
              SizedBox(height: 32.h),

              Text(
                'Xem trước ảnh đã chọn',
                style: TextStyle(fontSize: 14.sp, color: AppColors.lightHover),
              ),
              SizedBox(height: 16.h),

              // Upload Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _uploadAvatar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.bNormal,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusSmall,
                      ),
                    ),
                  ),
                  child: Text(
                    _isLoading ? 'Đang upload...' : 'Upload Avatar',
                    style: TextStyle(
                      color: AppColors.wWhite,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              // Clear Selection Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _clearSelection,
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
                    'Xóa ảnh đã chọn',
                    style: TextStyle(
                      color: AppColors.bNormal,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],

            SizedBox(height: 20.h),

            // Info text
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.bLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusSmall,
                ),
              ),
              child: Text(
                'Lưu ý: Ảnh avatar nên có tỷ lệ vuông (1:1) và dung lượng dưới 5MB để có chất lượng tốt nhất.',
                style: TextStyle(fontSize: 12.sp, color: AppColors.lightHover),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.bLight.withOpacity(0.5),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
          border: Border.all(color: AppColors.bNormal.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32.r, color: AppColors.bNormal),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.bDarkHover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImagePickerNotAvailable() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Chức năng chọn ảnh chưa được triển khai. Cần thêm image_picker dependency.',
        ),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _clearSelection() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _uploadAvatar() {
    // For now, show a message that this feature needs implementation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Chức năng upload avatar sẽ được triển khai sau khi thêm image picker.',
        ),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
