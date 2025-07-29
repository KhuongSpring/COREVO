import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/health_bloc.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/heath_event.dart';

import 'package:hit_tech/features/health_infor/cubit/blocs/heath_state.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_dimension.dart';
import '../../../../core/constants/app_string.dart';

class GenderSelectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HealthInfoBloc, HealthInfoState>(
      builder: (context, state) {
        final formState = state is HealthInfoFormState
            ? state
            : HealthInfoFormState();

        return Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingHorizontal),
          child: Column(
            children: [
              // Header Section
              Container(
                width: double.infinity,
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
              SizedBox(height: AppDimensions.space24),
              // Gender Options
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildGenderOption(
                      context,
                      gender: 'MALE',
                      label: AppStrings.genderSelectionBoy,
                      imagePath: TrainingAssets
                          .imageGenderBoy, // Replace with actual asset path
                      isSelected: formState.gender == 'MALE',
                    ),
                    SizedBox(width: 16),
                    _buildGenderOption(
                      context,
                      gender: 'FEMALE',
                      label: AppStrings.genderSelectionGirl,
                      imagePath: TrainingAssets
                          .imageGenderGirl, // Replace with actual asset path
                      isSelected: formState.gender == 'FEMALE',
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppDimensions.space24),
              // Continue Button
              Padding(
                padding: EdgeInsets.all(AppDimensions.space24),
                child: SizedBox(
                  width: AppDimensions.normal,
                  height: AppDimensions.heightButton,
                  child: ElevatedButton(
                    onPressed: formState.gender != null
                        ? () {
                            context.read<HealthInfoBloc>().add(NextStep());
                          }
                        : () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: formState.gender != null
                          ? AppColors.buttonBGBottomGenderfocus
                          : AppColors.bLightNotActive,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.circularM,
                        ),
                      ),
                      elevation: formState.gender != null ? 2 : 0,
                    ),
                    child: Text(
                      AppStrings.genderSelectionContinue,
                      style: TextStyle(
                        fontSize: AppDimensions.textSizeM,
                        color: formState.gender != null
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
        );
      },
    );
  }

  Widget _buildGenderOption(
    BuildContext context, {
    required String gender,
    required String label,
    required String imagePath,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        context.read<HealthInfoBloc>().add(UpdateGender(gender));
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: 260,
        width: 160, // Fixed width to match the design
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            Container(
              height: 280,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.bLightActive : AppColors.wWhite,
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(color: Color(0xFF2196F3), width: 2)
                    : Border.all(color: Color(0xFFE0E0E0), width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          gender == 'MALE' ? Icons.male : Icons.female,
                          size: 80,
                          color: isSelected ? Colors.white : Color(0xFF757575),
                        ),
                        SizedBox(height: 8),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected
                                ? Colors.white
                                : Color(0xFF757575),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            // Label at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? Color(0xFF2196F3) : Color(0xFFE0E0E0),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      gender == 'MALE' ? Icons.male : Icons.female,
                      size: 18,
                      color: isSelected ? Color(0xFF2196F3) : Color(0xFF757575),
                    ),
                    SizedBox(width: 6),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Color(0xFF2196F3)
                            : Color(0xFF757575),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
