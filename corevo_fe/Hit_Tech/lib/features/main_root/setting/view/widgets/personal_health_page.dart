import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_assets.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';

import '../../cubit/setting_cubit.dart';
import '../../cubit/setting_state.dart';

class PersonalHealthPage extends StatefulWidget {
  const PersonalHealthPage({super.key});

  @override
  State<PersonalHealthPage> createState() => _PersonalHealthPageState();
}

class _PersonalHealthPageState extends State<PersonalHealthPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _ageController;

  String? _selectedGender;
  String? _selectedActivityLevel;

  final List<String> _genders = ['Nam', 'Nữ', 'Khác'];
  final List<String> _activityLevels = [
    'Ít vận động',
    'Vận động nhẹ',
    'Vận động vừa',
    'Vận động nhiều',
    'Vận động rất nhiều',
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    _ageController = TextEditingController();
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bLight,
      body: BlocConsumer<SettingCubit, SettingState>(
        listener: (context, state) {
          if (state is SettingProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cập nhật thông tin sức khỏe thành công!'),
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
                          _buildHealthSection(),
                          SizedBox(height: 20.h),
                          _buildSaveButton(state),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (state is SettingProfileUpdating) _buildLoadingOverlay(),
            ],
          );
        },
      ),
    );
  }

  void _populateFields(SettingLoaded state) {
    final healthInfo = state.userProfile.healthInformation;
    if (healthInfo != null) {
      _heightController.text = healthInfo.height?.toString() ?? '';
      _weightController.text = healthInfo.weight?.toString() ?? '';
      _ageController.text = healthInfo.age?.toString() ?? '';
      _selectedGender = healthInfo.gender;
      _selectedActivityLevel = healthInfo.activityLevel;
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

  Widget _buildHealthSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Column(
        children: [
          _buildNumberField('Chiều cao (cm)', _heightController),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildNumberField('Cân nặng (kg)', _weightController),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildNumberField('Tuổi', _ageController),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildDropdownField('Giới tính', _selectedGender, _genders, (value) {
            setState(() {
              _selectedGender = value;
            });
          }),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildDropdownField(
            'Mức độ hoạt động',
            _selectedActivityLevel,
            _activityLevels,
            (value) {
              setState(() {
                _selectedActivityLevel = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNumberField(String title, TextEditingController controller) {
    return ListTile(
      title: Text(title, style: TextStyle(fontSize: 14.sp)),
      subtitle: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: TextStyle(color: AppColors.bNormal, fontSize: 14.sp),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Nhập $title',
          hintStyle: TextStyle(color: AppColors.lightActive, fontSize: 14.sp),
        ),
        validator: (value) {
          if (value != null && value.isNotEmpty) {
            final number = double.tryParse(value);
            if (number == null || number <= 0) {
              return 'Vui lòng nhập số hợp lệ';
            }
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownField(
    String title,
    String? selectedValue,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return ListTile(
      title: Text(title, style: TextStyle(fontSize: 14.sp)),
      subtitle: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Chọn $title',
          hintStyle: TextStyle(color: AppColors.lightActive, fontSize: 14.sp),
        ),
        style: TextStyle(color: AppColors.bNormal, fontSize: 14.sp),
        items: options.map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSaveButton(SettingState state) {
    final isLoading = state is SettingProfileUpdating;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ElevatedButton(
        onPressed: isLoading ? null : _saveHealthInformation,
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

  void _saveHealthInformation() {
    if (_formKey.currentState?.validate() ?? false) {
      final height = double.tryParse(_heightController.text.trim());
      final weight = double.tryParse(_weightController.text.trim());
      final age = int.tryParse(_ageController.text.trim());

      context.read<SettingCubit>().updateHealthInformation(
        gender: _selectedGender,
        height: height,
        weight: weight,
        age: age,
        activityLevel: _selectedActivityLevel,
      );
    }
  }
}
