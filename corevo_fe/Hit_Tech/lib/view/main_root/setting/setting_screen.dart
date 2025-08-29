import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_assets.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';
import 'package:hit_tech/model/response/user/user_profile_response.dart';
import 'package:hit_tech/view/main_root/setting/widgets/notice_training_selection_widget.dart';
import 'package:hit_tech/view/main_root/setting/widgets/personal_health_selection_widget.dart';
import 'package:hit_tech/view/main_root/setting/widgets/personal_infor_selection_widget.dart';
import 'package:hit_tech/view/main_root/setting/widgets/privacy_and_terms_screen.dart';
import 'package:hit_tech/view/main_root/setting/widgets/remove_screen.dart';
import 'package:image_picker/image_picker.dart';

import '../../../service/auth_service.dart';
import '../../../service/shared_preferences.dart';
import '../../../service/user_service.dart';
import '../../auth/login_screen.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late UserProfileResponse userProfileResponse;

  String? linkAvatar;

  String? username;

  String? firstname;

  String? lastname;

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
          setState(() {
            userProfileResponse = response;
          });
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

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 75,
      maxWidth: 800.w,
      maxHeight: 800.w,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      try {
        final response = await UserService.uploadAvatar(file);

        setState(() {
          linkAvatar = response?.linkAvatar;
          userProfileResponse.linkAvatar = response?.linkAvatar;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  void _handleLogout() async {
    await SharedPreferencesService.logout();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Future<String> getPrivacyAndTerms() async {
    String res = "";
    try {
      final response = await AuthService.getPrivacy();

      if (response.status == 'SUCCESS') {
        res += response.data['content'];
      }
    } catch (e) {
      print(e);
    }

    try {
      final response = await AuthService.getTerms();

      if (response.status == 'SUCCESS') {
        res += response.data['content'];
      }
    } catch (e) {
      print(e);
    }

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bLight,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Ảnh nền
                Positioned.fill(
                  child: Image.asset(
                    AppAssets.mainBackground,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: AppDimensions.spacingGiant),
                    // Header + Avatar
                    Column(
                      children: [
                        Stack(
                          children: [
                            // Avatar với viền xanh
                            Container(
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
                                    : const NetworkImage(
                                        AppAssets.defaultImage,
                                      ),
                              ),
                            ),

                            // Nút máy ảnh ở góc dưới phải
                            Positioned(
                              bottom: 0.w,
                              right: 0.w,
                              child: GestureDetector(
                                onTap: () {
                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (BuildContext context) => Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: AppDimensions.paddingS,
                                      ),
                                      child: CupertinoActionSheet(
                                        actions: <CupertinoActionSheetAction>[
                                          CupertinoActionSheetAction(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              _pickImage(ImageSource.camera);
                                            },
                                            child: Text(
                                              'Chụp ảnh',
                                              style: TextStyle(
                                                fontSize:
                                                    AppDimensions.textSizeM,
                                                color: AppColors.bNormal,
                                              ),
                                            ),
                                          ),
                                          CupertinoActionSheetAction(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              _pickImage(ImageSource.gallery);
                                            },
                                            child: Text(
                                              'Chọn ảnh từ Album',
                                              style: TextStyle(
                                                fontSize:
                                                    AppDimensions.textSizeM,
                                                color: AppColors.bNormal,
                                              ),
                                            ),
                                          ),
                                        ],
                                        cancelButton:
                                            CupertinoActionSheetAction(
                                              isDefaultAction: true,
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'Hủy bỏ',
                                                style: TextStyle(
                                                  fontSize:
                                                      AppDimensions.textSizeM,
                                                  color: AppColors.bNormal,
                                                ),
                                              ),
                                            ),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(
                                    AppDimensions.paddingXS,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.wWhite,
                                    border: Border.all(
                                      color: AppColors.bNormal,
                                      width: 1.5.w,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: AppDimensions.iconSizeM,
                                    color: AppColors.dark,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: AppDimensions.spacingS),
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
                          username ?? '',
                          style: TextStyle(
                            fontSize: AppDimensions.textSizeS,
                            color: AppColors.lightActive,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: AppDimensions.spacingS),

                    // Các mục
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingL,
                        ),
                        children: [
                          _buildSectionTitle('Hồ sơ người dùng'),
                          _buildProfileSection(),

                          _buildSectionTitle('Cài đặt chung'),
                          _buildOverallSettingsSection(),

                          _buildSectionTitle('Thông tin hỗ trợ'),
                          _buildSettingsSection(),

                          SizedBox(height: AppDimensions.spacingML),

                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.wWhite,
                              borderRadius: BorderRadius.circular(
                                AppDimensions.borderRadius,
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                _handleLogout();
                              },
                              // style: ,
                              child: Text(
                                'Đăng Xuất',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: AppDimensions.textSizeM,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  // Build title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.bDarkHover,
          fontSize: AppDimensions.textSizeS,
        ),
      ),
    );
  }

  // Build Inner tile
  Widget _buildInnerTile(String icon, String title, VoidCallback ontap) {
    return ListTile(
      leading: Image.asset(icon, color: AppColors.bDarkHover),
      title: Text(title, style: TextStyle(fontSize: AppDimensions.textSizeS)),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: AppDimensions.iconSizeM,
        color: AppColors.bDarkHover,
      ),
      onTap: ontap,
    );
  }

  // Title 1
  Widget _buildProfileSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.wWhite,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Column(
        children: [
          _buildInnerTile(
            AppAssets.personalInformationIcon,
            'Thông tin cá nhân',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PersonalInforSelectionWidget(
                    userProfile: userProfileResponse,
                    onReload: _handleGetProfile,
                  ),
                ),
              );
            },
          ),
          _buildInnerTile(
            AppAssets.healthInformationIcon,
            'Thông tin sức khỏe',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PersonalHealthSelectionWidget(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Title 2
  _buildOverallSettingsSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.wWhite,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.only(
              left: AppDimensions.paddingM,
              right: AppDimensions.paddingXS,
            ),
            leading: Image.asset(
              AppAssets.themeIcon,
              color: AppColors.bDarkHover,
            ),
            title: Text(
              "Chế độ tối",
              style: TextStyle(fontSize: AppDimensions.textSizeS),
            ),
            trailing: Transform.scale(
              scale: 0.7,
              child: Switch(
                value: false,
                onChanged: (value) {},
                activeTrackColor: AppColors.bNormal,
                activeColor: AppColors.wWhite,
                inactiveTrackColor: AppColors.moreLighter,
                inactiveThumbColor: AppColors.wWhite,
              ),
            ),
            onTap: () {},
          ),
          _buildInnerTile(AppAssets.noticeIcon, 'Nhắc nhở luyện tập', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NoticeTrainingSelectionWidget(),
              ),
            );
          }),
          _buildInnerTile(AppAssets.trashIcon, 'Xóa dữ liệu người dùng', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => RemoveScreen()),
            );
          }),
        ],
      ),
    );
  }

  // Title 3
  _buildSettingsSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.wWhite,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Column(
        children: [
          _buildInnerTile(AppAssets.commentIcon, 'Đánh giá', () {}),
          _buildInnerTile(
            AppAssets.policyIcon,
            'Chính sách và điều khoản',
            () async {
              String res = await getPrivacyAndTerms();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PrivacyAndTermsScreen(privacyAndTerms: res),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
