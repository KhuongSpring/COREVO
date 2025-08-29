import 'package:flutter/material.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';
import 'package:hit_tech/utils/mapping_training_resource_helper.dart';
import 'package:hit_tech/view/training_flow/widget/training_level_selection_widget.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_color.dart';
import '../../../model/request/training/training_flow_request.dart';
import '../../../service/training_flow_service.dart';

class TrainingGoalSelectionWidget extends StatefulWidget {
  @override
  _TrainingGoalSelectionState createState() => _TrainingGoalSelectionState();
}

class _TrainingGoalSelectionState extends State<TrainingGoalSelectionWidget> {
  int? selectedIndex;

  final List<String> goals = [
    "Giảm cân / Giảm mỡ",
    "Tăng cân",
    "Tăng cơ",
    "Duy trì vóc dáng",
    "Tăng sức bền",
    "Cải thiện tim mạch",
    "Giảm stress, thư giãn",
    "Tăng chiều cao",
  ];

  Map<String, List<String>> selectedValues = {};

  List<String> goalImage = [
    AppAssets.goal1,
    AppAssets.goal2,
    AppAssets.goal3,
    AppAssets.goal4,
    AppAssets.goal5,
    AppAssets.goal6,
    AppAssets.goal7,
    AppAssets.goal8,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bLight,
      body: Stack(
        children: [
          // Ảnh nền
          Positioned.fill(
            child: Image.asset(AppAssets.mainBackground, fit: BoxFit.cover),
          ),

          Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: AppDimensions.size48,
                  right: AppDimensions.size72,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.bNormal,
                      ),
                    ),
                    SizedBox(width: AppDimensions.spacingXL),
                    Expanded(
                      child: Container(
                        height: AppDimensions.size8,
                        decoration: BoxDecoration(
                          color: AppColors.moreLighter,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.borderRadius,
                          ),
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final progress = 1 / 7;
                            return Stack(
                              children: [
                                Container(
                                  width: constraints.maxWidth * progress,
                                  decoration: BoxDecoration(
                                    color: AppColors.bNormal,
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.borderRadius,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppDimensions.spacingXL),
              // Header
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                ),
                decoration: BoxDecoration(
                  color: AppColors.bLightHover,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusSmall,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: AppDimensions.size16,
                      height: AppDimensions.size88,
                      decoration: BoxDecoration(color: AppColors.bLightActive2),
                    ),
                    SizedBox(width: AppDimensions.size16),
                    Expanded(
                      child: Text(
                        'Mục Tiêu Luyện Tập\ncủa bạn là gì?',
                        style: TextStyle(
                          fontSize: AppDimensions.textSizeXL,
                          fontWeight: FontWeight.w600,
                          color: AppColors.dark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppDimensions.spacingXXL),

              // Item list
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                    AppDimensions.paddingM,
                    0,
                    AppDimensions.paddingM,
                    AppDimensions.size152,
                  ),
                  itemCount: goals.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => setState(() {
                        if (selectedIndex == index) {
                          selectedIndex = null;
                        } else {
                          selectedIndex = index;
                        }
                      }),
                      child: Container(
                        margin: EdgeInsets.only(bottom: AppDimensions.paddingM),
                        padding: EdgeInsets.all(AppDimensions.paddingM),
                        height: AppDimensions.size112,
                        decoration: BoxDecoration(
                          color: selectedIndex == index
                              ? AppColors.bLightHover
                              : AppColors.wWhite,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.borderRadiusSmall,
                          ),
                          border: Border.all(
                            color: selectedIndex == index
                                ? AppColors.bNormal
                                : AppColors.wWhite,
                            width: selectedIndex == index ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                goals[index],
                                style: TextStyle(
                                  fontSize: AppDimensions.textSizeL,
                                  color: AppColors.dark,
                                ),
                              ),
                            ),
                            SizedBox(width: AppDimensions.spacingSM),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.borderRadiusSmall,
                              ),
                              child: Image.asset(
                                goalImage[index],
                                width: AppDimensions.size88,
                                height: AppDimensions.size88,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // Overlay mờ dần từ dưới lên
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [AppColors.wWhite, Colors.transparent],
                    stops: [0.0, 0.1],
                  ),
                ),
              ),
            ),
          ),

          // Button "Tiếp tục" nổi lên trên cùng
          Positioned(
            left: AppDimensions.paddingM,
            right: AppDimensions.paddingM,
            bottom: AppDimensions.size72,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedIndex != null
                    ? AppColors.bNormal
                    : AppColors.bLightNotActive,
                minimumSize: Size(
                  AppDimensions.spacingWidthInfinite,
                  AppDimensions.size56,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusLarge,
                  ),
                ),
              ),
              onPressed: selectedIndex != null
                  ? () async {
                      var selectedGoal = goals[selectedIndex!];
                      selectedGoal =
                          MappingTrainingResourceHelper.mappingGoalToEnglish(
                            selectedGoal,
                          );

                      final request = TrainingFlowRequest(
                        currentStep: 'goals',
                        selectedValue: [selectedGoal],
                        selectedValues: selectedValues,
                      );

                      try {
                        final response = await TrainingFlowService.sendStep(
                          request,
                        );

                        var selectedValues = response.selectedValues;

                        final List<int> levelIds = [];
                        switch (selectedGoal) {
                          case "Lose fat":
                            {
                              levelIds.add(1);
                              levelIds.add(2);
                              break;
                            }
                          case "Gain weight":
                            {
                              levelIds.add(1);
                              levelIds.add(2);
                              break;
                            }
                          case "Gain muscle":
                            {
                              levelIds.add(1);
                              levelIds.add(2);
                              levelIds.add(3);
                              break;
                            }
                          case "Maintain body":
                            {
                              levelIds.add(1);
                              levelIds.add(2);
                              break;
                            }
                          case "Increase endurance":
                            {
                              levelIds.add(1);
                              levelIds.add(2);
                              break;
                            }
                          case "Improve cardiovascular":
                            {
                              levelIds.add(1);
                              levelIds.add(2);
                              break;
                            }
                          case "Stress relief/relaxation":
                            {
                              levelIds.add(1);
                              levelIds.add(2);
                              levelIds.add(3);
                              break;
                            }
                          case "Increase height":
                            {
                              levelIds.add(1);
                              levelIds.add(2);
                              levelIds.add(3);
                              break;
                            }
                        }

                        print(response.nextStep);
                        print(selectedValues);
                        print(levelIds);

                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) =>
                                TrainingLevelSelectionWidget(
                                  nextStep: response.nextStep,
                                  selectedValues: selectedValues,
                                  options: levelIds,
                                ),
                            transitionsBuilder: (_, animation, __, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ),
                        );
                      } catch (e) {
                        print("Error: $e");
                      }
                    }
                  : null,
              child: Text(
                "Tiếp tục",
                style: TextStyle(
                  fontSize: AppDimensions.textSizeL,
                  color: selectedIndex != null
                      ? AppColors.wWhite
                      : AppColors.wDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
