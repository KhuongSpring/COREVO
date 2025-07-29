import 'package:flutter/material.dart';
import 'package:hit_tech/core/constants/app_string.dart';
import 'package:hit_tech/features/auth/models/requests/reset_password_request.dart';
import 'package:hit_tech/features/auth/models/responses/reset_password_response.dart';
import 'package:hit_tech/features/auth/view/login_screen.dart';
import 'package:hit_tech/features/auth/view/widgets/custom_input_field.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/constants/app_message.dart';
import '../service/auth_service.dart';
import '../utils/validator_util.dart';

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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              TrainingAssets.authBackground,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 51),
            child: Column(
              children: [
                const Text(
                  "Quên mật khẩu",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: AppColors.dark,
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 32,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.bNormal,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 16),

                Text(
                  AppStrings.resetYourPassword,
                  style: TextStyle(color: AppColors.dark, fontSize: 16),
                ),

                const SizedBox(height: 40),

                Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Text Field
                        CustomInputField(
                          isPassword: true,
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          width: screenWidth * 0.9,
                          height: 64,
                          controller: _newPassword,
                          title: AppStrings.password,
                          borderRadius: 12,
                          borderColor: Colors.grey[400],
                          focusedBorderColor: AppColors.bNormal,
                          validator: ValidatorUtil.validatePassword,
                          onChanged: (value) {},
                        ),

                        SizedBox(height: 24),

                        // Text Field
                        CustomInputField(
                          isPassword: true,
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          width: screenWidth * 0.9,
                          height: 64,
                          controller: _reEnterNewPassword,
                          title: AppStrings.reEnterPassword,
                          borderRadius: 12,
                          borderColor: Colors.grey[400],
                          focusedBorderColor: AppColors.bNormal,
                          validator: ValidatorUtil.validatePassword,
                          onChanged: (value) {},
                        ),

                        SizedBox(height: 40),

                        // Button
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _handleResetPassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  (_reEnterNewPassword.text.isNotEmpty &&
                                      _newPassword.text.isNotEmpty)
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
