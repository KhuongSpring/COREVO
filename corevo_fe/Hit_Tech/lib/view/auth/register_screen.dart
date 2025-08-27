import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';
import 'package:hit_tech/core/constants/app_message.dart';
import 'package:hit_tech/core/constants/app_string.dart';
import 'package:hit_tech/view/auth/widgets/auth_custom_button.dart';
import 'package:hit_tech/view/auth/widgets/button_gg_fb_auth.dart';
import 'package:hit_tech/view/auth/widgets/custom_input_field.dart';
import 'package:hit_tech/view/auth/widgets/recover_account_popup.dart';
import 'package:hit_tech/view/main_root/setting/widgets/privacy_and_terms_screen.dart';

import '../../../core/constants/app_assets.dart';
import '../../../service/auth_service.dart';
import '../../../utils/validator_util.dart';
import '../../model/request/auth/oauth2_google_request.dart';
import '../../model/request/auth/register_request.dart';
import '../../model/response/auth/register_response.dart';
import '../../service/shared_preferences.dart';
import '../../service/user_service.dart';
import '../main_root/home_root.dart';
import '../training_flow/training_flow_start_page.dart';
import '../welcome_screen.dart';
import 'login_screen.dart';
import 'otp_verification_screen.dart';

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
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _agree = false;
  bool isLoading = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        '42141829092-b08uu2gskgp6tks7q92k6ap5g5gdh0k9.apps.googleusercontent.com',
  );

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 3),
      ),
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

  Future<void> _handleLoginWithGoogle() async {
    if (!_agree) {
      _showSnackBar(
        'Vui lòng đồng ý với các điều khoản và chính sách',
        isError: true,
      );
      return;
    }

    await SharedPreferencesService.clearAll();
    try {
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
                builder: (context) => RecoverAccountPopUp(
                  onCancel: () => Navigator.of(context).pop(),
                  onSave: () {},
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.wLight,
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(AppAssets.authBackground, fit: BoxFit.cover),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: AppDimensions.size80),
                  // Header
                  Center(
                    child: Text(
                      AppStrings.register,
                      style: TextStyle(
                        fontSize: AppDimensions.textSizeXXXL,
                        fontWeight: FontWeight.w600,
                        color: AppColors.dark,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingM,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: AppDimensions.spacingXL),
                        _buildFormFields(),
                        SizedBox(height: AppDimensions.spacingM),
                        _buildAgreeRow(),
                        SizedBox(height: AppDimensions.spacingXXL),
                        _buildRegisterButton(),
                        SizedBox(height: AppDimensions.spacingXXL),
                        _buildDivider(),
                        SizedBox(height: AppDimensions.spacingML),
                        _buildSocialButtons(),
                        SizedBox(height: AppDimensions.spacingXL),
                        _buildLogInLink(),
                        SizedBox(height: AppDimensions.spacingML),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomInputField(
            isPassword: true,
            width: AppDimensions.width * 0.9.w,
            controller: _emailController,
            title: AppStrings.email,
            focusedBorderColor: AppColors.bNormal,
            keyboardType: TextInputType.emailAddress,
            validator: ValidatorUtil.validateEmail,
          ),
          SizedBox(height: AppDimensions.spacingML),
          CustomInputField(
            isPassword: true,
            width: AppDimensions.width * 0.9.w,
            controller: _usernameController,
            title: AppStrings.username,
            focusedBorderColor: AppColors.bNormal,
            validator: ValidatorUtil.validateUsername,
          ),
          SizedBox(height: AppDimensions.spacingML),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomInputField(
                isPassword: true,
                controller: _firstnameController,
                title: AppStrings.firstName,
                focusedBorderColor: AppColors.bNormal,
                width: AppDimensions.width * 0.52.w,
                validator: ValidatorUtil.validateFirstName,
              ),
              SizedBox(width: AppDimensions.spacingML),
              CustomInputField(
                isPassword: true,
                controller: _lastnameController,
                title: AppStrings.lastName,
                focusedBorderColor: AppColors.bNormal,
                width: AppDimensions.width * 0.33.w,
                validator: ValidatorUtil.validateLastName,
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacingML),
          CustomInputField(
            isPassword: true,
            width: AppDimensions.width * 0.9.w,
            focusedBorderColor: AppColors.bNormal,
            controller: _passwordController,
            title: AppStrings.password,
            obscureText: !_isPasswordVisible,
            validator: ValidatorUtil.validatePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
        ],
      ),
    );
  }

  Widget _buildAgreeRow() {
    return Center(
      child: SizedBox(
        width: AppDimensions.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              checkColor: AppColors.wWhite,
              activeColor: AppColors.bNormal,
              value: _agree,
              onChanged: (v) => setState(() => _agree = v ?? false),
              // activeColor: AppColors.primaryAppColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusTiny,
                ),
              ),
              side: BorderSide(color: AppColors.bNormal, width: 2.w),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: AppColors.dark,
                    fontSize: AppDimensions.textSizeS,
                  ),
                  children: [
                    TextSpan(
                      text: 'Tôi đồng ý với ',
                      style: TextStyle(fontSize: AppDimensions.textSizeS),
                    ),
                    TextSpan(
                      text: 'Chính sách',
                      style: TextStyle(
                        color: AppColors.bNormal,
                        fontSize: AppDimensions.textSizeS,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
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
                    TextSpan(
                      text: ' và ',
                      style: TextStyle(fontSize: AppDimensions.textSizeS),
                    ),
                    TextSpan(
                      text: 'Điều khoản sử dụng',
                      style: TextStyle(
                        color: AppColors.bNormal,
                        fontSize: AppDimensions.textSizeS,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
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
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.bNormal)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
          child: Text(
            AppStrings.orRegisterWith,
            style: TextStyle(
              color: AppColors.bNormal,
              fontSize: AppDimensions.textSizeM,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.bNormal)),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ButtonGgFbAuth(
          onPressed: _handleLoginWithGoogle,
          image: Image(image: AssetImage(AppAssets.googleIcon)),
          text: 'Google',
          width: AppDimensions.width * 0.4.w,
        ),
        ButtonGgFbAuth(
          onPressed: _handleFacebookRegister,
          image: Image(image: AssetImage(AppAssets.facebookIcon)),
          text: 'Facebook',
          width: AppDimensions.width * 0.4.w,
        ),
      ],
    );
  }

  Widget _buildLogInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.alreadyHaveAccount,
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
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          child: Text(
            AppStrings.login,
            style: TextStyle(
              color: AppColors.bNormal,
              fontSize: AppDimensions.textSizeM,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
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
            builder: (context) => OtpVerificationScreen(
              email: request.email,
              isRegister: true,
              isRecovery: false,
            ),
          ),
        );
      } else {
        _showSnackBar(response.data ?? '', isError: true);
      }
    } catch (e, stackStrace) {
      print(stackStrace);
      _showSnackBar(AuthMessage.errRegisterFail, isError: false);
    }
  }

  void _handleFacebookRegister() {
    // TODO dang phat trien
  }
}
