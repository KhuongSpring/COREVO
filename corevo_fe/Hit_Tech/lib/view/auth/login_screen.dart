import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hit_tech/core/constants/api_endpoint.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/core/constants/app_message.dart';
import 'package:hit_tech/core/constants/app_string.dart';
import 'package:hit_tech/model/request/auth/oauth2_google_request.dart';
import 'package:hit_tech/service/user_service.dart';
import 'package:hit_tech/utils/validator_util.dart';
import 'package:hit_tech/view/auth/register_screen.dart';
import 'package:hit_tech/view/main_root/home/home_screen.dart';
import 'package:hit_tech/view/main_root/home_root.dart';
import 'package:hit_tech/service/shared_preferences.dart';
import 'package:hit_tech/view/auth/widgets/auth_custom_button.dart';
import 'package:hit_tech/view/auth/widgets/button_gg_fb_auth.dart';
import 'package:hit_tech/view/auth/widgets/custom_input_field.dart';
import 'package:hit_tech/view/auth/widgets/text_bottom_auth.dart';
import 'package:hit_tech/view/personal_health/widget/gender_selection_widget.dart';
import 'package:hit_tech/view/training_flow/training_flow_start_page.dart';
import 'package:hit_tech/view/welcome_screen.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_assets.dart';
import '../../../service/auth_service.dart';
import '../../model/request/auth/login_request.dart';
import '../training_flow/widget/training_goal_selection_widget.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        '42141829092-b08uu2gskgp6tks7q92k6ap5g5gdh0k9.apps.googleusercontent.com',
  );

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() async {
    // Load saved username if remember me was checked
    // You can implement this based on your SharedPreferences setup
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        final request = LoginRequest(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        );

        final response = await AuthService.login(request);
        final status = response.status;
        final isDeleted = response.isDeleted;
        final canRecovery = response.canRecovery;

        if (status == 'OK') {
          await SharedPreferencesService.saveAccessToken(
            response.accessToken ?? '',
          );
          await SharedPreferencesService.saveRefreshToken(
            response.refreshToken ?? '',
          );
          await SharedPreferencesService.saveUserData(response.userId ?? '');

          print(await SharedPreferencesService.getAccessToken());

          try {
            final subResponse = await UserService.getProfile();

            if (subResponse.status == "SUCCESS") {
              if (subResponse.userHealth == null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                );
                return;
              }

              if (subResponse.trainingPlans == null ||
                  subResponse.trainingPlans!.isEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrainingFlowStartPage(),
                  ),
                );
                return;
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeRoot(user: subResponse),
                ),
              );
            }
          } catch (e, stackTrace) {
            print(stackTrace);
          }
        } else {
          if (isDeleted ?? true) {
            if (canRecovery ?? true) {
              final dayRecoveryRemaining = response.dayRecoveryRemaining;
            } else {
              _showSnackBar(
                UserMessage.errAccountAlreadyDeleted,
                isError: true,
              );
              return;
            }
          }
        }
      } catch (e) {
        _showSnackBar(AuthMessage.errLoginFail, isError: true);
      }
    }
  }

  Future<void> _handleLoginWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      final auth = await account?.authentication;

      final idToken = auth?.idToken;
      if (idToken != null) {
        final response = await AuthService.loginWithGoogle(
          Oauth2GoogleRequest(idToken: idToken),
        );
        if (response.status == 'OK') {
          await SharedPreferencesService.saveAccessToken(
            response.accessToken ?? '',
          );
          await SharedPreferencesService.saveRefreshToken(
            response.refreshToken ?? '',
          );
          await SharedPreferencesService.saveUserData(response.userId ?? '');

          print(await SharedPreferencesService.getAccessToken());

          try {
            final subResponse = await UserService.getProfile();

            if (subResponse.status == "SUCCESS") {
              if (subResponse.userHealth == null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                );

                return;
              }

              if (subResponse.trainingPlans == null ||
                  subResponse.trainingPlans!.isEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrainingFlowStartPage(),
                  ),
                );

                return;
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeRoot(user: subResponse),
                ),
              );
            }
          } catch (e, stackTrace) {
            print(stackTrace);
          }
        } else {
          if (response.isDeleted ?? true) {
            if (response.canRecovery ?? true) {
              final dayRecoveryRemaining = response.dayRecoveryRemaining;
            } else {
              _showSnackBar(
                UserMessage.errAccountAlreadyDeleted,
                isError: true,
              );
              return;
            }
          }
        }
      }
    } catch (e) {
      print("❌ Google login failed: $e");
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
              TrainingAssets.authBackground,
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 30),
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
                        AppStrings.login,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: AppColors.dark,
                        ),
                      ),
                    ),
                  ),

                  // Form Content
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 22),

                        // Username Field
                        CustomInputField(
                          isPassword: true,
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          width: screenWidth * 0.9,
                          height: 64,
                          controller: _usernameController,
                          title: AppStrings.username,
                          borderRadius: 12,
                          borderColor: Colors.grey[400],
                          focusedBorderColor: AppColors.bNormal,
                          validator: ValidatorUtil.validateUsername,
                          onChanged: (value) {
                            // Real-time validation if needed
                          },
                        ),

                        const SizedBox(height: 24),

                        // Password Field
                        CustomInputField(
                          isPassword: true,
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          width: screenWidth * 0.9,
                          height: 64,
                          controller: _passwordController,
                          title: AppStrings.password,
                          borderRadius: 12,
                          borderColor: Colors.grey[400],
                          focusedBorderColor: AppColors.bNormal,
                          obscureText: !_isPasswordVisible,
                          validator: ValidatorUtil.validatePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
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

                        const SizedBox(height: 16),

                        // Remember Me & Forgot Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 18,
                                  height: 18,
                                  child: Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: AppColors.bNormal,
                                    value: _rememberMe,
                                    onChanged: (v) => setState(
                                      () => _rememberMe = v ?? false,
                                    ),
                                    // activeColor: AppColors.primaryAppColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    side: BorderSide(
                                      color: AppColors.bNormal,
                                      width: 2,
                                    ),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Ghi nhớ đăng nhập',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigate to forgot password screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                AppStrings.forgotPassword,
                                style: TextStyle(
                                  color: AppColors.bNormal,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        // Login Button
                        AuthCustomButton(
                          text: AppStrings.login,
                          onPressed: _handleLogin,
                        ),

                        const SizedBox(height: 40),

                        // Divider
                        DividerWithText(text: AppStrings.orLoginWith),

                        const SizedBox(height: 24),

                        // Social Login Buttons
                        ButtonGgFbAuth(
                          image: Image(
                            image: AssetImage(TrainingAssets.googleIcon),
                          ),
                          width: screenWidth * .9,
                          text: 'Tiếp tục với Google',
                          onPressed: _handleLoginWithGoogle,
                        ),
                        const SizedBox(height: 18),
                        ButtonGgFbAuth(
                          image: Image(
                            image: AssetImage(TrainingAssets.facebookIcon),
                          ),
                          width: screenWidth * .9,
                          text: 'Tiếp tục với acebook',
                          onPressed: () {
                            // Handle Facebook login
                            _handleSocialLogin('facebook');
                          },
                        ),

                        const SizedBox(height: 140),

                        // Register Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.dontHaveAccount,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                AppStrings.register,
                                style: TextStyle(
                                  color: AppColors.bNormal,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 31),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSocialLogin(String provider) {
    // Implement social login logic here
    _showSnackBar('Chức năng đăng nhập bằng $provider đang được phát triển');
  }
}
