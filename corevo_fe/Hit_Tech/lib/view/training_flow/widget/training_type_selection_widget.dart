import 'package:flutter/material.dart';
import 'package:hit_tech/core/constants/app_assets.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';
import 'package:hit_tech/view/training_flow/widget/training_frequency_selection_widget.dart';

import '../../../../core/constants/app_color.dart';
import '../../../model/request/training/training_flow_request.dart';
import '../../../service/training_flow_service.dart';

class TrainingTypeSelectionWidget extends StatefulWidget {
  final String? nextStep;
  final Map<String, List<String>> selectedValues;
  final List<String> options;

  const TrainingTypeSelectionWidget({
    Key? key,
    required this.nextStep,
    required this.selectedValues,
    required this.options,
  }) : super(key: key);

  @override
  _TrainingTypeSelectionState createState() => _TrainingTypeSelectionState();
}

class _TrainingTypeSelectionState extends State<TrainingTypeSelectionWidget> {
  int? selectedIndex;

  String? get currentStep => widget.nextStep;

  Map<String, List<String>> get selectedValues => widget.selectedValues;

  List<String> get options => widget.options;

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
                            final progress = 4 / 7;
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
                        'Thể loại mà bạn ưa thích\nlà gì?',
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
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final isSelected = selectedIndex == index;

                    return GestureDetector(
                      onTap: () => setState(() {
                        selectedIndex = isSelected ? null : index;
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
                            SizedBox(width: AppDimensions.spacingML),
                            Image.asset(
                              isSelected
                                  ? typeImagesSelected[option] ??
                                        AppAssets.defaultImage
                                  : typeImages[option] ??
                                        AppAssets.defaultImage,
                              width: AppDimensions.size40,
                              height: AppDimensions.size40,
                            ),
                            SizedBox(width: AppDimensions.spacingML),
                            Expanded(
                              child: Text(
                                option,
                                style: TextStyle(
                                  fontSize: AppDimensions.textSizeL,
                                  color: isSelected
                                      ? AppColors.bNormal
                                      : AppColors.darkActive,
                                  fontWeight: FontWeight.w700,
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
                      final selectedType = options[selectedIndex!];

                      final request = TrainingFlowRequest(
                        currentStep: currentStep,
                        selectedValue: [selectedType],
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
                                TrainingFrequencySelectionWidget(
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

  final Map<String, String> typeImages = {
    "Yoga": AppAssets.yoga,
    "Calisthenic": AppAssets.calisthenic,
    "Gym": AppAssets.gym,
    "Cardio": AppAssets.cardio,
  };

  final Map<String, String> typeImagesSelected = {
    "Yoga": AppAssets.yogaSelected,
    "Calisthenic": AppAssets.calisthenicSelected,
    "Gym": AppAssets.gymSelected,
    "Cardio": AppAssets.cardioSelected,
  };
}
