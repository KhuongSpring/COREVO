import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';
import 'package:hit_tech/core/constants/app_message.dart';
import 'package:hit_tech/core/constants/app_string.dart';
import 'package:hit_tech/features/auth/models/responses/register_response.dart';
import 'package:hit_tech/features/auth/view/widgets/auth_custom_button.dart';
import 'package:hit_tech/features/auth/view/widgets/button_gg_fb_auth.dart';
import 'package:hit_tech/features/auth/view/widgets/custom_input_field.dart';
import 'package:hit_tech/features/auth/view/otp_verification_screen.dart';

import '../../../core/constants/app_assets.dart';
import '../models/requests/register_request.dart';
import '../service/auth_service.dart';
import '../utils/validator_util.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _firstnameController = TextEditingController(); //Tên
  final _lastnameController = TextEditingController(); //Họ
  bool _isPasswordVisible = false;
  bool _agree = false;
  bool isLoading = false;

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
      backgroundColor: AppColors.wLight,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  TrainingAssets.authBackground,
                  fit: BoxFit.cover,
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),

                    // Header
                    Container(
                      width: screenWidth,
                      height: 83,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          AppStrings.register,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: AppColors.dark,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: AppDimensions.spaceXL),
                          _buildFormFields(),
                          const SizedBox(height: AppDimensions.spaceM),
                          _buildAgreeRow(),
                          const SizedBox(height: AppDimensions.spaceXL),
                          _buildRegisterButton(),
                          const SizedBox(height: 40),
                          _buildDivider(),
                          const SizedBox(height: AppDimensions.spaceM),
                          _buildSocialButtons(),
                          const SizedBox(height: AppDimensions.spaceXXL),
                          _buildLogInLink(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomInputField(
            isPassword: true,
            width: screenWidth * 0.9,
            controller: _emailController,
            title: AppStrings.email,
            focusedBorderColor: AppColors.bNormal,
            keyboardType: TextInputType.emailAddress,
            validator: ValidatorUtil.validateEmail,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          CustomInputField(
            isPassword: true,
            width: screenWidth * 0.9,
            controller: _usernameController,
            title: AppStrings.username,
            focusedBorderColor: AppColors.bNormal,
            validator: ValidatorUtil.validateUsername,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomInputField(
                isPassword: true,
                controller: _firstnameController,
                title: AppStrings.firstName,
                focusedBorderColor: AppColors.bNormal,
                width: screenWidth * 0.52,
                validator: ValidatorUtil.validateFirstName,
              ),
              const SizedBox(width: AppDimensions.spaceM),
              CustomInputField(
                isPassword: true,
                controller: _lastnameController,
                title: AppStrings.lastName,
                focusedBorderColor: AppColors.bNormal,
                width: screenWidth * 0.33,
                validator: ValidatorUtil.validateLastName,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceM),
          CustomInputField(
            isPassword: true,
            width: screenWidth * 0.9,
            focusedBorderColor: AppColors.bNormal,
            controller: _passwordController,
            title: AppStrings.password,
            obscureText: !_isPasswordVisible,
            validator: ValidatorUtil.validatePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey[600],
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            onChanged: (value) {
              // Real-time validation if needed
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAgreeRow() {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: screenWidth,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              checkColor: Colors.white,
              activeColor: AppColors.bNormal,
              value: _agree,
              onChanged: (v) => setState(() => _agree = v ?? false),
              // activeColor: AppColors.primaryAppColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              side: BorderSide(color: AppColors.bNormal, width: 2),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 14,
                  ),
                  children: [
                    const TextSpan(text: 'Tôi đồng ý với '),
                    TextSpan(
                      text: 'Chính sách',
                      style: const TextStyle(color: Color(0xFF0D5BFF)),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // TODO: mở link chính sách
                        },
                    ),
                    const TextSpan(text: ' và '),
                    TextSpan(
                      text: 'Điều khoản sử dụng',
                      style: const TextStyle(color: Color(0xFF0D5BFF)),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // TODO: mở link điều khoản
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return AuthCustomButton(
      text: isLoading ? 'Đang đăng ký...' : AppStrings.register,
      onPressed: isLoading ? null : _handleRegister,
      isLoading: isLoading,
    );
  }

  Widget _buildDivider() {
    return const Row(
      children: [
        Expanded(child: Divider(color: AppColors.bNormal)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.spaceS),
          child: Text(
            AppStrings.orRegisterWith,
            style: TextStyle(
              color: AppColors.bNormal,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.bNormal)),
      ],
    );
  }

  Widget _buildSocialButtons() {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ButtonGgFbAuth(
          onPressed: _handleGoogleRegister,
          image: Image(image: AssetImage(TrainingAssets.googleIcon)),
          text: 'Google',
          width: screenWidth * 0.4,
        ),
        ButtonGgFbAuth(
          onPressed: _handleFacebookRegister,
          image: Image(image: AssetImage(TrainingAssets.facebookIcon)),
          text: 'Facebook',
          width: screenWidth * 0.4,
        ),
      ],
    );
  }

  Widget _buildLogInLink() {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        ),
        child: const Text.rich(
          TextSpan(
            text: 'Đã có tài khoản? ',
            style: TextStyle(color: Colors.black, fontSize: 16),
            children: [
              TextSpan(
                text: AppStrings.login,
                style: TextStyle(
                  color: AppColors.bNormal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agree) {
      _showSnackBar(
        'Vui lòng đồng ý với các điều khoản và chính sách',
        isError: true,
      );
      return;
    }

    FocusScope.of(context).unfocus();

    final request = RegisterRequest(
      username: _usernameController.text.trim(),
      password: _passwordController.text,
      firstName: _firstnameController.text.trim(),
      lastName: _lastnameController.text.trim(),
      email: _emailController.text.trim(),
    );
    try {
      final RegisterResponse response = await AuthService.register(request);

      if (response.status == 'SUCCESS') {
        _showSnackBar(response.data ?? '', isError: false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OtpVerificationScreen(email: request.email, isRegister: true),
          ),
        );
      } else {
        _showSnackBar(response.data ?? '', isError: true);
      }
    } catch (e) {
      _showSnackBar(AuthMessage.errRegisterFail, isError: false);
    }
  }

  void _handleGoogleRegister() {
    // TODO dang phat trien
  }

  void _handleFacebookRegister() {
    // TODO dang phat trien
  }
}
