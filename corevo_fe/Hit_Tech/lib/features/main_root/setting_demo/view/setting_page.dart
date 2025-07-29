import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_dimension.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bLight,
      body: SafeArea(
        child: Stack(
          children: [
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
                Padding(
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
                          'Cài đặt',
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
                ),
                SizedBox(height: 20.h),
                // Content
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    children: [
                      _buildSectionTitle('Hồ sơ người dùng'),
                      _buildProfileSection(),
                      _buildSectionTitle('Cài đặt chung'),
                      _buildOverallSettingsSection(),
                      _buildSectionTitle('Thông tin hỗ trợ'),
                      _buildSettingsSection(),
                      SizedBox(height: 20.h),
                      _buildLogoutButton(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.bDarkHover,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  // Build Inner tile
  Widget _buildInnerTile(String icon, String title) {
    return ListTile(
      leading: Image.asset(icon, color: AppColors.bDarkHover),
      title: Text(title, style: TextStyle(fontSize: 14.sp)),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16.r,
        color: AppColors.bDarkHover,
      ),
      onTap: () {},
    );
  }

  // Title 1
  Widget _buildProfileSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Column(
        children: [
          _buildInnerTile(
            TrainingAssets.personalInformationIcon,
            'Thông tin cá nhân',
          ),
          _buildInnerTile(
            TrainingAssets.healthInformationIcon,
            'Thông tin sức khỏe',
          ),
        ],
      ),
    );
  }

  // Title 2
  Widget _buildOverallSettingsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.only(left: 16.w, right: 5.w),
            leading: Image.asset(
              TrainingAssets.themeIcon,
              color: AppColors.bDarkHover,
            ),
            title: Text("Chế độ tối", style: TextStyle(fontSize: 14.sp)),
            trailing: Transform.scale(
              scale: 0.7,
              child: Switch(
                value: false,
                onChanged: (value) {},
                activeTrackColor: AppColors.bNormal,
                activeColor: AppColors.wWhite,
                inactiveTrackColor: AppColors.moreLighter,
                inactiveThumbColor: AppColors.wWhite,
              ),
            ),
            onTap: () {},
          ),
          _buildInnerTile(TrainingAssets.noticeIcon, 'Nhắc nhở luyện tập'),
          _buildInnerTile(TrainingAssets.trashIcon, 'Xóa dữ liệu người dùng'),
        ],
      ),
    );
  }

  // Title 3
  Widget _buildSettingsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Column(
        children: [
          _buildInnerTile(TrainingAssets.commentIcon, 'Đánh giá'),
          _buildInnerTile(
            TrainingAssets.policyIcon,
            'Chính sách và điều khoản',
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.wWhite,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: TextButton(
        onPressed: () {
          // TODO: Implement logout functionality
        },
        child: Text(
          'Đăng Xuất',
          style: TextStyle(
            color: Colors.red,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
