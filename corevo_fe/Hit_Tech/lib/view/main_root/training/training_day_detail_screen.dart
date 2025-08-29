import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hit_tech/core/constants/app_assets.dart';
import 'package:hit_tech/model/response/training/training_exercise_preview_response.dart';
import 'package:hit_tech/model/response/training/training_exercise_response.dart';
import 'package:hit_tech/model/response/training/training_schedule_exercise_group_response.dart';
import 'package:hit_tech/model/response/training/training_schedule_exercise_response.dart';
import 'package:hit_tech/model/response/training/training_schedule_response.dart';
import 'package:hit_tech/utils/mapping_training_resource_helper.dart';
import 'package:hit_tech/view/main_root/training/training_day_start_training_screen.dart';
import 'package:hit_tech/view/main_root/training_library/view/widgets/training_library_exercise_detail_widget.dart';

import '../../../../../core/constants/app_color.dart';
import '../../../../../service/training_service.dart';
import '../../../core/constants/app_dimension.dart';

class TrainingDayDetailScreen extends StatefulWidget {
  final TrainingScheduleResponse schedule;
  final String numberDay;
  final String imageBG;

  const TrainingDayDetailScreen({
    super.key,
    required this.schedule,
    required this.numberDay,
    required this.imageBG,
  });

  @override
  State<TrainingDayDetailScreen> createState() =>
      _TrainingDayDetailScreenState();
}

class _TrainingDayDetailScreenState extends State<TrainingDayDetailScreen> {
  bool _showLoading = true;
  bool _isOn = true;

  List<TrainingExercisePreviewResponse> previewExercises = [];
  List<TrainingScheduleExerciseResponse> exercises = [];
  List<String> durations = [];

  @override
  void initState() {
    super.initState();

    _handleGetExercise();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showLoading = false;
        });
      }
    });
  }

  Future<void> _handleGetExercise() async {
    TrainingScheduleExerciseGroupResponse? g = widget.schedule.exerciseGroups;
    List<TrainingScheduleExerciseResponse>? l = g?.exercises;
    exercises = l!;
    for (int i = 0; i < l.length; i++) {
      try {
        final response = await TrainingService.getExerciseById(l[i].exerciseId);

        if (response.status == 'SUCCESS') {
          previewExercises.add(
            TrainingExercisePreviewResponse(
              id: l[i].exerciseId,
              name: response.data['name'],
              imageURL: response.data['imageURL'],
              description: response.data['description'],
              levelName: '',
            ),
          );
          durations.add(l[i].duration);
        }
      } catch (e, stackTrace) {
        print(stackTrace);
        setState(() {
          _showLoading = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Ảnh nền
          Image.asset(widget.imageBG, fit: BoxFit.cover),

          Padding(
            padding: EdgeInsets.only(
              top: AppDimensions.paddingXL,
              left: AppDimensions.spacingSM,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios),
              color: AppColors.dark,
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.7.w,
            minChildSize: 0.7.w,
            maxChildSize: 1.0.w,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.bLight,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppDimensions.borderRadiusLarge),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: AppDimensions.paddingS,
                        ),
                        width: AppDimensions.spacingWidthInfinite,
                        decoration: BoxDecoration(
                          color: AppColors.bNormal,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(
                              AppDimensions.borderRadiusLarge,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              widget.numberDay,
                              style: TextStyle(
                                fontSize: AppDimensions.textSizeXL,
                                fontWeight: FontWeight.bold,
                                color: AppColors.wWhite,
                              ),
                            ),
                            SizedBox(height: AppDimensions.spacingSM),
                            Text(
                              widget.schedule.name,
                              style: TextStyle(
                                fontSize: AppDimensions.textSizeL,
                                color: AppColors.wWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppDimensions.spacingML),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingL,
                        ),
                        color: AppColors.bLight,
                        width: AppDimensions.spacingWidthInfinite,
                        height: AppDimensions.size232,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      widget.schedule.duration ?? '60 phút',
                                      style: TextStyle(
                                        fontSize: AppDimensions.textSizeM,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.dark,
                                      ),
                                    ),
                                    SizedBox(height: AppDimensions.spacingM),
                                    Text(
                                      'Thời gian',
                                      style: TextStyle(
                                        fontSize: AppDimensions.textSizeS,
                                        color: AppColors.dark,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: AppDimensions.spacingGiant),
                                Container(
                                  width: 1.w,
                                  color: AppColors.bNormal,
                                  height: AppDimensions.size48,
                                ),
                                SizedBox(width: AppDimensions.spacingGiant),
                                Column(
                                  children: [
                                    Text(
                                      MappingTrainingResourceHelper.normalizeLocation(
                                            widget.schedule.location,
                                          ) ??
                                          'Mọi nơi',
                                      style: TextStyle(
                                        fontSize: AppDimensions.textSizeM,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.dark,
                                      ),
                                    ),
                                    SizedBox(height: AppDimensions.spacingM),
                                    Text(
                                      'Địa điểm',
                                      style: TextStyle(
                                        fontSize: AppDimensions.textSizeS,
                                        color: AppColors.dark,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: AppDimensions.spacingL),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppAssets.trainingNoteIcon,
                                  height: AppDimensions.iconSizeXXL,
                                  width: AppDimensions.iconSizeXXL,
                                ),
                                SizedBox(width: AppDimensions.spacingS),
                                SizedBox(
                                  width: AppDimensions.size248,
                                  child: Center(
                                    child: Text(
                                      widget.schedule.exerciseGroups!.note ??
                                          '',
                                      style: TextStyle(
                                        fontSize: AppDimensions.textSizeS,
                                        color: AppColors.dark,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppDimensions.spacingL),
                            Container(
                              width: AppDimensions.spacingWidthInfinite * 0.9.w,
                              height: AppDimensions.size64,
                              decoration: BoxDecoration(
                                color: AppColors.wWhite,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadiusLarge,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppDimensions.paddingS,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Thời gian nghỉ',
                                      style: TextStyle(
                                        fontSize: AppDimensions.textSizeM,
                                        color: AppColors.dark,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '30 giây',
                                      style: TextStyle(
                                        fontSize: AppDimensions.textSizeM,
                                        color: AppColors.dark,
                                      ),
                                    ),
                                    Transform.scale(
                                      scale: 0.8.w,
                                      child: Switch(
                                        value: _isOn,
                                        onChanged: (_) {
                                          setState(() {
                                            _isOn = !_isOn;
                                          });
                                        },
                                        activeColor: AppColors.wWhite,
                                        activeTrackColor: AppColors.bNormal,
                                        inactiveThumbColor: Colors.grey,
                                        inactiveTrackColor: Colors.grey[300],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // List bài tập
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacingML,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacingSM,
                            vertical: AppDimensions.paddingM,
                          ),
                          width: AppDimensions.spacingWidthInfinite,
                          decoration: BoxDecoration(
                            color: AppColors.wWhite,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.borderRadiusLarge,
                            ),
                          ),
                          child: Column(
                            children: List.generate(
                              previewExercises.length,
                              (index) => _buildExerciseItem(
                                exercise: previewExercises[index],
                                duration: durations[index],
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: AppDimensions.size80),
                    ],
                  ),
                ),
              );
            },
          ),

          Positioned(
            left: AppDimensions.paddingM,
            right: AppDimensions.paddingM,
            bottom: AppDimensions.paddingL,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrainingDayStartTrainingScreen(
                      schedule: widget.schedule,
                      previewExercises: previewExercises,
                      exercises: exercises,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.bNormal,
                foregroundColor: AppColors.wWhite,
                padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
                minimumSize: Size(
                  AppDimensions.spacingWidthInfinite,
                  AppDimensions.spacingXL,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusSmall,
                  ),
                ),
              ),
              child: Text(
                "Bắt đầu",
                style: TextStyle(fontSize: AppDimensions.textSizeL),
              ),
            ),
          ),
          if (_showLoading)
            Container(
              color: Colors.white.withOpacity(0.8),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildExerciseItem({
    required TrainingExercisePreviewResponse exercise,
    required String duration,
  }) {
    final result = MappingTrainingResourceHelper.parse(duration);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
      child: GestureDetector(
        onTap: () async {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
          try {
            final response = await TrainingService.getExerciseById(exercise.id);

            if (response.status == 'SUCCESS') {
              Navigator.of(context).pop();

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => TrainingLibraryExerciseDetailWidget(
                  exercise: TrainingExerciseResponse.fromJson(response.data),
                ),
              );
            } else {
              Navigator.of(context).pop();
            }
          } catch (e) {
            Navigator.of(context).pop();
          }
        },
        child: Container(
          width: AppDimensions.spacingWidthInfinite,
          decoration: BoxDecoration(color: Colors.transparent),
          child: Row(
            children: [
              Container(
                height: AppDimensions.size64,
                width: AppDimensions.size112,
                color: Colors.grey.shade300,
                child: exercise.imageURL == null
                    ? const Icon(Icons.image, color: Colors.grey)
                    : CachedNetworkImage(
                        imageUrl: exercise.imageURL,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.broken_image, color: Colors.red),
                      ),
              ),
              SizedBox(width: AppDimensions.spacingSM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.dark,
                        fontSize: AppDimensions.textSizeM,
                      ),
                    ),
                    SizedBox(height: AppDimensions.spacingS),
                    Text(
                      '${result.sets} ${result.sets == '1' ? 'set' : 'sets'} | ${result.repsPerSet ?? result.durationPerSet}',
                      style: TextStyle(
                        color: AppColors.bNormal,
                        fontSize: AppDimensions.textSizeS,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
