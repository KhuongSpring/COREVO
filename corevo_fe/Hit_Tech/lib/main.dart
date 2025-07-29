import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/features/home/view/home_screen.dart';
import 'package:hit_tech/features/training_flow/view/widget/training_equipment_selection_widget.dart';
import 'package:hit_tech/features/training_flow/view/widget/training_frequency_selection_widget.dart';
import 'package:hit_tech/features/training_flow/view/widget/training_location_selection_widget.dart';
import 'package:hit_tech/features/training_flow/view/widget/training_type_selection_widget.dart';
import 'package:hit_tech/view/auth/login_screen.dart';
import 'package:hit_tech/view/splash_screen.dart';
import 'package:hit_tech/view/personal_health/activity_level_selection_screen.dart';
import 'package:hit_tech/view/personal_health/age_selection_screen.dart';
import 'package:hit_tech/view/personal_health/gender_selection_screen.dart';
import 'package:hit_tech/view/personal_health/height_selection_screen.dart';
import 'package:hit_tech/view/personal_health/weight_selection_screen.dart';

import 'features/main_root/home_root.dart';
import 'features/main_root/training_library/view/training_exercise.dart';
import 'features/training_flow/view/widget/training_duration_selection_widget.dart';
import 'features/training_flow/view/widget/training_goal_selection_widget.dart';
import 'features/training_flow/view/widget/training_level_selection_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 917),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Auth App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: const Color(0xFF2454F8),
            fontFamily: 'Roboto',
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}
