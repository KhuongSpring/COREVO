import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_assets.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';

import '../../cubit/setting_cubit.dart';
import '../../cubit/setting_state.dart';

/// 1. GET /api/v1/user/profile - Lấy thông tin profile user
class ProfileViewPage extends StatelessWidget {
  const ProfileViewPage({super.key});

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
                    Expanded(child: _buildContent(context, state)),
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
              'Thông tin Profile',
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

  Widget _buildContent(BuildContext context, SettingState state) {
    if (state is SettingLoaded) {
      final profile = state.userProfile;

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
              // Avatar section
              Center(
                child: CircleAvatar(
                  radius: 50.r,
                  backgroundColor: AppColors.bNormal,
                  child: Icon(
                    Icons.person,
                    size: 50.r,
                    color: AppColors.wWhite,
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Profile information
              _buildInfoRow('Username', profile.username ?? 'N/A'),
              _buildInfoRow('First Name', profile.firstName ?? 'N/A'),
              _buildInfoRow('Last Name', profile.lastName ?? 'N/A'),
              _buildInfoRow('Phone', profile.phone ?? 'N/A'),
              _buildInfoRow('Nationality', profile.nationality ?? 'N/A'),
              _buildInfoRow('Address', profile.address ?? 'N/A'),
              _buildInfoRow('District', profile.district ?? 'N/A'),

              if (profile.personalInformation != null) ...[
                SizedBox(height: 16.h),
                Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.bDarkHover,
                  ),
                ),
                SizedBox(height: 8.h),
                _buildInfoRow(
                  'Full Name',
                  profile.personalInformation!.fullName ?? 'N/A',
                ),
                _buildInfoRow(
                  'Email',
                  profile.personalInformation!.email ?? 'N/A',
                ),
                _buildInfoRow(
                  'Phone',
                  profile.personalInformation!.phoneNumber ?? 'N/A',
                ),
                _buildInfoRow(
                  'Date of Birth',
                  profile.personalInformation!.dateOfBirth ?? 'N/A',
                ),
                _buildInfoRow(
                  'Nationality',
                  profile.personalInformation!.nationality ?? 'N/A',
                ),
              ],

              if (profile.healthInformation != null) ...[
                SizedBox(height: 16.h),
                Text(
                  'Health Information',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.bDarkHover,
                  ),
                ),
                SizedBox(height: 8.h),
                _buildInfoRow(
                  'Gender',
                  profile.healthInformation!.gender ?? 'N/A',
                ),
                _buildInfoRow(
                  'Height',
                  '${profile.healthInformation!.height ?? 0} cm',
                ),
                _buildInfoRow(
                  'Weight',
                  '${profile.healthInformation!.weight ?? 0} kg',
                ),
                _buildInfoRow(
                  'Activity Level',
                  profile.healthInformation!.activityLevel ?? 'N/A',
                ),
              ],

              SizedBox(height: 20.h),

              // Refresh button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<SettingCubit>().loadUserProfile();
                  },
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
                    'Làm mới',
                    style: TextStyle(
                      color: AppColors.wWhite,
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

    return Center(
      child: Text(
        'Đang tải thông tin...',
        style: TextStyle(fontSize: 16.sp, color: AppColors.bDarkHover),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
                color: AppColors.dark,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14.sp, color: AppColors.lightHover),
            ),
          ),
        ],
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
