import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';
import 'package:hit_tech/model/response/training/training_plan_response.dart';
import 'package:hit_tech/model/response/training/training_progress_statistic_response.dart';
import 'package:hit_tech/model/response/training/training_schedule_response.dart';
import 'package:hit_tech/model/response/user/user_profile_response.dart';
import 'package:hit_tech/utils/mapping_training_resource_helper.dart';
import 'package:hit_tech/view/main_root/home/widget/calendar_widget.dart';
import 'package:hit_tech/view/main_root/setting/widgets/notice_training_selection_widget.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_assets.dart';
import '../../../service/training_service.dart';
import '../../../utils/change_notifier.dart';

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

  final bool _isHaveNotice = false;

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

    final String linkAvatar =
        widget.userProfileResponse.linkAvatar ?? AppAssets.defaultImage;
    final String fullName =
        '${widget.userProfileResponse.firstName ?? ''} ${widget.userProfileResponse.lastName ?? ''}';
    final TrainingPlanResponse? trainingPlanResponse =
        widget.userProfileResponse.trainingPlans?.first;

    int weekDay = DateTime.now().weekday;

    String day = MappingTrainingResourceHelper.getThuTiengViet(weekDay);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppAssets.mainBackground, fit: BoxFit.cover),
          ),
          SafeArea(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingL,
                vertical: AppDimensions.paddingM,
              ),
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
                                  color: AppColors.bNormal,
                                  width: 2.w,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: AppDimensions.borderRadiusLarge,
                                backgroundImage: linkAvatar.isNotEmpty
                                    ? NetworkImage(linkAvatar)
                                    : const AssetImage(AppAssets.googleIcon)
                                          as ImageProvider,
                              ),
                            ),
                            SizedBox(width: AppDimensions.spacingSM),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Xin chào!',
                                  style: TextStyle(
                                    fontSize: AppDimensions.textSizeS,
                                    color: AppColors.dark,
                                  ),
                                ),
                                Text(
                                  fullName,
                                  style: TextStyle(
                                    fontSize: AppDimensions.textSizeM,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.dark,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: AppDimensions.size48,
                        width: AppDimensions.size48,
                        decoration: BoxDecoration(
                          color: AppColors.wWhite,
                          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
                        ),
                        child: Image.asset(AppAssets.notificationIcon),
                      ),
                    ],
                  ),

                  SizedBox(height: AppDimensions.spacingL),

                  // Card
                  GestureDetector(
                    onTap: widget.onNavigateToTraining,
                    child: Container(
                      padding: EdgeInsets.all(AppDimensions.paddingM),
                      decoration: BoxDecoration(
                        color: AppColors.bNormal,
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
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
                                    style: TextStyle(
                                      color: AppColors.wWhite,
                                      fontSize: AppDimensions.textSizeL,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: AppDimensions.size4),
                                  Text(
                                    '${day}  •  ${schedules[weekDay - 1].exerciseGroups?.exercises.length} bài tập',
                                    style: TextStyle(
                                      color: AppColors.wWhite,
                                      fontSize: AppDimensions.textSizeXS,
                                    ),
                                  ),
                                ],
                              ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    height: AppDimensions.size48,
                                    width: AppDimensions.size48,
                                    child: CircularProgressIndicator(
                                      value: percentage / 100,
                                      strokeWidth: 5.w,
                                      backgroundColor: Colors.white24,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.wWhite,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${percentage / 100 * 100}%',
                                    style: TextStyle(
                                      color: AppColors.wWhite,
                                      fontSize: AppDimensions.textSizeXS,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: AppDimensions.spacingSM),
                          Text(
                            schedules[weekDay - 1].description,
                            style: TextStyle(color: AppColors.wWhite),
                          ),
                          SizedBox(height: AppDimensions.spacingM),
                          ElevatedButton(
                            onPressed: widget.onNavigateToTraining,
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(AppDimensions.width * 0.9.w, AppDimensions.size40),
                              backgroundColor: AppColors.wWhite,
                              foregroundColor: AppColors.bNormal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
                              ),
                            ),
                            child: Text(
                              'Luyện Tập',
                              style: TextStyle(
                                color: AppColors.bNormal,
                                fontSize: AppDimensions.textSizeS,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: AppDimensions.spacingSM),

                  // Calendar placeholder
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.wWhite,
                      borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
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

                  SizedBox(height: AppDimensions.spacingSM),

                  // Streak + giờ tiếp theo
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(AppDimensions.paddingM),
                          decoration: BoxDecoration(
                            color: AppColors.bNormal,
                            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
                          ),
                          width: AppDimensions.width * 0.75.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Chuỗi ${progressStatistic?.currentStreak} ngày',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: AppDimensions.textSizeM,
                                    ),
                                  ),
                                  SizedBox(height: AppDimensions.size4),
                                  Text(
                                    'Kỉ lục dài nhất của bạn: ${progressStatistic?.longestStreak}',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: AppDimensions.textSizeXS,
                                    ),
                                  ),
                                ],
                              ),
                              Image.asset(
                                (progressStatistic?.currentStreak == 0)
                                    ? AppAssets.fireNonIcon
                                    : AppAssets.fireIcon,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: AppDimensions.spacingML),
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
                          padding: EdgeInsets.all(AppDimensions.paddingS),
                          decoration: BoxDecoration(
                            color: AppColors.bNormal,
                            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
                          ),
                          width: AppDimensions.width * 0.25.w,
                          child: Column(
                            children: [
                              _isHaveNotice
                                  ? Text(
                                      'Tiếp theo',
                                      style: TextStyle(
                                        color: AppColors.wWhite,
                                        fontSize: AppDimensions.textSizeXS,
                                      ),
                                    )
                                  : Icon(
                                      Icons.alarm,
                                      color: AppColors.wWhite,
                                      size: AppDimensions.iconSizeXXXL,
                                    ),
                              SizedBox(height: AppDimensions.spacingS),
                              _isHaveNotice
                                  ? Text(
                                      '-- : --',
                                      style: TextStyle(
                                        fontSize: AppDimensions.textSizeL,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : Text(
                                      'Tạo lời nhắc',
                                      style: TextStyle(
                                        fontSize: AppDimensions.textSizeXS,
                                        color: AppColors.wWhite,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppDimensions.size104),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
