import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_assets.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';

import '../../cubit/setting_cubit.dart';
import '../../cubit/setting_state.dart';

/// 2. PUT /api/v1/user/update-profile - Cập nhật profile user
class ProfileUpdatePage extends StatefulWidget {
  const ProfileUpdatePage({super.key});

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalityController = TextEditingController();
  final _addressController = TextEditingController();
  final _districtController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Load current profile data
    final currentProfile = context.read<SettingCubit>().currentUserProfile;
    if (currentProfile != null) {
      _usernameController.text = currentProfile.username ?? '';
      _firstNameController.text = currentProfile.firstName ?? '';
      _lastNameController.text = currentProfile.lastName ?? '';
      _phoneController.text = currentProfile.phone ?? '';
      _nationalityController.text = currentProfile.nationality ?? '';
      _addressController.text = currentProfile.address ?? '';
      _districtController.text = currentProfile.district ?? '';
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _nationalityController.dispose();
    _addressController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bLight,
      body: BlocConsumer<SettingCubit, SettingState>(
        listener: (context, state) {
          if (state is SettingProfileUpdated) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cập nhật profile thành công!'),
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
              'Cập nhật Profile',
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thông tin cơ bản',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.bDarkHover,
                ),
              ),
              SizedBox(height: 16.h),

              _buildTextField(
                controller: _usernameController,
                label: 'Username',
                isRequired: true,
              ),
              SizedBox(height: 16.h),

              _buildTextField(
                controller: _firstNameController,
                label: 'Tên',
                isRequired: true,
              ),
              SizedBox(height: 16.h),

              _buildTextField(
                controller: _lastNameController,
                label: 'Họ',
                isRequired: true,
              ),
              SizedBox(height: 16.h),

              _buildTextField(
                controller: _phoneController,
                label: 'Số điện thoại',
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16.h),

              _buildTextField(
                controller: _nationalityController,
                label: 'Quốc tịch',
              ),
              SizedBox(height: 16.h),

              _buildTextField(
                controller: _addressController,
                label: 'Địa chỉ',
                maxLines: 2,
              ),
              SizedBox(height: 16.h),

              _buildTextField(
                controller: _districtController,
                label: 'Quận/Huyện',
              ),
              SizedBox(height: 32.h),

              // Update button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateProfile,
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
                    _isLoading ? 'Đang cập nhật...' : 'Cập nhật Profile',
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isRequired = false,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + (isRequired ? ' *' : ''),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.dark,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: isRequired
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '$label không được để trống';
                  }
                  return null;
                }
              : null,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppDimensions.borderRadiusSmall,
              ),
              borderSide: BorderSide(color: AppColors.bLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppDimensions.borderRadiusSmall,
              ),
              borderSide: BorderSide(color: AppColors.bLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppDimensions.borderRadiusSmall,
              ),
              borderSide: BorderSide(color: AppColors.bNormal),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            filled: true,
            fillColor: AppColors.wWhite,
          ),
        ),
      ],
    );
  }

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // For now, we can only update username through the updateProfile API
      // Other fields like firstName, lastName, phone, nationality, address, district
      // would need to be handled through personal information API or separate endpoints
      context.read<SettingCubit>().updateProfile(
        username: _usernameController.text.trim(),
      );
    }
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
