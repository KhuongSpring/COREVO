import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';
import 'package:hit_tech/core/constants/app_string.dart';
import 'package:hit_tech/model/request/auth/forgot_password_request.dart';
import 'package:hit_tech/model/response/auth/forgot_password_response.dart';
import 'package:hit_tech/view/auth/widgets/custom_input_field.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/constants/app_message.dart';
import '../../../service/auth_service.dart';
import '../../../utils/validator_util.dart';
import 'otp_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _handleForgot() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      final request = ForgotPasswordRequest(
        email: _emailController.text.trim(),
      );
      final ForgotPasswordResponse response =
          await AuthService.sendEmailToForgotPassword(request);

      if (response.status == 'SUCCESS') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              email: request.email,
              isRegister: false,
              isRecovery: false,
            ),
          ),
        );
      } else {
        _showSnackBar(
          response.data ?? UserMessage.errEmailNotExist,
          isError: true,
        );
      }
    } catch (e) {
      _showSnackBar(UserMessage.errEmailNotExist, isError: false);
    }
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

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.wWhite,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppAssets.authBackground, fit: BoxFit.cover),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingL,
              vertical: AppDimensions.paddingXXXL,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        size: AppDimensions.textSizeXXL,
                      ),
                    ),
                    SizedBox(width: AppDimensions.size32),
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
                      margin: EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingXS,
                      ),
                      width: AppDimensions.size32,
                      height: AppDimensions.size8,
                      decoration: BoxDecoration(
                        color: index == 0
                            ? AppColors.bNormal
                            : AppColors.lighter,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.borderRadiusLarge,
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: AppDimensions.size16),

                //content
                Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.fillEmailToResetPassword,
                          style: TextStyle(
                            color: AppColors.dark,
                            fontSize: AppDimensions.textSizeM,
                          ),
                        ),

                        SizedBox(height: AppDimensions.size40),

                        // Text Field
                        CustomInputField(
                          isPassword: true,
                          hintStyle: TextStyle(
                            color: AppColors.lighter,
                            fontSize: AppDimensions.textSizeM,
                          ),
                          width: AppDimensions.width * 0.9.w,
                          height: AppDimensions.size64,
                          controller: _emailController,
                          title: AppStrings.email,
                          borderRadius: AppDimensions.borderRadius,
                          borderColor: AppColors.lighter,
                          focusedBorderColor: AppColors.bNormal,
                          validator: ValidatorUtil.validateEmail,
                          onChanged: (value) {},
                        ),

                        SizedBox(height: AppDimensions.size40),

                        // Button
                        SizedBox(
                          width: AppDimensions.width * 0.9.w,
                          height: AppDimensions.size48,
                          child: ElevatedButton(
                            onPressed: _handleForgot,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  (_emailController.text.isNotEmpty)
                                  ? AppColors.bNormal
                                  : AppColors.lighter,
                              disabledBackgroundColor: AppColors.lighter,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadiusLarge,
                                ),
                              ),
                            ),
                            child: Text(
                              AppStrings.ok,
                              style: TextStyle(
                                fontSize: AppDimensions.textSizeL,
                                fontWeight: FontWeight.bold,
                                color: (_emailController.text.isNotEmpty)
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
