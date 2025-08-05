import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/model/response/training/training_exercise_response.dart';
import 'package:hit_tech/utils/mapping_training_resource_helper.dart';

import '../../../../../core/constants/app_color.dart';
import '../../../../../utils/training_exercise_image_helper.dart';

class TrainingLibraryExerciseDetailWidget extends StatefulWidget {
  final TrainingExerciseResponse exercise;

  const TrainingLibraryExerciseDetailWidget({super.key, required this.exercise});

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
      if (_controller.size <= 0.5.sp) {
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
    double screenWidth = MediaQuery.of(context).size.width.sp;

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
      initialChildSize: 0.9.sp,
      minChildSize: 0.52.sp,
      maxChildSize: 1.0.sp,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: _isReady
              ? Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 70),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                height: 4,
                                width: screenWidth * 0.3.sp,
                                decoration: BoxDecoration(
                                  color: AppColors.bNormal,
                                  borderRadius: BorderRadius.circular(24.sp),
                                ),
                              ),
                            ),
                            SizedBox(height: 30.sp),
                            Text(
                              exerciseResponse.name,
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 30.sp),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: (_imageHeight == 630.0) ? 0 : 50.sp,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.sp),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Container(
                                  width: (_imageHeight == 630.0)
                                      ? screenWidth * 0.9.sp
                                      : screenWidth * 0.7.sp,
                                  height: (_imageHeight == 630.0)
                                      ? 200.sp
                                      : 280.sp,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: AppColors.bNormal,
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(16.sp),
                                  ),
                                  child:
                                      _imageWidget ??
                                      const Icon(
                                        Icons.image,
                                        color: Colors.grey,
                                      ),
                                ),
                              ),
                            ),
                            SizedBox(height: 15.sp),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                width: 180,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: AppColors.bNormal,
                                  borderRadius: BorderRadius.circular(5.sp),
                                ),
                                child: Center(
                                  child: Text(
                                    '${(exerciseResponse.minSet == exerciseResponse.maxSet) ? exerciseResponse.minSet : '${exerciseResponse.minSet} - ${exerciseResponse.maxSet}'}'
                                    ' sets | '
                                    '$min - '
                                    '$max',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.wWhite,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.sp),
                            Text(
                              "GIỚI THIỆU",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.bNormal,
                              ),
                            ),
                            SizedBox(height: 12.sp),
                            Text(
                              exerciseResponse.description,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 30.sp),
                            Text(
                              "NHÓM CƠ TÁC ĐỘNG",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.bNormal,
                              ),
                            ),
                            SizedBox(height: 12.sp),
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
                            SizedBox(height: 30.sp),
                            Text(
                              "DỤNG CỤ LUYỆN TẬP",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.bNormal,
                              ),
                            ),
                            SizedBox(height: 12.sp),
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
                            SizedBox(height: 30.sp),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.bNormal,
                          foregroundColor: AppColors.wWhite,
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text("Đóng", style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ],
                )
              : Container(
                  alignment: Alignment.center,
                  height: 200,
                  child: const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 3),
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
      width: isEquipment ? 110 : 90,
      height: 40,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: isPrimary
            ? AppColors.buttonBGBottomGenderfocus
            : AppColors.bgHealthInfor,
        borderRadius: BorderRadius.circular(10),
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
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isPrimary ? Colors.white : Colors.black,
        ),
        child: Center(child: Text(label)),
      ),
    );
  }
}
