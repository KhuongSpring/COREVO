import 'package:flutter/material.dart';
import 'package:hit_tech/core/constants/app_assets.dart';

import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_dimension.dart';
import '../../../../service/user_service.dart';

class PersonalInforSelectionWidget extends StatefulWidget {
  @override
  State<PersonalInforSelectionWidget> createState() =>
      _PersonalInforSelectionWidgetState();
}

class _PersonalInforSelectionWidgetState
    extends State<PersonalInforSelectionWidget> {
  String? linkAvatar;

  String? username;

  String? firstname;

  String? lastname;

  String? email;

  String? birth;

  String? phoneNumber;

  String? nationality;

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
          birth = response.birth;
          phoneNumber = response.phone;
          nationality = response.nationality;
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
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: linkAvatar?.isNotEmpty ?? false
                                    ? NetworkImage(linkAvatar!)
                                    : const AssetImage(
                                            TrainingAssets.googleIcon,
                                          )
                                          as ImageProvider,
                              ),
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
            'Tên đăng nhập',
            username ?? '',
          ),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildInnerTile(Icons.favorite_border, 'Họ', firstname ?? ''),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildInnerTile(Icons.favorite_border, 'Tên', lastname ?? ''),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildInnerTile(Icons.favorite_border, 'Ngày sinh', birth ?? ''),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildInnerTile(
            Icons.favorite_border,
            'Số điện thoại',
            phoneNumber ?? '',
          ),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildInnerTile(
            Icons.favorite_border,
            'Quốc tịch',
            nationality ?? '',
          ),
        ],
      ),
    );
  }
}
