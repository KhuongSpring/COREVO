import 'package:flutter/material.dart';

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
                    TrainingAssets.mainBackground,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(height: 50),

                    // Header + Avatar
                    SizedBox(
                      height: 110,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 20,
                            top: 0,
                            bottom: 70,
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
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: linkAvatar?.isNotEmpty ?? false
                                  ? NetworkImage(linkAvatar!)
                                  : const AssetImage(TrainingAssets.googleIcon)
                                        as ImageProvider,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          '${firstname ?? ''} ${lastname ?? ''}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.normal,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          email ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.lightActive,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Các mục
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
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
      title: Text(title, style: TextStyle(fontSize: 14)),
      trailing: Text(
        text,
        style: TextStyle(
          color: AppColors.bNormal,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {},
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
          _buildInnerTile(
            Icons.person_outline,
            'Chiều cao',
            '${height ?? ''} cm',
          ),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildInnerTile(
            Icons.favorite_border,
            'Cân nặng',
            '${weight ?? ''} kg',
          ),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildInnerTile(Icons.favorite_border, 'Tuổi', '${age ?? ''}'),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildInnerTile(
            Icons.favorite_border,
            'Giới tính',
            (gender! == "MALE") ? 'Nam' : 'Nữ',
          ),
          const Divider(height: 1, color: AppColors.bLightHover),
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
