import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/model/response/training/training_plan_response.dart';
import 'package:hit_tech/model/response/training/training_progress_statistic_response.dart';
import 'package:hit_tech/model/response/training/training_schedule_response.dart';
import 'package:hit_tech/model/response/user/user_profile_response.dart';
import 'package:hit_tech/service/shared_preferences.dart';
import 'package:hit_tech/utils/mapping_training_resource_helper.dart';
import 'package:hit_tech/view/auth/login_screen.dart';
import 'package:hit_tech/view/main_root/home/widget/calendar_widget.dart';
import 'package:hit_tech/view/main_root/setting/widgets/notice_training_creation_widget.dart';
import 'package:hit_tech/view/main_root/setting/widgets/notice_training_selection_widget.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_assets.dart';
import '../../../service/training_service.dart';
import '../../../utils/change_notifier.dart';

// Loi UI: percentage make screen extend height
class HomeScreen extends StatefulWidget {
  final UserProfileResponse userProfileResponse;
  final List<TrainingScheduleResponse> schedules;
  final VoidCallback? onNavigateToSetting;
  final VoidCallback? onNavigateToTraining;

  const HomeScreen({
    super.key,
    required this.userProfileResponse,
    this.onNavigateToSetting,
    required this.schedules,
    this.onNavigateToTraining,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double percentage = 0.0;
  TrainingProgressStatisticResponse? progressStatistic;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    try {
      await Future.wait([
        _handleTrainingDailyProgress(),
        _handleGetProgressStatistic(),
      ]);
    } catch (e) {
      print("Error during init: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleTrainingDailyProgress() async {
    try {
      final response = await TrainingService.getDailyProgress();

      if (response.status == 'SUCCESS') {
        setState(() {
          percentage = response.data['percentage'];
        });
        return;
      }
    } catch (e, stackTrace) {
      print(stackTrace);
    }
  }

  Future<void> _handleGetProgressStatistic() async {
    try {
      final response = await TrainingService.getStatistic(
        DateTime.now().year,
        DateTime.now().month,
      );

      if (response.status == 'SUCCESS') {
        setState(() {
          progressStatistic = TrainingProgressStatisticResponse.fromJson(
            response.data,
          );
        });
        return;
      }
    } catch (e, stackTrace) {
      print(stackTrace);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final notifier = Provider.of<TrainingProgressNotifier>(context);
    if (notifier.needRefresh) {
      _handleTrainingDailyProgress();
      _handleGetProgressStatistic();
      notifier.resetRefreshFlag();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    List<TrainingScheduleResponse> schedules = widget.schedules;

    final String? linkAvatar =
        widget.userProfileResponse.linkAvatar ?? TrainingAssets.defaultImage;
    final String? fullName =
        '${widget.userProfileResponse.firstName ?? ''} ${widget.userProfileResponse.lastName ?? ''}';
    final TrainingPlanResponse? trainingPlanResponse =
        widget.userProfileResponse.trainingPlans?.first;

    int weekDay = DateTime.now().weekday;

    String day = MappingTrainingResourceHelper.getThuTiengViet(weekDay);

    final double screenWidth = MediaQuery.of(context).size.width.sp;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              TrainingAssets.mainBackground,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Avatar + tên + icon chuông
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: widget.onNavigateToSetting,
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 25.sp,
                                backgroundImage: linkAvatar!.isNotEmpty
                                    ? NetworkImage(linkAvatar)
                                    : const AssetImage(
                                            TrainingAssets.googleIcon,
                                          )
                                          as ImageProvider,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Xin chào!',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  fullName!,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 45.sp,
                        width: 45.sp,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Image.asset(TrainingAssets.notificationIcon),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Card
                  GestureDetector(
                    onTap: widget.onNavigateToTraining,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.bNormal,
                        borderRadius: BorderRadius.circular(20.sp),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    MappingTrainingResourceHelper.mappingGoalToVietnamese(
                                      trainingPlanResponse!.goals,
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${day}  •  ${schedules[weekDay - 1].exerciseGroups?.exercises.length} bài tập',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: CircularProgressIndicator(
                                      value: percentage / 100,
                                      strokeWidth: 5,
                                      backgroundColor: Colors.white24,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${percentage / 100 * 100}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            schedules[weekDay - 1].description,
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: widget.onNavigateToTraining,
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(screenWidth * 0.9, 40),
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF0094FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Luyện Tập',
                              style: TextStyle(
                                color: AppColors.bNormal,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10.sp),

                  // Calendar placeholder
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IgnorePointer(
                      ignoring: true,
                      child: CalendarWidget(
                        schedules: schedules,
                        currentMonthCompletions:
                            progressStatistic!.currentMonthCompletions,
                      ),
                    ),
                  ),

                  SizedBox(height: 10.sp),

                  // Streak + giờ tiếp theo
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.bNormal,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: screenWidth * 0.75,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${progressStatistic?.currentStreak} Ngày Streak',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Kỉ lục dài nhất của bạn: ${progressStatistic?.longestStreak}',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Image.asset(
                                (progressStatistic?.currentStreak == 0)
                                    ? TrainingAssets.fireNonIcon
                                    : TrainingAssets.fireIcon,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NoticeTrainingSelectionWidget(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.bNormal,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          width: screenWidth * 0.25,
                          child: Column(
                            children: const [
                              Text(
                                'Tiếp theo',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '-- : --',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 100.sp),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
