import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hit_tech/utils/change_notifier.dart';
import 'package:provider/provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/view/main_root/home/home_screen.dart';
import 'package:hit_tech/view/auth/login_screen.dart';
import 'package:hit_tech/view/splash_screen.dart';
import 'package:hit_tech/view/personal_health/widget/activity_level_selection_widget.dart';
import 'package:hit_tech/view/personal_health/widget/age_selection_widget.dart';
import 'package:hit_tech/view/personal_health/widget/gender_selection_widget.dart';
import 'package:hit_tech/view/personal_health/widget/height_selection_widget.dart';
import 'package:hit_tech/view/personal_health/widget/weight_selection_widget.dart';
import 'package:hit_tech/view/training_flow/training_flow_start_page.dart';
import 'package:hit_tech/view/training_flow/widget/training_goal_selection_widget.dart';
import 'package:hit_tech/view/welcome_screen.dart';

import 'view/main_root/home_root.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TrainingProgressNotifier()),
      ],
      child: MyApp(),
    ),
  );
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
