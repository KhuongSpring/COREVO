import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/health_bloc.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/heath_state.dart';
import 'package:hit_tech/features/health_infor/view/widgets/activity_level_selection_widget.dart';
import 'package:hit_tech/features/health_infor/view/widgets/age_selection_widget.dart';
import 'package:hit_tech/features/health_infor/view/widgets/gender_selection_widget.dart';
import 'package:hit_tech/features/health_infor/view/widgets/height_selection_widget.dart';
import 'package:hit_tech/features/health_infor/view/widgets/weight_selection_widget.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_dimension.dart';

class HealthInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bLight,
      body: SafeArea(
        child: BlocConsumer<HealthInfoBloc, HealthInfoState>(
          listener: (context, state) {
            if (state is HealthInfoSuccess) {
              Navigator.pushReplacementNamed(context, '/dashboard');
            } else if (state is HealthInfoError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is HealthInfoLoading) {
              return Center(child: CircularProgressIndicator());
            }

            final formState = state is HealthInfoFormState
                ? state
                : HealthInfoFormState();

            return Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    TrainingAssets.mainBackground,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  children: [
                    // Progress Bar
                    Container(
                      padding: EdgeInsets.only(top: 20, right: 70),
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
                                  final progress = (formState.currentStep + 1) / 5;
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

                    // Content
                    Expanded(child: _buildCurrentStep(formState)),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCurrentStep(HealthInfoFormState state) {
    switch (state.currentStep) {
      case 0:
        return GenderSelectionWidget();
      case 1:
        return AgeSelectionWidget();
      case 2:
        return HeightSelectionWidget();
      case 3:
        return WeightSelectionWidget();
      case 4:
        return ActivityLevelSelectionWidget();
      default:
        return GenderSelectionWidget();
    }
  }
}
