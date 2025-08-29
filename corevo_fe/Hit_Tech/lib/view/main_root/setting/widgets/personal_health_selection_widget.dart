import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_dimension.dart';
import '../../../../service/user_service.dart';

class PersonalHealthSelectionWidget extends StatefulWidget {
  @override
  State<PersonalHealthSelectionWidget> createState() =>
      _PersonalHealthSelectionWidgetState();
}

class _PersonalHealthSelectionWidgetState
    extends State<PersonalHealthSelectionWidget> {
  String? linkAvatar;

  String? username;

  String? firstname;

  String? lastname;

  String? email;

  String? gender;

  int? height;

  int? weight;

  int? age;

  String? activityLevel;

  double? basalMetabolicRate;

  int? maximumHeartRate;

  double? tdee;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _handleGetProfile();
  }

  Future<void> _handleGetProfile() async {
    try {
      final response = await UserService.getProfile();

      if (response.status == 'SUCCESS') {
        setState(() {
          linkAvatar = response.linkAvatar;
          username = response.username;
          firstname = response.firstName;
          lastname = response.lastName;
          email = response.email;

          final userHealth = response.userHealth;
          if (userHealth != null) {
            gender = userHealth.gender;
            height = userHealth.height;
            weight = userHealth.weight;
            age = userHealth.age;
            activityLevel = userHealth.activityLevel;
            basalMetabolicRate = userHealth.basalMetabolicRate;
            maximumHeartRate = userHealth.maximumHeartRate;
            tdee = userHealth.tdee;
          }

          _isLoading = false;
        });
        return;
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bLight,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    AppAssets.mainBackground,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: AppDimensions.spacingXXXL),

                    // Header + Avatar
                    SizedBox(
                      height: AppDimensions.size104,
                      child: Stack(
                        children: [
                          Positioned(
                            left: AppDimensions.spacingML,
                            top: 0.w,
                            bottom: AppDimensions.size72,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.arrow_back_ios),
                              color: AppColors.bNormal,
                            ),
                          ),

                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.bNormal,
                                  width: 2.w,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: AppDimensions.size40,
                                backgroundImage: linkAvatar?.isNotEmpty ?? false
                                    ? NetworkImage(linkAvatar!)
                                    : NetworkImage(AppAssets.defaultImage),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          '${firstname ?? ''} ${lastname ?? ''}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppDimensions.textSizeM,
                            color: AppColors.normal,
                          ),
                        ),
                        SizedBox(height: AppDimensions.size4),
                        Text(
                          email ?? '',
                          style: TextStyle(
                            fontSize: AppDimensions.textSizeXS,
                            color: AppColors.lightActive,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: AppDimensions.spacingXXL),

                    // Các mục
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingL,
                        ),
                        children: [_buildProfileSection()],
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  // Build Inner tile
  Widget _buildInnerTile(IconData icon, String title, String text) {
    return ListTile(
      title: Text(title, style: TextStyle(fontSize: AppDimensions.textSizeS)),
      trailing: Text(
        text,
        style: TextStyle(
          color: AppColors.bNormal,
          fontSize: AppDimensions.textSizeS,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {},
    );
  }

  Widget _buildProfileSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.wWhite,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Column(
        children: [
          _buildInnerTile(
            Icons.person_outline,
            'Chiều cao',
            '${height ?? ''} cm',
          ),
          Divider(height: 1.w, color: AppColors.bLightHover),
          _buildInnerTile(
            Icons.favorite_border,
            'Cân nặng',
            '${weight ?? ''} kg',
          ),
          Divider(height: 1.w, color: AppColors.bLightHover),
          _buildInnerTile(Icons.favorite_border, 'Tuổi', '${age ?? ''}'),
          Divider(height: 1.w, color: AppColors.bLightHover),
          _buildInnerTile(
            Icons.favorite_border,
            'Giới tính',
            (gender! == "MALE") ? 'Nam' : 'Nữ',
          ),
          Divider(height: 1.w, color: AppColors.bLightHover),
          _buildInnerTile(
            Icons.favorite_border,
            'Mức độ hoạt động',
            (activityLevel! == 'SEDENTARY')
                ? 'Ít vận động'
                : (activityLevel! == 'LIGHTLY_ACTIVE')
                ? 'Hoạt động nhẹ'
                : (activityLevel! == 'MODERATELY_ACTIVE')
                ? 'Hoạt động vừa phải'
                : (activityLevel! == 'VERY_ACTIVE')
                ? 'Hoạt động nhiều'
                : 'Rất năng động',
          ),
        ],
      ),
    );
  }
}
