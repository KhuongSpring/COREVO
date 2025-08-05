import 'package:flutter/material.dart';
import 'package:hit_tech/view/personal_health/widget/age_selection_widget.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/constants/app_dimension.dart';
import '../../../core/constants/app_string.dart';

class GenderSelectionWidget extends StatefulWidget {
  const GenderSelectionWidget({super.key});

  @override
  State<GenderSelectionWidget> createState() => _GenderSelectionWidgetState();
}

class _GenderSelectionWidgetState extends State<GenderSelectionWidget> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.bLight,
      body: Stack(
        children: [
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
                            final progress = 1 / 5;
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
              SizedBox(height: 32),
              // Header Section
              Container(
                width: screenWidth * 0.9,
                padding: EdgeInsets.symmetric(
                  vertical: AppDimensions.paddingHorizontal,
                  horizontal: AppDimensions.spaceML,
                ),
                decoration: BoxDecoration(
                  color: AppColors.bLightNotActive2,
                  borderRadius: BorderRadius.circular(AppDimensions.circularXS),
                ),
                child: Column(
                  children: [
                    Text(
                      AppStrings.genderSelectionTitle,
                      style: TextStyle(
                        fontSize: AppDimensions.textSizeXL,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textGenderSelection,
                      ),
                    ),
                    SizedBox(height: AppDimensions.spaceXS),
                    Text(
                      AppStrings.genderSelectionDescription,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppDimensions.textSizeS,
                        color: AppColors.dark,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              // Gender Options
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildGenderOption(
                      context,
                      gender: 'Male',
                      label: AppStrings.genderSelectionBoy,
                      imagePath: TrainingAssets.imageGenderBoy,
                      isSelected: selectedGender == 'Male',
                      ontap: () {
                        setState(() {
                          selectedGender = 'Male';
                        });
                      },
                    ),
                    SizedBox(width: 16),
                    _buildGenderOption(
                      context,
                      gender: 'Female',
                      label: AppStrings.genderSelectionGirl,
                      imagePath: TrainingAssets.imageGenderGirl,
                      isSelected: selectedGender == 'Female',
                      ontap: () {
                        setState(() {
                          selectedGender = 'Female';
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppDimensions.space24),
              // Continue Button
              Padding(
                padding: EdgeInsets.only(left: 24, bottom: 70, right: 24),
                child: SizedBox(
                  width: AppDimensions.normal,
                  height: AppDimensions.heightButton,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AgeSelectionWidget(
                            gender: selectedGender ?? 'Male',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedGender != null
                          ? AppColors.buttonBGBottomGenderfocus
                          : AppColors.bLightNotActive,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.circularM,
                        ),
                      ),
                      // elevation: formState.gender != null ? 2 : 0,
                    ),
                    child: Text(
                      AppStrings.genderSelectionContinue,
                      style: TextStyle(
                        fontSize: 20,
                        color: selectedGender != null
                            ? AppColors.buttonTextGenderfocus
                            : AppColors.wWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption(
    BuildContext context, {
    required String gender,
    required String label,
    required String imagePath,
    required bool isSelected,
    VoidCallback? ontap,
  }) {
    return GestureDetector(
      onTap: () {
        if (ontap != null) {
          ontap();
        }
      },
      child: SizedBox(
        width: 160,
        height: 320,
        child: Stack(
          children: [
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  height: 260,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.bLightActive
                        : AppColors.wWhite,
                    border: Border.all(
                      color: isSelected ? AppColors.bNormal : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadius,
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              top: 30 + 260 - 60,
              left: 2,
              right: 2,
              child: IgnorePointer(
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        (isSelected)
                            ? AppColors.bLightActive
                            : AppColors.moreLighter,
                        (isSelected)
                            ? AppColors.bLightActive
                            : AppColors.wWhite,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(imagePath, height: 350, fit: BoxFit.contain),
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.bLightActive
                        : AppColors.wWhite,
                    border: Border.all(
                      color: isSelected ? AppColors.bNormal : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadius,
                    ),
                  ),
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        (gender == 'Male') ? Icons.male : Icons.female,
                        color: (gender == 'Male' ? Colors.blue : Colors.pink),
                      ),
                      SizedBox(width: 10),
                      Text(
                        label,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
