import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hit_tech/features/auth/view/forgot_password_screen.dart';
import 'package:hit_tech/features/auth/view/reset_password_screen.dart';

import 'package:hit_tech/features/auth/view/splash_page.dart';
import 'package:hit_tech/features/auth/view/login_screen.dart';
import 'package:hit_tech/features/auth/view/register_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/features/auth/view/otp_verification_screen.dart';
import 'package:hit_tech/features/health_infor/view/health_info_page.dart';
import 'package:hit_tech/features/health_infor/view/widgets/gender_selection_widget.dart';
import 'package:hit_tech/features/home/view/home_screen.dart';
import 'package:hit_tech/features/training_flow/view/widget/training_equipment_selection_widget.dart';
import 'package:hit_tech/features/training_flow/view/widget/training_frequency_selection_widget.dart';
import 'package:hit_tech/features/training_flow/view/widget/training_location_selection_widget.dart';
import 'package:hit_tech/features/training_flow/view/widget/training_type_selection_widget.dart';

import 'features/health_infor/cubit/blocs/health_bloc.dart';
import 'features/health_infor/cubit/data/repository/health_infor_repo.dart';
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
        return MultiBlocProvider(
          providers: [
            BlocProvider<HealthInfoBloc>(
              create: (context) => HealthInfoBloc(HealthInforRepo(Dio())),
              child: HealthInfoPage(),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Auth App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              primaryColor: const Color(0xFF2454F8),
              fontFamily: 'Roboto',
              textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
            ),
            home: LoginScreen(),
            routes: {
              // '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/home': (context) => HomeScreen(),
              // '/forgot-password': (context) => const ForgotPasswordScreen(),
              '/splash': (context) => const SplashScreen(),
              '/homeRoot': (context) => HomeRoot(),
              // '/trainingGoalSelection': (context) =>
              //     TrainingGoalSelectionWidget(),
              // '/trainingTypeSelection': (context) =>
              //     TrainingTypeSelectionWidget(),
              // '/trainingDurationSelection': (context) =>
              // TrainingDurationSelectionWidget(),
              // '/trainingFrequencySelection': (context) =>
              //     TrainingFrequencySelectionWidget(),
              // '/trainingEquipmentSelection': (context) =>
              //     TrainingEquipmentSelectionWidget(),
              // '/trainingLocationSelection': (context) =>
              //     TrainingLocationSelectionWidget(),
              // '/trainingLevelSelection': (context) =>
              //     TrainingLevelSelectionWidget(),
              '/trainingExercise': (context) => TrainingExercise(),
            },
          ),
        );
      },
    );
  }
}
