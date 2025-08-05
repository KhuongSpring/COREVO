import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/utils/mapping_training_resource_helper.dart';
import 'package:hit_tech/view/main_root/training/training_day_detail_screen.dart';
import 'package:hit_tech/view/main_root/training/widget/weekly_time_line.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_color.dart';
import '../../../model/response/training/training_schedule_response.dart';
import '../../../model/response/user/user_profile_response.dart';

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

  int selectedIndex2 = DateTime.now().weekday - 1;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width.sp;
    final UserProfileResponse user = widget.userProfileResponse;
    final List<TrainingScheduleResponse> schedules = widget.schedules;
    final List<DateTime> days = getWeekDates(DateTime.now());

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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: ListView(
                children: [
                  SizedBox(height: 20.sp),
                  // Medal selector row
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(days.length, (index) {
                        return Container(
                          width: 45,
                          height: 70,
                          decoration: BoxDecoration(
                            color: index == selectedDay
                                ? AppColors.prizeSelected
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                index == selectedDay
                                    ? TrainingAssets.prizeActiveIcon
                                    : TrainingAssets.prizeNotActiveIcon,
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${days[index].day}',
                                style: TextStyle(
                                  color: index == selectedDay
                                      ? AppColors.bNormal
                                      : Color(0xffb6abab),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Toggle buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTab("Kế hoạch đề xuất", 0),
                      _buildTab("Lựa chọn của bạn", 1),
                    ],
                  ),

                  const SizedBox(height: 25),
                  selectedIndex == 0
                      ? _buildTab1(user, schedules, days)
                      : _buildTab2(),
                  SizedBox(height: 150),
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
        width:
            MediaQuery.of(context).size.width *
            (selectedIndex == index ? 0.5 : 0.40),
        height: selectedIndex == index ? 50 : 45,
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.bNormal : AppColors.bLightActive,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTab1(
    UserProfileResponse user,
    List<TrainingScheduleResponse> schedules,
    List<DateTime> days,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tag: Mục tiêu - Plan
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.bNormal,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            "${MappingTrainingResourceHelper.mappingGoalToVietnamese(user.trainingPlans!.first.goals)}  •  ${user.trainingPlans?.first.name}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        SizedBox(height: 20),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WeeklyTimeline(selectedIndex: selectedIndex2),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: List.generate(7, (index) {
                  final isSelected = index == selectedIndex2;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: EdgeInsets.only(top: index == 0 ? 0 : 16),
                    width: 300,
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
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    'Hôm nay',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                    right: 12,
                                    top: 12,
                                  ),
                                  width: double.infinity,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${days[index].day}/${days[index].month}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.bNormal,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                'Ngày ${index + 1}',
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                '${schedules[index].duration}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.bNormal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 23),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.bNormal,
                                          minimumSize: Size(
                                            double.infinity,
                                            40,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TrainingDayDetailScreen(
                                                    schedule: schedules[index],
                                                    numberDay:
                                                        'Ngày ${index + 1}',
                                                  ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Bắt đầu',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 30),
                                if (index != 6)
                                  Text(
                                    'Tiếp theo',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            )
                          : Container(
                              key: ValueKey('unselected_$index'),
                              padding: const EdgeInsets.all(12),
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${days[index].day}/${days[index].month}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.bNormal,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Ngày ${index + 1}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        '${schedules[index].duration}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.bNormal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
    return Container();
  }
}
