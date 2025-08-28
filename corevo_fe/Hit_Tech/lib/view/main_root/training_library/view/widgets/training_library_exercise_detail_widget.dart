import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';
import 'package:hit_tech/model/response/training/training_exercise_response.dart';
import 'package:hit_tech/utils/mapping_training_resource_helper.dart';

import '../../../../../core/constants/app_color.dart';
import '../../../../../utils/training_exercise_image_helper.dart';

class TrainingLibraryExerciseDetailWidget extends StatefulWidget {
  final TrainingExerciseResponse exercise;

  const TrainingLibraryExerciseDetailWidget({
    super.key,
    required this.exercise,
  });

  @override
  State<TrainingLibraryExerciseDetailWidget> createState() =>
      _TrainingLibraryExerciseDetailWidgetState();
}

class _TrainingLibraryExerciseDetailWidgetState
    extends State<TrainingLibraryExerciseDetailWidget> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();

  Widget? _imageWidget;
  double? _imageWidth;
  double? _imageHeight;

  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _loadAndUseImage();
    _controller.addListener(() {
      if (_controller.size <= 0.5.w) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _loadAndUseImage() async {
    final result = await loadImageWithSize(widget.exercise.imageURL);

    if (!mounted) return;

    setState(() {
      _imageWidget = result.imageWidget;
      _imageWidth = result.width;
      _imageHeight = result.height;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;
    if (_imageWidget != null) {
      setState(() {
        _isReady = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TrainingExerciseResponse exerciseResponse = widget.exercise;

    List<String> primaryTargetMuscle =
        MappingTrainingResourceHelper.mappingTargetMuscleList(
          widget.exercise.primaryMuscleIds,
        );
    List<String> secondaryTargetMuscle =
        MappingTrainingResourceHelper.mappingTargetMuscleList(
          widget.exercise.secondaryMuscleIds,
        );
    ;
    List<String> equipments =
        MappingTrainingResourceHelper.mappingEquipmentList(
          widget.exercise.equipmentIds,
        );

    String? min = exerciseResponse.minRep == 0
        ? '${exerciseResponse.minDuration}'
        : '${exerciseResponse.minRep}';
    String? max = exerciseResponse.maxRep == 0
        ? '${exerciseResponse.maxDuration} secs'
        : '${exerciseResponse.maxRep} reps';

    return DraggableScrollableSheet(
      initialChildSize: 0.9.w,
      minChildSize: 0.52.w,
      maxChildSize: 1.0.w,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingML,
            vertical: AppDimensions.paddingL,
          ),
          decoration: BoxDecoration(
            color: AppColors.wWhite,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppDimensions.borderRadiusLarge),
            ),
          ),
          child: _isReady
              ? Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: AppDimensions.size72),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                height: AppDimensions.size4,
                                width: AppDimensions.width * 0.3.w,
                                decoration: BoxDecoration(
                                  color: AppColors.bNormal,
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.borderRadiusLarge,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: AppDimensions.spacingXL),
                            Text(
                              exerciseResponse.name,
                              style: TextStyle(
                                fontSize: AppDimensions.textSizeXL,
                                fontWeight: FontWeight.bold,
                                color: AppColors.dark,
                              ),
                            ),
                            SizedBox(height: AppDimensions.spacingL),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: (_imageHeight == 630.w)
                                    ? 0.w
                                    : AppDimensions.size4,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadius,
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Container(
                                  width: (_imageHeight == 630.0)
                                      ? AppDimensions.width.sp
                                      : AppDimensions.width * 0.8.w,
                                  height: (_imageHeight == 630.0)
                                      ? AppDimensions.size200
                                      : AppDimensions.size280,
                                  decoration: BoxDecoration(
                                    color: AppColors.wWhite,
                                    border: Border.all(
                                      color: AppColors.bNormal,
                                      width: 3.w,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.borderRadius,
                                    ),
                                  ),
                                  child:
                                      _imageWidget ??
                                      Icon(
                                        Icons.image,
                                        color: AppColors.moreLighter,
                                      ),
                                ),
                              ),
                            ),
                            SizedBox(height: AppDimensions.spacingM),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                width: AppDimensions.size184,
                                height: AppDimensions.size40,
                                decoration: BoxDecoration(
                                  color: AppColors.bNormal,
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.borderRadiusTiny,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '${(exerciseResponse.minSet == exerciseResponse.maxSet) ? exerciseResponse.minSet : '${exerciseResponse.minSet} - ${exerciseResponse.maxSet}'}'
                                    ' sets | '
                                    '$min - '
                                    '$max',
                                    style: TextStyle(
                                      fontSize: AppDimensions.textSizeS,
                                      color: AppColors.wWhite,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: AppDimensions.spacingML),
                            Text(
                              "GIỚI THIỆU",
                              style: TextStyle(
                                fontSize: AppDimensions.textSizeM,
                                fontWeight: FontWeight.bold,
                                color: AppColors.bNormal,
                              ),
                            ),
                            SizedBox(height: AppDimensions.spacingSM),
                            Text(
                              exerciseResponse.description,
                              style: TextStyle(
                                fontSize: AppDimensions.textSizeM,
                                color: AppColors.dark,
                              ),
                            ),
                            SizedBox(height: AppDimensions.spacingXL),
                            Text(
                              "NHÓM CƠ TÁC ĐỘNG",
                              style: TextStyle(
                                fontSize: AppDimensions.textSizeM,
                                fontWeight: FontWeight.bold,
                                color: AppColors.bNormal,
                              ),
                            ),
                            SizedBox(height: AppDimensions.spacingML),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  ...List.generate(primaryTargetMuscle.length, (
                                    index,
                                  ) {
                                    return _buildTrainingCategory(
                                      primaryTargetMuscle[index],
                                      isPrimary: true,
                                    );
                                  }),
                                  ...List.generate(
                                    secondaryTargetMuscle.length,
                                    (index) {
                                      return _buildTrainingCategory(
                                        secondaryTargetMuscle[index],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: AppDimensions.spacingXL),
                            Text(
                              "DỤNG CỤ LUYỆN TẬP",
                              style: TextStyle(
                                fontSize: AppDimensions.textSizeM,
                                fontWeight: FontWeight.bold,
                                color: AppColors.bNormal,
                              ),
                            ),
                            SizedBox(height: AppDimensions.spacingSM),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  ...List.generate(equipments.length, (index) {
                                    return _buildTrainingCategory(
                                      equipments[index],
                                      isEquipment: true,
                                    );
                                  }),
                                ],
                              ),
                            ),
                            SizedBox(height: AppDimensions.spacingXL),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: AppDimensions.paddingM,
                      right: AppDimensions.paddingM,
                      bottom: AppDimensions.paddingM,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.bNormal,
                          foregroundColor: AppColors.wWhite,
                          padding: EdgeInsets.symmetric(
                            vertical: AppDimensions.paddingM,
                          ),
                        ),
                        child: Text(
                          "Đóng",
                          style: TextStyle(fontSize: AppDimensions.textSizeL),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(
                  alignment: Alignment.center,
                  height: AppDimensions.size200,
                  child: SizedBox(
                    width: AppDimensions.size24,
                    height: AppDimensions.size24,
                    child: CircularProgressIndicator(strokeWidth: 3.w),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildTrainingCategory(
    String label, {
    bool isPrimary = false,
    bool isEquipment = false,
  }) {
    return Container(
      width: isEquipment ? AppDimensions.size112 : AppDimensions.size104,
      height: AppDimensions.size40,
      margin: EdgeInsets.only(right: AppDimensions.paddingS),
      decoration: BoxDecoration(
        color: isPrimary ? AppColors.bNormal : AppColors.wLightActive,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 250),
        style: TextStyle(
          fontSize: AppDimensions.textSizeM,
          fontWeight: FontWeight.w600,
          color: isPrimary ? AppColors.wLight : AppColors.dark,
        ),
        child: Center(child: Text(label)),
      ),
    );
  }
}
