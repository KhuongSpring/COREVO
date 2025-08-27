import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

class RecoveryAccountScreen extends StatefulWidget {
  const RecoveryAccountScreen({super.key});

  @override
  State<RecoveryAccountScreen> createState() => _RecoveryAccountScreenState();
}

class _RecoveryAccountScreenState extends State<RecoveryAccountScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _handleForgot() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      String email = _emailController.text.trim();

      final response = await AuthService.sendEmailToRecoveryAccount(email);

      if (response.status == 'SUCCESS') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              email: email,
              isRegister: false,
              isRecovery: true,
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
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppAssets.authBackground,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 51),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.bNormal,
                          size: 28,
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          SizedBox(height: 5.sp),
                          Text(
                            "Khôi phục tài khoản",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w500,
                              color: AppColors.dark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.sp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 32,
                      height: 6,
                      decoration: BoxDecoration(
                        color: index == 0
                            ? AppColors.bNormal
                            : Colors.grey[400],
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),

                //content
                Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.fillEmailToRecoveryAccount,
                          style: TextStyle(color: AppColors.dark, fontSize: 16),
                        ),

                        SizedBox(height: 40),

                        // Text Field
                        CustomInputField(
                          isPassword: true,
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          width: screenWidth * 0.9,
                          height: 64,
                          controller: _emailController,
                          title: AppStrings.email,
                          borderRadius: 12,
                          borderColor: Colors.grey[400],
                          focusedBorderColor: AppColors.bNormal,
                          validator: ValidatorUtil.validateEmail,
                          onChanged: (value) {},
                        ),

                        SizedBox(height: 40),

                        // Button
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _handleForgot,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  (_emailController.text.isNotEmpty)
                                  ? AppColors.bNormal
                                  : AppColors.lighter,
                              disabledBackgroundColor: Colors.grey[400],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: Text(
                              AppStrings.ok,
                              style: TextStyle(
                                fontSize: 20,
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
