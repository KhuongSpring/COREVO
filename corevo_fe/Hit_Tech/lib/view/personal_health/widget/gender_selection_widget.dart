import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return Scaffold(
      backgroundColor: AppColors.bLight,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppAssets.mainBackground, fit: BoxFit.cover),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: AppDimensions.height),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          top: AppDimensions.paddingXL,
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
                                    final progress = 1 / 5;
                                    return Stack(
                                      children: [
                                        Container(
                                          width:
                                              constraints.maxWidth * progress,
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
                      // Header Section
                      Container(
                        width: AppDimensions.width * 0.9.w,
                        padding: EdgeInsets.symmetric(
                          vertical: AppDimensions.paddingL,
                          horizontal: AppDimensions.paddingL,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.bLightNotActive2,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.borderRadius,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              AppStrings.genderSelectionTitle,
                              style: TextStyle(
                                fontSize: AppDimensions.textSizeXL,
                                fontWeight: FontWeight.bold,
                                color: AppColors.dark,
                              ),
                            ),
                            SizedBox(height: AppDimensions.spacingS),
                            Text(
                              AppStrings.genderSelectionDescription,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: AppDimensions.textSizeM,
                                color: AppColors.dark,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppDimensions.spacingXL),
                      // Gender Options
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildGenderOption(
                            context,
                            gender: 'Male',
                            label: AppStrings.genderSelectionBoy,
                            imagePath: AppAssets.imageGenderBoy,
                            isSelected: selectedGender == 'Male',
                            ontap: () {
                              setState(() {
                                selectedGender = 'Male';
                              });
                            },
                          ),
                          SizedBox(width: AppDimensions.spacingM),
                          _buildGenderOption(
                            context,
                            gender: 'Female',
                            label: AppStrings.genderSelectionGirl,
                            imagePath: AppAssets.imageGenderGirl,
                            isSelected: selectedGender == 'Female',
                            ontap: () {
                              setState(() {
                                selectedGender = 'Female';
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: AppDimensions.size168),
                      // Continue Button
                      Padding(
                        padding: EdgeInsets.only(
                          left: AppDimensions.paddingL,
                          bottom: AppDimensions.size72,
                          right: AppDimensions.paddingL,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: AppDimensions.heightButton,
                          child: ElevatedButton(
                            onPressed: () {
                              selectedGender != null
                                  ? Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (_, __, ___) =>
                                            AgeSelectionWidget(
                                              gender: selectedGender ?? 'Male',
                                            ),
                                        transitionsBuilder:
                                            (_, animation, __, child) {
                                              return FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              );
                                            },
                                      ),
                                    )
                                  : null;
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedGender != null
                                  ? AppColors.bNormal
                                  : AppColors.bLightNotActive,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadiusLarge,
                                ),
                              ),
                              // elevation: formState.gender != null ? 2 : 0,
                            ),
                            child: Text(
                              AppStrings.genderSelectionContinue,
                              style: TextStyle(
                                fontSize: AppDimensions.textSizeL,
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
                ),
              ),
            ),
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
        width: AppDimensions.size160,
        height: AppDimensions.size320,
        child: Stack(
          children: [
            Positioned(
              bottom: AppDimensions.paddingXL,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  height: AppDimensions.size264,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.bLightActive
                        : AppColors.wWhite,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.bNormal
                          : AppColors.moreLighter,
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
              top:
                  AppDimensions.spacingXL +
                  AppDimensions.size264 -
                  AppDimensions.spacingGiant,
              left: 2.w,
              right: 2.w,
              child: IgnorePointer(
                child: Container(
                  height: AppDimensions.size64,
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
                child: Image.asset(
                  imagePath,
                  height: AppDimensions.size344,
                  fit: BoxFit.contain,
                ),
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
                      color: isSelected
                          ? AppColors.bNormal
                          : AppColors.moreLighter,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadius,
                    ),
                  ),
                  height: AppDimensions.size64,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        (gender == 'Male') ? Icons.male : Icons.female,
                        color: (gender == 'Male' ? Colors.blue : Colors.pink),
                      ),
                      SizedBox(width: AppDimensions.size8),
                      Text(
                        label,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: AppDimensions.textSizeS,
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
