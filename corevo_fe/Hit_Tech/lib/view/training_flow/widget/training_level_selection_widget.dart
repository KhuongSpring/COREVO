import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';
import 'package:hit_tech/view/training_flow/widget/training_duration_selection_widget.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_color.dart';
import '../../../model/request/training/training_flow_request.dart';
import '../../../service/training_flow_service.dart';

class TrainingLevelSelectionWidget extends StatefulWidget {
  final String? nextStep;
  final Map<String, List<String>> selectedValues;
  final List<int> options;

  const TrainingLevelSelectionWidget({
    Key? key,
    required this.nextStep,
    required this.selectedValues,
    required this.options,
  }) : super(key: key);

  @override
  _TrainingLevelSelectionState createState() => _TrainingLevelSelectionState();
}

class _TrainingLevelSelectionState extends State<TrainingLevelSelectionWidget> {
  int? selectedIndex;

  String? get currentStep => widget.nextStep;

  Map<String, List<String>> get selectedValues => widget.selectedValues;

  List<int> get options => widget.options;

  final List<String> levels = ["Mới bắt đầu", "Cơ bản", "Nâng cao"];
  final List<String> levelDetails = [
    "Tập nhẹ, làm quen với động tác cơ bản",
    "Đã có nền tảng, muốn nâng cao hiệu quả luyện tập",
    "Tập cường độ cao, hướng tới mục tiêu rõ ràng",
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
                            final progress = 2 / 7;
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
                        'Mức độ kinh nghiệm\ncủa bạn là gì?',
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
                  itemCount: levels.length,
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
                            SizedBox(width: AppDimensions.spacingML),
                            Image.asset(
                              index == 0
                                  ? (selectedIndex == 0
                                        ? AppAssets.beginnerSelected
                                        : AppAssets.beginner)
                                  : index == 1
                                  ? (selectedIndex == 1
                                        ? AppAssets.intermediateSelected
                                        : AppAssets.intermediate)
                                  : (selectedIndex == 2
                                        ? AppAssets.advancedSelected
                                        : AppAssets.advanced),
                            ),
                            SizedBox(width: AppDimensions.spacingML),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    levels[index],
                                    style: TextStyle(
                                      fontSize: AppDimensions.textSizeL,
                                      color: AppColors.dark,
                                    ),
                                  ),
                                  SizedBox(height: AppDimensions.spacingSM),
                                  Text(
                                    levelDetails[index],
                                    style: TextStyle(
                                      fontSize: AppDimensions.textSizeS,
                                      color: AppColors.lightHover,
                                    ),
                                  ),
                                ],
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
                    stops: [0.0, 0.0],
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
                      var selectedLevel = levels[selectedIndex!];
                      selectedLevel = normalizeLevel(selectedLevel);

                      if (!options.contains(selectedIndex! + 1)) {
                        selectedLevel = "INTERMEDIATE";
                      }

                      final request = TrainingFlowRequest(
                        currentStep: currentStep,
                        selectedValue: [selectedLevel],
                        selectedValues: selectedValues,
                      );

                      try {
                        final response = await TrainingFlowService.sendStep(
                          request,
                        );

                        var selectedValues = response.selectedValues;

                        final List<String> durations = response.options
                            .toList();

                        print(response.nextStep);
                        print(selectedValues);
                        print(durations);

                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) =>
                                TrainingDurationSelectionWidget(
                                  nextStep: response.nextStep,
                                  selectedValues: selectedValues,
                                  options: durations,
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

  String normalizeLevel(String vietnameseLevel) {
    const mapping = {
      "Mới bắt đầu": "BEGINNER",
      "Cơ bản": "INTERMEDIATE",
      "Nâng cao": "ADVANCED",
    };

    return mapping[vietnameseLevel] ?? vietnameseLevel;
  }
}
