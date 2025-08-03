import 'package:flutter/material.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bLight,
      body: Stack(
        children: [
          // Ảnh nền
          Positioned.fill(
            child: Image.asset(
              TrainingAssets.mainBackground,
              fit: BoxFit.cover,
            ),
          ),

          Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 50, right: 70),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.bNormal,
                      ),
                    ),
                    SizedBox(width: 35),
                    Expanded(
                      child: Container(
                        height: 7,
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
              SizedBox(height: 30),
              // Header
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  color: AppColors.bLightHover,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusSmall,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20.0,
                      height: 90.0,
                      decoration: BoxDecoration(color: AppColors.bLightActive2),
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: Text(
                        'Mục Tiêu Luyện Tập\ncủa bạn là gì?',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkActive,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Item list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 150),
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
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        height: 110,
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
                                : Colors.grey.shade300,
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
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: AppColors.darkActive,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                TrainingAssets.goalDemo,
                                width: 90,
                                height: 90,
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
                    stops: [0.0, 0.2],
                  ),
                ),
              ),
            ),
          ),

          // Button "Tiếp tục" nổi lên trên cùng
          Positioned(
            left: 16,
            right: 16,
            bottom: 70,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedIndex != null
                    ? AppColors.bNormal
                    : AppColors.bLightNotActive,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: selectedIndex != null
                  ? () async {
                      var selectedGoal = goals[selectedIndex!];
                      selectedGoal = normalizeGoal(selectedGoal);

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
                          MaterialPageRoute(
                            builder: (context) => TrainingLevelSelectionWidget(
                              nextStep: response.nextStep,
                              selectedValues: selectedValues,
                              options: levelIds,
                            ),
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
                  fontSize: 20,
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

  String normalizeGoal(String vietnameseGoal) {
    const mapping = {
      "Giảm cân / Giảm mỡ": "Lose fat",
      "Tăng cân": "Gain weight",
      "Tăng cơ": "Gain muscle",
      "Duy trì vóc dáng": "Maintain body",
      "Tăng sức bền": "Increase endurance",
      "Cải thiện tim mạch": "Improve cardiovascular",
      "Giảm stress, thư giãn": "Stress relief/relaxation",
      "Tăng chiều cao": "Increase height",
    };

    return mapping[vietnameseGoal] ?? vietnameseGoal;
  }
}
