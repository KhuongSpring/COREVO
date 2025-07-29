import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_assets.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';

import '../../cubit/setting_cubit.dart';
import '../../cubit/setting_state.dart';
import '../../model/setting_request_model.dart';

/// 4. POST /api/v1/user/personal-information - Cập nhật thông tin cá nhân
class PersonalInformationUpdatePage extends StatefulWidget {
  const PersonalInformationUpdatePage({super.key});

  @override
  State<PersonalInformationUpdatePage> createState() =>
      _PersonalInformationUpdatePageState();
}

class _PersonalInformationUpdatePageState
    extends State<PersonalInformationUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _nationalityController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Load current personal information data
    final currentProfile = context.read<SettingCubit>().currentUserProfile;
    if (currentProfile?.personalInformation != null) {
      final personalInfo = currentProfile!.personalInformation!;
      _userNameController.text = personalInfo.userName ?? '';
      _fullNameController.text = personalInfo.fullName ?? '';
      _emailController.text = personalInfo.email ?? '';
      _phoneNumberController.text = personalInfo.phoneNumber ?? '';
      _dateOfBirthController.text = personalInfo.dateOfBirth ?? '';
      _nationalityController.text = personalInfo.nationality ?? '';
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
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
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cập nhật thông tin cá nhân thành công!'),
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
              'Thông tin cá nhân',
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
                'Cập nhật thông tin cá nhân',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.bDarkHover,
                ),
              ),
              SizedBox(height: 16.h),

              _buildTextField(
                controller: _userNameController,
                label: 'Tên người dùng',
                isRequired: true,
              ),
              SizedBox(height: 16.h),

              _buildTextField(
                controller: _fullNameController,
                label: 'Họ và tên đầy đủ',
                isRequired: true,
              ),
              SizedBox(height: 16.h),

              _buildTextField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                isRequired: true,
              ),
              SizedBox(height: 16.h),

              _buildTextField(
                controller: _phoneNumberController,
                label: 'Số điện thoại',
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16.h),

              _buildTextField(
                controller: _dateOfBirthController,
                label: 'Ngày sinh (dd/mm/yyyy)',
                hintText: 'dd/mm/yyyy',
                onTap: () => _selectDate(context),
                readOnly: true,
              ),
              SizedBox(height: 16.h),

              _buildTextField(
                controller: _nationalityController,
                label: 'Quốc tịch',
              ),
              SizedBox(height: 32.h),

              // Update button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updatePersonalInformation,
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
                    _isLoading ? 'Đang cập nhật...' : 'Cập nhật thông tin',
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
    String? hintText,
    VoidCallback? onTap,
    bool readOnly = false,
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
          onTap: onTap,
          readOnly: readOnly,
          validator: isRequired
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '$label không được để trống';
                  }
                  if (keyboardType == TextInputType.emailAddress) {
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Email không hợp lệ';
                    }
                  }
                  return null;
                }
              : null,
          decoration: InputDecoration(
            hintText: hintText,
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
            suffixIcon: readOnly ? const Icon(Icons.calendar_today) : null,
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('vi', 'VN'),
    );

    if (picked != null) {
      setState(() {
        _dateOfBirthController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  void _updatePersonalInformation() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final request = PersonalInformationRequest(
        userName: _userNameController.text.trim(),
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim().isEmpty
            ? null
            : _phoneNumberController.text.trim(),
        dateOfBirth: _dateOfBirthController.text.trim().isEmpty
            ? null
            : _dateOfBirthController.text.trim(),
        nationality: _nationalityController.text.trim().isEmpty
            ? null
            : _nationalityController.text.trim(),
      );

      context.read<SettingCubit>().updatePersonalInformation(request: request);
    }
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
