import 'package:flutter/material.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/view/main_root/home/home_screen.dart';
import 'package:hit_tech/service/shared_preferences.dart';
import 'package:hit_tech/view/auth/login_screen.dart';
import 'package:hit_tech/view/main_root/home_root.dart';
import 'package:hit_tech/view/training_flow/training_flow_start_page.dart';
import 'package:hit_tech/view/welcome_screen.dart';

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

    setState(() {
      _isChecking = false;
    });

    // delay
    await Future.delayed(Duration(milliseconds: 100));

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
      } catch (e, stackTrace) {
        print(stackTrace);
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
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/icons/logo_corevo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Corevo',
                  style: TextStyle(
                    color: AppColors.wLight,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            if (_isChecking)
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}
