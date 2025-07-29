import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_assets.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';

import '../cubit/setting_cubit.dart';
import '../cubit/setting_state.dart';
import '../service/setting_service.dart';
import 'widgets/personal_information_page.dart';
import 'widgets/personal_health_page.dart';
import 'widgets/notice_training_page.dart';
import 'pages/profile_view_page.dart';
import 'pages/profile_update_page.dart';
import 'pages/avatar_upload_page.dart';
import 'pages/personal_info_update_page.dart';
import 'pages/account_deletion_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SettingCubit(settingService: SettingService())..loadUserProfile(),
      child: const SettingView(),
    );
  }
}

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bLight,
      body: BlocConsumer<SettingCubit, SettingState>(
        listener: (context, state) {
          if (state is SettingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is SettingProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cập nhật thông tin thành công!'),
                backgroundColor: Colors.green,
              ),
            );
          }
          if (state is SettingAvatarUploaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tải ảnh đại diện thành công!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Stack(
              children: [
                // Background image like setting_demo
                Positioned.fill(
                  child: Image.asset(
                    TrainingAssets.mainBackground,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: 50.h),
                    // Header like setting_demo
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
                    // Content with same structure as setting_demo
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        children: [
                          _buildSectionTitle('Hồ sơ người dùng'),
                          _buildProfileSection(context),
                          _buildSectionTitle('Cài đặt chung'),
                          _buildOverallSettingsSection(context, state),
                          _buildSectionTitle('Thông tin hỗ trợ'),
                          _buildSettingsSection(context),
                          SizedBox(height: 20.h),
                          _buildLogoutButton(context),
                        ],
                      ),
                    ),
                  ],
                ),
                // Loading overlay
                if (state is SettingLoading) _buildLoadingOverlay(),
              ],
            ),
          );
        },
      ),
    );
  }

  // Build section title like setting_demo
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

  // Build profile section with all 5 API functions
  Widget _buildProfileSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Column(
        children: [
          // 1. View Profile (GET /api/v1/user/profile)
          _buildInnerTile(
            TrainingAssets.personalInformationIcon,
            'Xem thông tin Profile',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileViewPage(),
                ),
              );
            },
          ),
          // 2. Update Profile (PUT /api/v1/user/update-profile)
          _buildInnerTile(
            TrainingAssets.personalInformationIcon,
            'Cập nhật Profile',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileUpdatePage(),
                ),
              );
            },
          ),
          // 3. Upload Avatar (POST /api/v1/user/upload-avatar)
          _buildInnerTile(
            TrainingAssets.personalInformationIcon,
            'Upload Avatar',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AvatarUploadPage(),
                ),
              );
            },
          ),
          // 4. Personal Information (POST /api/v1/user/personal-information)
          _buildInnerTile(
            TrainingAssets.personalInformationIcon,
            'Cập nhật thông tin cá nhân',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PersonalInformationUpdatePage(),
                ),
              );
            },
          ),
          // Keep original pages for completeness
          _buildInnerTile(
            TrainingAssets.personalInformationIcon,
            'Thông tin cá nhân (Cũ)',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PersonalInformationPage(),
                ),
              );
            },
          ),
          _buildInnerTile(
            TrainingAssets.healthInformationIcon,
            'Thông tin sức khỏe',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PersonalHealthPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Build overall settings section like setting_demo but with state logic
  Widget _buildOverallSettingsSection(
    BuildContext context,
    SettingState state,
  ) {
    // Since isDarkMode doesn't exist in model, we'll use a simple boolean
    bool isDarkMode = false; // TODO: Add dark mode to user profile model

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
                value: isDarkMode,
                onChanged: (value) {
                  // TODO: Implement dark mode toggle
                },
                activeTrackColor: AppColors.bNormal,
                activeColor: AppColors.wWhite,
                inactiveTrackColor: AppColors.moreLighter,
                inactiveThumbColor: AppColors.wWhite,
              ),
            ),
            onTap: () {
              // TODO: Implement dark mode toggle
            },
          ),
          _buildInnerTile(
            TrainingAssets.noticeIcon,
            'Nhắc nhở luyện tập',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NoticeTrainingPage(),
                ),
              );
            },
          ),
          _buildInnerTile(
            TrainingAssets.trashIcon,
            'Xóa dữ liệu người dùng',
            onTap: () {
              _showDeleteUserDataDialog(context);
            },
          ),
          // 5. Delete Account (DELETE /api/v1/user/delete-my-account)
          _buildInnerTile(
            TrainingAssets.trashIcon,
            'Xóa tài khoản vĩnh viễn',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountDeletionPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Build settings section like setting_demo
  Widget _buildSettingsSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Column(
        children: [
          _buildInnerTile(
            TrainingAssets.commentIcon,
            'Đánh giá',
            onTap: () {
              // TODO: Navigate to rating page
            },
          ),
          _buildInnerTile(
            TrainingAssets.policyIcon,
            'Chính sách và điều khoản',
            onTap: () {
              // TODO: Navigate to policy page
            },
          ),
        ],
      ),
    );
  }

  // Build inner tile like setting_demo but with onTap logic
  Widget _buildInnerTile(String icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Image.asset(icon, color: AppColors.bDarkHover),
      title: Text(title, style: TextStyle(fontSize: 14.sp)),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16.r,
        color: AppColors.bDarkHover,
      ),
      onTap: onTap,
    );
  }

  // Build logout button like setting_demo but with logout logic
  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.wWhite,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: TextButton(
        onPressed: () {
          _showLogoutDialog(context);
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

  // Loading overlay
  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  // Show logout dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement logout logic
                // Navigate to login page
                Navigator.of(context).pushReplacementNamed('/auth');
              },
              child: const Text('Đăng xuất'),
            ),
          ],
        );
      },
    );
  }

  // Show delete user data dialog
  void _showDeleteUserDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xóa dữ liệu người dùng'),
          content: const Text(
            'Bạn có chắc chắn muốn xóa tất cả dữ liệu người dùng? '
            'Hành động này không thể hoàn tác.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement delete user data logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chức năng này sẽ được cập nhật sau'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
