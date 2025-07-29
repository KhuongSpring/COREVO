import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_assets.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';

import '../../cubit/setting_cubit.dart';
import '../../cubit/setting_state.dart';

class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({super.key});

  @override
  State<PersonalInformationPage> createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _userNameController;
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _nationalityController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _userNameController = TextEditingController();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _dateOfBirthController = TextEditingController();
    _nationalityController = TextEditingController();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dateOfBirthController.dispose();
    _nationalityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bLight,
      body: BlocConsumer<SettingCubit, SettingState>(
        listener: (context, state) {
          if (state is SettingPersonalInfoUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
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
          // Populate fields when data is loaded
          if (state is SettingLoaded) {
            _populateFields(state);
          }

          return Stack(
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
                  _buildHeader(context, state),
                  SizedBox(height: 40.h),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        children: [
                          _buildProfileSection(),
                          SizedBox(height: 20.h),
                          _buildSaveButton(state),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (state is SettingPersonalInfoUpdating) _buildLoadingOverlay(),
            ],
          );
        },
      ),
    );
  }

  void _populateFields(SettingLoaded state) {
    final personalInfo = state.userProfile.personalInformation;
    if (personalInfo != null) {
      _userNameController.text = personalInfo.userName ?? '';
      _fullNameController.text = personalInfo.fullName ?? '';
      _emailController.text = personalInfo.email ?? '';
      _phoneController.text = personalInfo.phoneNumber ?? '';
      _dateOfBirthController.text = personalInfo.dateOfBirth ?? '';
      _nationalityController.text = personalInfo.nationality ?? '';
    }
  }

  Widget _buildHeader(BuildContext context, SettingState state) {
    String displayName = 'User';
    String email = 'email@example.com';

    if (state is SettingLoaded) {
      displayName = state.userProfile.personalInformation?.fullName ?? 'User';
      email =
          state.userProfile.personalInformation?.email ?? 'email@example.com';
    }

    return Column(
      children: [
        Stack(
          children: [
            Positioned(
              left: 20.w,
              top: 0,
              bottom: 70.h,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back_ios, color: AppColors.bNormal),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 40.r,
                backgroundImage: AssetImage(TrainingAssets.facebookIcon),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Text(
          displayName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: AppColors.normal,
          ),
        ),
        Text(
          email,
          style: TextStyle(fontSize: 12.sp, color: AppColors.lightActive),
        ),
      ],
    );
  }

  Widget _buildProfileSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Column(
        children: [
          _buildEditableField('Tên đăng nhập', _userNameController),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildEditableField('Họ và tên', _fullNameController),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildEditableField(
            'Email',
            _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildEditableField(
            'Số điện thoại',
            _phoneController,
            keyboardType: TextInputType.phone,
          ),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildDateField('Ngày sinh', _dateOfBirthController),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildEditableField('Quốc tịch', _nationalityController),
        ],
      ),
    );
  }

  Widget _buildEditableField(
    String title,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return ListTile(
      title: Text(title, style: TextStyle(fontSize: 14.sp)),
      subtitle: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: AppColors.bNormal, fontSize: 14.sp),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Nhập $title',
          hintStyle: TextStyle(color: AppColors.lightActive, fontSize: 14.sp),
        ),
        validator: (value) {
          if (title == 'Email' && value != null && value.isNotEmpty) {
            if (!value.contains('@')) {
              return 'Email không hợp lệ';
            }
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDateField(String title, TextEditingController controller) {
    return ListTile(
      title: Text(title, style: TextStyle(fontSize: 14.sp)),
      subtitle: TextFormField(
        controller: controller,
        readOnly: true,
        style: TextStyle(color: AppColors.bNormal, fontSize: 14.sp),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Chọn ngày sinh',
          hintStyle: TextStyle(color: AppColors.lightActive, fontSize: 14.sp),
          suffixIcon: Icon(
            Icons.calendar_today,
            color: AppColors.bNormal,
            size: 20.r,
          ),
        ),
        onTap: () => _selectDate(context),
      ),
    );
  }

  Widget _buildSaveButton(SettingState state) {
    final isLoading = state is SettingPersonalInfoUpdating;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ElevatedButton(
        onPressed: isLoading ? null : _savePersonalInformation,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.bNormal,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppDimensions.borderRadiusLarge,
            ),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Lưu thay đổi',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateOfBirthController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _savePersonalInformation() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<SettingCubit>().updatePersonalInfo(
        userName: _userNameController.text.trim(),
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        dateOfBirth: _dateOfBirthController.text.trim(),
        nationality: _nationalityController.text.trim(),
      );
    }
  }
}
