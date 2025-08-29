import 'package:flutter/material.dart';
import 'package:hit_tech/core/constants/app_assets.dart';
import 'package:hit_tech/view/training_flow/widget/training_type_selection_widget.dart';

import '../../../../core/constants/app_color.dart';
import '../../../core/constants/app_dimension.dart';
import '../../../model/request/training/training_flow_request.dart';
import '../../../service/training_flow_service.dart';

class TrainingDurationSelectionWidget extends StatefulWidget {
  final String? nextStep;
  final Map<String, List<String>> selectedValues;
  final List<String> options;

  const TrainingDurationSelectionWidget({
    Key? key,
    required this.nextStep,
    required this.selectedValues,
    required this.options,
  }) : super(key: key);

  @override
  _TrainingDurationSelectionState createState() =>
      _TrainingDurationSelectionState();
}

class _TrainingDurationSelectionState
    extends State<TrainingDurationSelectionWidget> {
  int? selectedIndex;

  String? get currentStep => widget.nextStep;

  Map<String, List<String>> get selectedValues => widget.selectedValues;

  List<String> get options => widget.options;

  final List<String> durations = [
    "15 - 30 phút",
    "30 - 45 phút",
    "45 - 60 phút",
    "Trên 60 phút",
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
                            final progress = 3 / 7;
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
                        'Thời gian luyện tập mà bạn\ndành ra trong một ngày?',
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
                  itemCount: durations.length,
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
                        height: AppDimensions.size96,
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
                            SizedBox(width: AppDimensions.spacingSM),
                            Image.asset(
                              index == 0
                                  ? (selectedIndex == 0
                                        ? AppAssets.durationSelected1
                                        : AppAssets.duration1)
                                  : index == 1
                                  ? (selectedIndex == 1
                                        ? AppAssets.durationSelected2
                                        : AppAssets.duration2)
                                  : index == 2
                                  ? (selectedIndex == 2
                                        ? AppAssets.durationSelected3
                                        : AppAssets.duration3)
                                  : (selectedIndex == 3
                                        ? AppAssets.durationSelected4
                                        : AppAssets.duration4),
                            ),
                            SizedBox(width: AppDimensions.spacingML),
                            Expanded(
                              child: Text(
                                durations[index],
                                style: TextStyle(
                                  fontSize: AppDimensions.textSizeL,
                                  color: (selectedIndex == index
                                      ? AppColors.bNormal
                                      : AppColors.darkActive),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.borderRadiusSmall,
                              ),
                              child: Image.asset(
                                selectedIndex == index
                                    ? AppAssets.tickActive
                                    : AppAssets.tickNonActive,
                                width: AppDimensions.iconSizeL,
                                height: AppDimensions.iconSizeL,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: AppDimensions.spacingSM),
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
                      final request = TrainingFlowRequest(
                        currentStep: currentStep,
                        selectedValue: options,
                        selectedValues: selectedValues,
                      );

                      try {
                        final response = await TrainingFlowService.sendStep(
                          request,
                        );

                        var selectedValues = response.selectedValues;

                        print(response.nextStep);
                        print(selectedValues);
                        print(response.options);

                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) =>
                                TrainingTypeSelectionWidget(
                                  nextStep: response.nextStep,
                                  selectedValues: selectedValues,
                                  options: response.options,
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

  String normalizeReverseDurationList(List<String> durations) {
    return durations.join('\n');
  }
}
