import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hit_tech/core/constants/app_assets.dart';
import 'package:hit_tech/model/response/user/user_profile_response.dart';
import 'package:hit_tech/view/main_root/setting/widgets/update_profile_popup.dart';

import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_dimension.dart';
import '../../../../service/user_service.dart';

class PersonalInforSelectionWidget extends StatefulWidget {
  final UserProfileResponse userProfile;
  final Future<void> Function() onReload;

  const PersonalInforSelectionWidget({
    super.key,
    required this.userProfile,
    required this.onReload,
  });

  @override
  State<PersonalInforSelectionWidget> createState() =>
      _PersonalInforSelectionWidgetState();
}

class _PersonalInforSelectionWidgetState
    extends State<PersonalInforSelectionWidget> {
  TextEditingController _controller = TextEditingController();

  late UserProfileResponse _userProfile;

  @override
  void initState() {
    super.initState();
    _userProfile = widget.userProfile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bLight,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppAssets.mainBackground,
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
                          border: Border.all(color: Colors.blue, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              _userProfile.linkAvatar?.isNotEmpty ?? false
                              ? NetworkImage(_userProfile.linkAvatar!)
                              : NetworkImage(AppAssets.defaultImage),
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
                    '${_userProfile.firstName ?? ''} ${_userProfile.lastName ?? ''}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.normal,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    _userProfile.email ?? '',
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
      onTap: (title != 'Tên đăng nhập')
          ? () => _showUsernamePopup(context, (title))
          : () {},
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
            _userProfile.username ?? '?',
          ),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildInnerTile(
            Icons.favorite_border,
            'Họ',
            _userProfile.firstName ?? '?',
          ),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildInnerTile(
            Icons.favorite_border,
            'Tên',
            _userProfile.lastName ?? '?',
          ),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildInnerTile(
            Icons.favorite_border,
            'Ngày sinh',
            _userProfile.birth ?? '?',
          ),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildInnerTile(
            Icons.favorite_border,
            'Số điện thoại',
            _userProfile.phone ?? '?',
          ),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildInnerTile(
            Icons.favorite_border,
            'Quốc tịch',
            _userProfile.nationality ?? '?',
          ),
        ],
      ),
    );
  }

  void _showUsernamePopup(BuildContext context, String label) {
    _controller.clear();
    showCupertinoDialog(
      context: context,
      builder: (context) => UpdateProfilePopUp(
        controller: _controller,
        onCancel: () => Navigator.of(context).pop(),
        onSave: () async {
          final type = mappingField(label);
          if (type == 'phone') {
            final phone = _controller.text.trim();

            if (!isValidVietnamPhone(phone)) {
              _showSnackBar('Số điện thoại không hợp lệ', isError: true);
              return;
            }
          }

          final Map<String, dynamic> requestBody = {
            "password": 'GoogleLogin123@',
            "profileData": {
              "personalInformation": {
                "firstName": (type == 'firstname')
                    ? _controller.text.trim()
                    : _userProfile.firstName,
                "lastName": (type == 'lastname')
                    ? _controller.text.trim()
                    : _userProfile.lastName,
                "phone": (type == 'phone')
                    ? _controller.text.trim()
                    : _userProfile.phone,
                "birth": (type == 'birth')
                    ? _controller.text.trim()
                    : _userProfile.birth,
                "nationality": (type == 'nationality')
                    ? _controller.text.trim()
                    : _userProfile.nationality,
                "address": {"province": '', "district": ''},
              },
              "health": {
                "gender": _userProfile.userHealth?.gender,
                "height": _userProfile.userHealth?.height,
                "weight": _userProfile.userHealth?.weight,
                "age": _userProfile.userHealth!.age,
                "activityLevel": _userProfile.userHealth?.activityLevel,
              },
            },
          };
          try {
            final response = await UserService.updatePersonalInformation(
              requestBody,
            );

            if (response.status == 'SUCCESS') {
              setState(() {
                _userProfile = response;
              });
              await widget.onReload();
              Navigator.pop(context);
            }
          } catch (e) {
            print('Lỗi update: $e');
          }
        },
        type: label,
      ),
    );
  }

  String mappingField(String title) {
    const mapping = {
      'Tên đăng nhập': 'username',
      'Họ': 'firstname',
      'Tên': 'lastname',
      'Ngày sinh': 'birth',
      'Số điện thoại': 'phone',
      'Quốc tịch': 'nationality',
    };
    return mapping[title] ?? title;
  }

  bool isValidVietnamPhone(String phone) {
    phone = phone.trim();

    if (phone.startsWith('+84')) {
      phone = '0${phone.substring(3)}';
    }

    final regex = RegExp(r'^(03|05|07|08|09)\d{8}$');

    return regex.hasMatch(phone);
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
