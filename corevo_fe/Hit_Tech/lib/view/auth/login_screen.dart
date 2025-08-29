import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';
import 'package:hit_tech/core/constants/app_message.dart';
import 'package:hit_tech/core/constants/app_string.dart';
import 'package:hit_tech/model/request/auth/oauth2_google_request.dart';
import 'package:hit_tech/service/user_service.dart';
import 'package:hit_tech/utils/validator_util.dart';
import 'package:hit_tech/view/auth/recovery_account_screen.dart';
import 'package:hit_tech/view/auth/register_screen.dart';
import 'package:hit_tech/view/auth/widgets/recover_account_popup.dart';
import 'package:hit_tech/view/main_root/home_root.dart';
import 'package:hit_tech/service/shared_preferences.dart';
import 'package:hit_tech/view/auth/widgets/auth_custom_button.dart';
import 'package:hit_tech/view/auth/widgets/button_gg_fb_auth.dart';
import 'package:hit_tech/view/auth/widgets/custom_input_field.dart';
import 'package:hit_tech/view/auth/widgets/text_bottom_auth.dart';
import 'package:hit_tech/view/training_flow/training_flow_start_page.dart';
import 'package:hit_tech/view/welcome_screen.dart';

import '../../../core/constants/app_assets.dart';
import '../../../service/auth_service.dart';
import '../../model/request/auth/login_request.dart';
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
    await SharedPreferencesService.clearAll();
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

              showCupertinoDialog(
                context: context,
                builder: (diaLogContext) => RecoverAccountPopUp(
                  onCancel: () {
                    Navigator.of(diaLogContext).pop();
                  },
                  onSave: () {
                    Navigator.of(diaLogContext).pop();
                    Future.microtask(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecoveryAccountScreen(),
                        ),
                      );
                    });
                  },
                  dayRecoveryRemaining: dayRecoveryRemaining ?? 0,
                ),
              );
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
    await SharedPreferencesService.clearAll();

    try {
      await _googleSignIn.signOut();

      final account = await _googleSignIn.signIn();
      final auth = await account?.authentication;

      final idToken = auth?.idToken;

      if (idToken != null) {
        final response = await AuthService.loginWithGoogle(
          Oauth2GoogleRequest(idToken: idToken),
        );
        if (response.status == 'UNAUTHORIZED') {
          if (response.isDeleted ?? true) {
            if (response.canRecovery ?? true) {
              final dayRecoveryRemaining = response.dayRecoveryRemaining;

              showCupertinoDialog(
                context: context,
                builder: (diaLogContext) => RecoverAccountPopUp(
                  onCancel: () {
                    Navigator.of(diaLogContext).pop();
                  },
                  onSave: () {
                    Navigator.of(diaLogContext).pop();
                    Future.microtask(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecoveryAccountScreen(),
                        ),
                      );
                    });
                  },
                  dayRecoveryRemaining: dayRecoveryRemaining ?? 0,
                ),
              );
            } else {
              _showSnackBar(
                UserMessage.errAccountAlreadyDeleted,
                isError: true,
              );
              return;
            }
          }
        } else {
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
        }
      }
    } catch (e) {
      print("Google login failed: $e");
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
    return Scaffold(
      backgroundColor: AppColors.wWhite,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppAssets.authBackground, fit: BoxFit.cover),
          ),
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: AppDimensions.size80),
                  // Header
                  Center(
                    child: Text(
                      AppStrings.login,
                      style: TextStyle(
                        fontSize: AppDimensions.textSizeXXXL,
                        fontWeight: FontWeight.w600,
                        color: AppColors.dark,
                      ),
                    ),
                  ),

                  // Form Content
                  Padding(
                    padding: EdgeInsets.all(AppDimensions.paddingL),
                    child: Column(
                      children: [
                        SizedBox(height: AppDimensions.spacingML),
                        // Username Field
                        CustomInputField(
                          isPassword: true,
                          hintStyle: TextStyle(
                            color: AppColors.lightHover,
                            fontSize: AppDimensions.textSizeM,
                          ),
                          width: AppDimensions.width * 0.9.w,
                          height: AppDimensions.size64,
                          controller: _usernameController,
                          title: AppStrings.username,
                          borderRadius: AppDimensions.borderRadius,
                          borderColor: AppColors.moreLighter,
                          focusedBorderColor: AppColors.bNormal,
                          validator: ValidatorUtil.validateUsername,
                          onChanged: (value) {
                            // Real-time validation if needed
                          },
                        ),

                        SizedBox(height: AppDimensions.spacingM),

                        // Password Field
                        CustomInputField(
                          isPassword: true,
                          hintStyle: TextStyle(
                            color: AppColors.lightHover,
                            fontSize: AppDimensions.textSizeM,
                          ),
                          width: AppDimensions.width * 0.9.w,
                          height: AppDimensions.size64,
                          controller: _passwordController,
                          title: AppStrings.password,
                          borderRadius: AppDimensions.borderRadius,
                          borderColor: AppColors.moreLighter,
                          focusedBorderColor: AppColors.bNormal,
                          obscureText: !_isPasswordVisible,
                          validator: ValidatorUtil.validatePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.moreLighter,
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

                        SizedBox(height: AppDimensions.spacingM),

                        // Remember Me & Forgot Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: AppDimensions.size24,
                                  height: AppDimensions.size24,
                                  child: Checkbox(
                                    checkColor: AppColors.wWhite,
                                    activeColor: AppColors.bNormal,
                                    value: _rememberMe,
                                    onChanged: (v) => setState(
                                      () => _rememberMe = v ?? false,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppDimensions.borderRadiusTiny,
                                      ),
                                    ),
                                    side: BorderSide(
                                      color: AppColors.bNormal,
                                      width: 2.w,
                                    ),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                                SizedBox(width: AppDimensions.spacingS),
                                Text(
                                  'Ghi nhớ đăng nhập',
                                  style: TextStyle(
                                    color: AppColors.lightHover,
                                    fontSize: AppDimensions.textSizeM,
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
                                  fontSize: AppDimensions.textSizeM,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: AppDimensions.spacingXXL),

                        // Login Button
                        AuthCustomButton(
                          text: AppStrings.login,
                          onPressed: _handleLogin,
                        ),

                        SizedBox(height: AppDimensions.spacingXXL),

                        // Divider
                        DividerWithText(text: AppStrings.orLoginWith),

                        SizedBox(height: AppDimensions.spacingXXL),

                        // Social Login Buttons
                        ButtonGgFbAuth(
                          image: Image(image: AssetImage(AppAssets.googleIcon)),
                          width: AppDimensions.width * 0.7.w,
                          text: 'Tiếp tục với Google',
                          onPressed: _handleLoginWithGoogle,
                        ),
                        SizedBox(height: AppDimensions.spacingM),
                        ButtonGgFbAuth(
                          image: Image(
                            image: AssetImage(AppAssets.facebookIcon),
                          ),
                          width: AppDimensions.width * 0.7.w,
                          text: 'Tiếp tục với Facebook',
                          onPressed: () {
                            // Handle Facebook login
                            _handleSocialLogin('facebook');
                          },
                        ),

                        SizedBox(height: AppDimensions.spacingXL),

                        // Register Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.dontHaveAccount,
                              style: TextStyle(
                                color: AppColors.lightHover,
                                fontSize: AppDimensions.textSizeM,
                              ),
                            ),
                            SizedBox(width: 4.w),
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
                                  fontSize: AppDimensions.textSizeM,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppDimensions.spacingXL),
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
