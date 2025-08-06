import 'package:flutter/material.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/model/response/training/training_schedule_response.dart';
import 'package:hit_tech/model/response/user/user_profile_response.dart';
import 'package:hit_tech/view/main_root/custom_bottom_nav_bar.dart';
import 'package:hit_tech/view/main_root/feeds/feeds_screen.dart';
import 'package:hit_tech/view/main_root/home/home_screen.dart';
import 'package:hit_tech/view/main_root/setting/setting_screen.dart';
import 'package:hit_tech/view/main_root/training/training_screen.dart';
import 'package:hit_tech/view/main_root/training_library/view/training_library_screen.dart';

import '../../service/training_service.dart';

class HomeRoot extends StatefulWidget {
  final UserProfileResponse user;

  const HomeRoot({super.key, required this.user});

  @override
  _HomeRootState createState() => _HomeRootState();
}

class _HomeRootState extends State<HomeRoot> {
  int _selectedIndex = 0;
  List<TrainingScheduleResponse> schedules = [];
  bool _isLoading = true;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _handleGetTrainingSchedule() async {
    try {
      final response = await TrainingService.getTrainingScheduleById(
        widget.user.trainingPlans!.first.id,
      );

      if (response.status == 'SUCCESS') {
        setState(() {
          schedules = response.days;
          _isLoading = false;
        });

        print(schedules.length);

        return;
      }
    } catch (e, stackTrace) {
      print(stackTrace);
    }
  }

  @override
  void initState() {
    super.initState();
    _handleGetTrainingSchedule();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      HomeScreen(
        userProfileResponse: widget.user,
        onNavigateToSetting: () {
          setState(() {
            _selectedIndex = 4;
          });
        },
        onNavigateToTraining: (){
          setState(() {
            _selectedIndex = 2;
          });
        },
        schedules: schedules,
      ),
      TrainingLibraryScreen(),
      TrainingScreen(
        userProfileResponse: widget.user,
        schedules: schedules,
        key: _selectedIndex == 2 ? UniqueKey() : null,
      ),
      FeedsScreen(),
      SettingScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.bLight,
      body: Stack(
        children: [
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : IndexedStack(index: _selectedIndex, children: _screens),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: CustomBottomNavBar(
                currentIndex: _selectedIndex,
                onTap: _onTabTapped,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
