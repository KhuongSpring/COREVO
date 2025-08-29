import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_assets.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';
import 'package:hit_tech/service/shared_preferences.dart';
import 'package:hit_tech/view/auth/login_screen.dart';
import 'package:hit_tech/view/main_root/home_root.dart';
import 'package:hit_tech/view/on_boarding/splash_on_boarding.dart';
import 'package:hit_tech/view/training_flow/training_flow_start_page.dart';
import 'package:hit_tech/view/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/user_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 3));

    final isLoggedIn = await SharedPreferencesService.isLoggedIn();
    final prefs = await SharedPreferences.getInstance();
    final seenOnBoarding = prefs.getBool('seenOnboarding') ?? false;

    setState(() {
      _isChecking = false;
    });

    // delay
    await Future.delayed(Duration(milliseconds: 100));

    if (!seenOnBoarding) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SplashOnboarding()),
      );
      return;
    }

    if (isLoggedIn) {
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
              MaterialPageRoute(builder: (context) => TrainingFlowStartPage()),
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
      } on DioException catch (e) {
        if (e.response?.statusCode == 401) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } else {
          print('Lỗi khác: ${e.response?.data}');
        }
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bDarkerLogo,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: AppDimensions.size40,
                  height: AppDimensions.size40,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppAssets.logoCorevo),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: AppDimensions.spacingSM),
                Text(
                  'Corevo',
                  style: TextStyle(
                    color: AppColors.wWhite,
                    fontSize: AppDimensions.textSizeXXXL,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDimensions.spacingXXXL),
            if (_isChecking)
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.wWhite),
              ),
          ],
        ),
      ),
    );
  }
}
