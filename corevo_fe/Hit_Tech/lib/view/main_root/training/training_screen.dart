import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';
import 'package:hit_tech/utils/mapping_training_resource_helper.dart';
import 'package:hit_tech/utils/training_day_image_data.dart';
import 'package:hit_tech/view/main_root/training/training_day_detail_screen.dart';
import 'package:hit_tech/view/main_root/training/widget/weekly_time_line.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_color.dart';
import '../../../model/response/training/training_progress_statistic_response.dart';
import '../../../model/response/training/training_schedule_response.dart';
import '../../../model/response/user/user_profile_response.dart';
import '../../../service/training_service.dart';

class TrainingScreen extends StatefulWidget {
  final UserProfileResponse userProfileResponse;
  final List<TrainingScheduleResponse> schedules;

  const TrainingScreen({
    super.key,
    required this.userProfileResponse,
    required this.schedules,
  });

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  List<DateTime> getWeekDates(DateTime selectedDate) {
    int weekday = selectedDate.weekday;
    DateTime monday = selectedDate.subtract(Duration(days: weekday - 1));
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  final int selectedDay = DateTime.now().weekday - 1;

  int selectedIndex = 0;

  int selectedIndex2 = 0;

  TrainingProgressStatisticResponse? progressStatistic;

  bool _isLoading = true;

  @override
  void initState() {
    _handleGetProgressStatistic();
    setState(() {
      selectedIndex2 = DateTime.now().weekday - 1;
    });
    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
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
  Widget build(BuildContext context) {
    final UserProfileResponse user = widget.userProfileResponse;
    final List<TrainingScheduleResponse> schedules = widget.schedules;
    final List<DateTime> days = getWeekDates(DateTime.now());

    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    List<String> trainingDayImage = TrainingDayImageData.getListImage(
      user.trainingPlans!.first.name,
      user.trainingPlans!.first.goals,
    );

    List<String> trainingDayShapeImage = TrainingDayImageData.getListShape(
      user.trainingPlans!.first.name,
      user.trainingPlans!.first.goals,
    );

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppAssets.mainBackground, fit: BoxFit.cover),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingM,
                vertical: AppDimensions.spacingSM,
              ),
              child: ListView(
                children: [
                  SizedBox(height: AppDimensions.spacingML),
                  // Medal selector row
                  Container(
                    height: AppDimensions.size104,
                    decoration: BoxDecoration(
                      color: AppColors.wWhite,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadius,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingSM,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(days.length, (index) {
                        int status;
                        if (index < selectedDay &&
                            progressStatistic!
                                .currentMonthCompletions[days[index].day - 1]) {
                          status = 1;
                        } else if (index < selectedDay &&
                            !progressStatistic!
                                .currentMonthCompletions[days[index].day - 1]) {
                          status = 3;
                        } else if (index == selectedDay &&
                            !progressStatistic!
                                .currentMonthCompletions[days[index].day - 1]) {
                          status = 2;
                        } else if (index == selectedDay &&
                            progressStatistic!
                                .currentMonthCompletions[days[index].day - 1]) {
                          status = 4;
                        } else {
                          status = 3;
                        }

                        Color bgColor;
                        String iconAsset;
                        Color textColor;

                        switch (status) {
                          case 1:
                            bgColor = Colors.transparent;
                            iconAsset = AppAssets.prizeActiveIcon;
                            textColor = AppColors.bNormal;
                            break;
                          case 2:
                            bgColor = AppColors.prizeSelected;
                            iconAsset = AppAssets.prizeTodayIcon;
                            textColor = AppColors.bNormal;
                            break;
                          case 3:
                            bgColor = Colors.transparent;
                            iconAsset = AppAssets.prizeNotActiveIcon;
                            textColor = const Color(0xffb6abab);
                            break;
                          case 4:
                            bgColor = AppColors.prizeSelected;
                            iconAsset = AppAssets.prizeActiveIcon;
                            textColor = AppColors.bNormal;
                            break;
                          default:
                            bgColor = Colors.transparent;
                            iconAsset = AppAssets.prizeNotActiveIcon;
                            textColor = const Color(0xffb6abab);
                            break;
                        }

                        return Container(
                          width: AppDimensions.size48,
                          height: AppDimensions.size72,
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.borderRadiusSmall,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(iconAsset),
                              SizedBox(height: AppDimensions.size4),
                              Text(
                                '${days[index].day}',
                                style: TextStyle(color: textColor),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),

                  SizedBox(height: AppDimensions.spacingM),

                  // Toggle buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTab("Kế hoạch đề xuất", 0),
                      _buildTab("Lựa chọn của bạn", 1),
                    ],
                  ),

                  SizedBox(height: AppDimensions.spacingL),
                  selectedIndex == 0
                      ? _buildTab1(
                          user,
                          schedules,
                          days,
                          trainingDayImage,
                          trainingDayShapeImage,
                        )
                      : _buildTab2(),
                  SizedBox(height: AppDimensions.size104),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        width: AppDimensions.width * (selectedIndex == index ? 0.5.w : 0.40.w),
        height: selectedIndex == index
            ? AppDimensions.size48
            : AppDimensions.size40,
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.bNormal : AppColors.bLightActive,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? AppColors.wWhite : AppColors.dark,
            fontWeight: FontWeight.bold,
            fontSize: AppDimensions.textSizeS,
          ),
        ),
      ),
    );
  }

  Widget _buildTab1(
    UserProfileResponse user,
    List<TrainingScheduleResponse> schedules,
    List<DateTime> days,
    List<String> trainingDayImage,
    List<String> trainingDayShapeImage,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tag: Mục tiêu - Plan
        Container(
          width: AppDimensions.spacingWidthInfinite,
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingSM,
            vertical: AppDimensions.paddingS,
          ),
          decoration: BoxDecoration(
            color: AppColors.bNormal,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusTiny),
          ),
          child: Text(
            "${MappingTrainingResourceHelper.mappingGoalToVietnamese(user.trainingPlans!.first.goals)}  •  ${user.trainingPlans?.first.name}",
            style: TextStyle(
              color: AppColors.wWhite,
              fontSize: AppDimensions.textSizeM,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        SizedBox(height: AppDimensions.spacingML),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WeeklyTimeline(
              selectedIndex: selectedIndex2,
              onChanged: (newIndex) {
                setState(() {
                  selectedIndex2 = newIndex;
                });
              },
            ),
            SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: Column(
                children: List.generate(7, (index) {
                  final isSelected = index == selectedIndex2;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: EdgeInsets.only(
                      top: index == 0 ? 0.w : AppDimensions.paddingM,
                    ),
                    width: AppDimensions.size304,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: isSelected
                          ? Column(
                              key: ValueKey('selected_$index'),
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: AppDimensions.paddingS,
                                  ),
                                  child: Text(
                                    (selectedIndex2 != selectedDay)
                                        ? ((selectedDay - selectedIndex2)
                                                          .abs() ==
                                                      1 &&
                                                  selectedIndex2 > selectedDay)
                                              ? 'Tiếp theo'
                                              : '${(selectedDay - selectedIndex2).abs()} ngày ${(selectedIndex2 < selectedDay) ? 'trước' : 'tới'}'
                                        : 'Hôm nay',
                                    style: TextStyle(
                                      color: AppColors.dark,
                                      fontSize: AppDimensions.textSizeM,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppDimensions.paddingS),
                                Container(
                                  padding: EdgeInsets.only(
                                    left: AppDimensions.spacingSM,
                                    right: AppDimensions.spacingSM,
                                    top: AppDimensions.spacingSM,
                                  ),
                                  width: AppDimensions.spacingWidthInfinite,
                                  height: AppDimensions.size160,
                                  decoration: BoxDecoration(
                                    color: AppColors.wWhite,
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.borderRadius,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 8.w,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${days[index].day}/${days[index].month}',
                                                style: TextStyle(
                                                  fontSize:
                                                      AppDimensions.textSizeM,
                                                  color: AppColors.bNormal,
                                                ),
                                              ),
                                              SizedBox(
                                                height: AppDimensions.size4,
                                              ),
                                              Text(
                                                'Ngày ${index + 1}',
                                                style: TextStyle(
                                                  fontSize:
                                                      AppDimensions.textSizeL,
                                                  color: AppColors.dark,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: AppDimensions.size4,
                                              ),
                                              Text(
                                                schedules[index].duration ??
                                                    'Nghỉ ngơi, hồi phục',
                                                style: TextStyle(
                                                  fontSize:
                                                      AppDimensions.textSizeS,
                                                  color: AppColors.bNormal,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Image.asset(
                                            trainingDayShapeImage[index],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: AppDimensions.spacingS),
                                      (selectedIndex2 < selectedDay)
                                          ? ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.moreLighter,
                                                minimumSize: Size(
                                                  AppDimensions
                                                      .spacingWidthInfinite,
                                                  AppDimensions.size40,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        AppDimensions
                                                            .borderRadiusSmall,
                                                      ),
                                                ),
                                              ),
                                              onPressed: () {},
                                              child: Text(
                                                'Đã hoàn thành',
                                                style: TextStyle(
                                                  fontSize:
                                                      AppDimensions.textSizeS,
                                                  color: AppColors.wWhite,
                                                ),
                                              ),
                                            )
                                          : (selectedIndex2 == selectedDay)
                                          ? ((schedules[index].duration == null)
                                                ? ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          AppColors.moreLighter,
                                                      minimumSize: Size(
                                                        AppDimensions
                                                            .spacingWidthInfinite,
                                                        AppDimensions.size40,
                                                      ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              AppDimensions
                                                                  .borderRadiusSmall,
                                                            ),
                                                      ),
                                                    ),
                                                    onPressed: () {},
                                                    child: Text(
                                                      'Đã hoàn thành',
                                                      style: TextStyle(
                                                        fontSize: AppDimensions
                                                            .textSizeS,
                                                        color: AppColors.wWhite,
                                                      ),
                                                    ),
                                                  )
                                                : ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          AppColors.bNormal,
                                                      minimumSize: Size(
                                                        AppDimensions
                                                            .spacingWidthInfinite,
                                                        AppDimensions.size40,
                                                      ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              AppDimensions
                                                                  .borderRadiusSmall,
                                                            ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              TrainingDayDetailScreen(
                                                                schedule:
                                                                    schedules[index],
                                                                numberDay:
                                                                    'Ngày ${index + 1}',
                                                                imageBG:
                                                                    trainingDayImage[index],
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                    child: Text(
                                                      'Bắt đầu',
                                                      style: TextStyle(
                                                        fontSize: AppDimensions
                                                            .textSizeS,
                                                        color: AppColors.wWhite,
                                                      ),
                                                    ),
                                                  ))
                                          : ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.bLightActive,
                                                minimumSize: Size(
                                                  AppDimensions
                                                      .spacingWidthInfinite,
                                                  AppDimensions.size40,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        AppDimensions
                                                            .borderRadiusSmall,
                                                      ),
                                                ),
                                              ),
                                              onPressed: () {},
                                              child: Text(
                                                'Chưa bắt đầu',
                                                style: TextStyle(
                                                  fontSize:
                                                      AppDimensions.textSizeS,
                                                  color: AppColors.wWhite,
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: AppDimensions.paddingXL),
                                if (index != 6)
                                  Text(
                                    (selectedIndex2 != selectedDay)
                                        ? (selectedDay - selectedIndex2 - 1)
                                                      .abs() ==
                                                  0
                                              ? 'Hôm nay'
                                              : '${(selectedDay - selectedIndex2 - 1).abs()} ngày ${(selectedIndex2 < selectedDay) ? 'trước' : 'tới'}'
                                        : 'Tiếp theo',
                                    style: TextStyle(
                                      color: AppColors.dark,
                                      fontSize: AppDimensions.textSizeM,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex2 = index;
                                });
                              },
                              child: Container(
                                key: ValueKey('unselected_$index'),
                                padding: EdgeInsets.all(
                                  AppDimensions.spacingSM,
                                ),
                                height: AppDimensions.size104,
                                width: AppDimensions.spacingWidthInfinite,
                                decoration: BoxDecoration(
                                  color: AppColors.wWhite,
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.borderRadius,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8.w,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${days[index].day}/${days[index].month}',
                                          style: TextStyle(
                                            fontSize: AppDimensions.textSizeS,
                                            color: AppColors.bNormal,
                                          ),
                                        ),
                                        SizedBox(height: AppDimensions.size4),
                                        Text(
                                          'Ngày ${index + 1}',
                                          style: TextStyle(
                                            fontSize: AppDimensions.textSizeL,
                                            color: AppColors.dark,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: AppDimensions.size4),
                                        Text(
                                          schedules[index].duration ??
                                              'Nghỉ ngơi, hồi phục',
                                          style: TextStyle(
                                            fontSize: AppDimensions.textSizeS,
                                            color: AppColors.bNormal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Image.asset(trainingDayShapeImage[index]),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTab2() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(AppAssets.personalTraining),
          SizedBox(height: AppDimensions.spacingSM),
          Text(
            'Bạn chưa có kế hoạch tập luyện nào...',
            style: TextStyle(
              fontSize: AppDimensions.textSizeS,
              color: AppColors.dark,
            ),
          ),
          SizedBox(height: AppDimensions.spacingSM),
          SizedBox(
            width: AppDimensions.size144,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.bNormal,
                foregroundColor: AppColors.wWhite,
                padding: EdgeInsets.symmetric(
                  vertical: AppDimensions.paddingM,
                  horizontal: AppDimensions.paddingM,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusLarge,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thêm mới',
                    style: TextStyle(
                      color: AppColors.wWhite,
                      fontSize: AppDimensions.textSizeM,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.add,
                    color: AppColors.wWhite,
                    size: AppDimensions.iconSizeL,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
