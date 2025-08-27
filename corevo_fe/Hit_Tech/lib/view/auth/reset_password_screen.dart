import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';
import 'package:hit_tech/core/constants/app_string.dart';
import 'package:hit_tech/view/auth/widgets/custom_input_field.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/constants/app_message.dart';
import '../../../service/auth_service.dart';
import '../../../utils/validator_util.dart';
import '../../model/request/auth/reset_password_request.dart';
import '../../model/response/auth/reset_password_response.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _reEnterNewPassword = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      final request = ResetPasswordRequest(
        email: widget.email,
        newPassword: _newPassword.text,
        reEnterPassword: _reEnterNewPassword.text,
      );
      final ResetPasswordResponse response = await AuthService.resetPassword(
        request,
      );

      if (response.status == 'SUCCESS') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        _showSnackBar(
          AppStrings.generalError,
          isError: true,
        );
      }
    } catch (e) {
      _showSnackBar(HttpMessage.errServer, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.wWhite,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppAssets.authBackground,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingL, vertical: AppDimensions.paddingXXXL),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.bNormal,
                        size: AppDimensions.iconSizeXXL,
                      ),
                    ),
                    SizedBox(width: AppDimensions.spacingXL),
                    Text(
                      "Quên mật khẩu",
                      style: TextStyle(
                        fontSize: AppDimensions.textSizeXXXL,
                        fontWeight: FontWeight.w500,
                        color: AppColors.dark,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppDimensions.spacingSM),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: AppDimensions.paddingXS),
                      width: AppDimensions.size32,
                      height: AppDimensions.size8,
                      decoration: BoxDecoration(
                        color: AppColors.bNormal,
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
                      ),
                    );
                  }),
                ),

                SizedBox(height: AppDimensions.spacingM),

                Text(
                  AppStrings.resetYourPassword,
                  style: TextStyle(color: AppColors.dark, fontSize: AppDimensions.textSizeM),
                ),

                SizedBox(height: AppDimensions.spacingXXL),

                Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Text Field
                        CustomInputField(
                          isPassword: true,
                          hintStyle: TextStyle(
                            color: AppColors.lighter,
                            fontSize: AppDimensions.textSizeM,
                          ),
                          width: AppDimensions.width * 0.9.w,
                          height: AppDimensions.size64,
                          controller: _newPassword,
                          title: AppStrings.password,
                          borderRadius: AppDimensions.borderRadius,
                          borderColor: AppColors.moreLighter,
                          focusedBorderColor: AppColors.bNormal,
                          validator: ValidatorUtil.validatePassword,
                          onChanged: (value) {},
                        ),

                        SizedBox(height: AppDimensions.size24),

                        // Text Field
                        CustomInputField(
                          isPassword: true,
                          hintStyle: TextStyle(
                            color: AppColors.lighter,
                            fontSize: AppDimensions.textSizeM,
                          ),
                          width: AppDimensions.width * 0.9.w,
                          height: AppDimensions.size64,
                          controller: _reEnterNewPassword,
                          title: AppStrings.reEnterPassword,
                          borderRadius: AppDimensions.borderRadius,
                          borderColor: AppColors.moreLighter,
                          focusedBorderColor: AppColors.bNormal,
                          validator: ValidatorUtil.validatePassword,
                          onChanged: (value) {},
                        ),

                        SizedBox(height: AppDimensions.spacingXXL),

                        // Button
                        SizedBox(
                          width: AppDimensions.width * 0.9.w,
                          height: AppDimensions.size48,
                          child: ElevatedButton(
                            onPressed: _handleResetPassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  (_reEnterNewPassword.text.isNotEmpty &&
                                      _newPassword.text.isNotEmpty)
                                  ? AppColors.bNormal
                                  : AppColors.lighter,
                              disabledBackgroundColor: AppColors.moreLighter,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
                              ),
                            ),
                            child: Text(
                              AppStrings.ok,
                              style: TextStyle(
                                fontSize: AppDimensions.textSizeL,
                                fontWeight: FontWeight.bold,
                                color:
                                    (_reEnterNewPassword.text.isNotEmpty &&
                                        _newPassword.text.isNotEmpty)
                                    ? AppColors.wWhite
                                    : AppColors.moreLighter,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
