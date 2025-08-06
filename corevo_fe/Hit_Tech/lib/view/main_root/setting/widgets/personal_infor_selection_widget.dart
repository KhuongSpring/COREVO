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

  const PersonalInforSelectionWidget({super.key, required this.userProfile});

  @override
  State<PersonalInforSelectionWidget> createState() =>
      _PersonalInforSelectionWidgetState();
}

class _PersonalInforSelectionWidgetState
    extends State<PersonalInforSelectionWidget> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bLight,
      body: Stack(
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
                          backgroundImage: widget.userProfile.linkAvatar
                              ?.isNotEmpty ?? false
                              ? NetworkImage(widget.userProfile.linkAvatar!)
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
                    '${widget.userProfile.firstName ?? ''} ${widget.userProfile.lastName ?? ''}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.normal,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.userProfile.email ?? '',
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
            widget.userProfile.username ?? '?',
          ),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildInnerTile(Icons.favorite_border, 'Họ', widget.userProfile.firstName ?? '?'),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildInnerTile(Icons.favorite_border, 'Tên', widget.userProfile.lastName ?? '?'),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildInnerTile(Icons.favorite_border, 'Ngày sinh', widget.userProfile.birth ?? '?'),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildInnerTile(
            Icons.favorite_border,
            'Số điện thoại',
            widget.userProfile.phone ?? '?',
          ),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildInnerTile(
            Icons.favorite_border,
            'Quốc tịch',
            widget.userProfile.nationality ?? '?',
          ),
        ],
      ),
    );
  }

  void _showUsernamePopup(BuildContext context, String label) {
    _controller.clear();
    showCupertinoDialog(
      context: context,
      builder: (context) =>
          UpdateProfilePopUp(
            controller: _controller,
            onCancel: () => Navigator.of(context).pop(),
            onSave: () {
              final type = mappingField(label);
              final Map<String, dynamic> requestBody = {
                "password": 'GoogleLogin123@',
                "profileData": {
                  "personalInformation": {
                    "firstName": (type == 'firstname') ? _controller.text.trim() : widget.userProfile.firstName,
                    "lastName": (type == 'lastname') ? _controller.text.trim() : widget.userProfile.lastName,
                    "phone": (type == 'phone') ? _controller.text.trim() : widget.userProfile.phone,
                    "birth": widget.userProfile.birth,
                    "nationality": widget.userProfile.nationality,
                    "address": {
                      "province": '',
                      "district": ''
                    }
                  },
                  "health": {
                    "gender": widget.userProfile.userHealth?.gender,
                    "height": widget.userProfile.userHealth?.height,
                    "weight": widget.userProfile.userHealth?.weight,
                    "age": widget.userProfile.userHealth?.age,
                    "activityLevel": widget.userProfile.userHealth?.activityLevel
                  }
                }
              };


              Navigator.of(context).pop();
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
}
