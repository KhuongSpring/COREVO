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

class TrainingDayDetailScreen extends StatefulWidget {
  final TrainingScheduleResponse schedule;
  final String numberDay;

  const TrainingDayDetailScreen({
    super.key,
    required this.schedule,
    required this.numberDay,
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
          Image.asset(TrainingAssets.trainingDay1, fit: BoxFit.cover),

          Padding(
            padding: const EdgeInsets.only(top: 30, left: 10),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.black,
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.8.sp,
            minChildSize: 0.8.sp,
            maxChildSize: 1.0.sp,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppColors.bgHealthInfor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: AppColors.bNormal,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              widget.numberDay,
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 12.sp),
                            Text(
                              widget.schedule.name,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.sp),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        color: AppColors.bgHealthInfor,
                        width: double.infinity,
                        height: 230.sp,
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
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 15.sp),
                                    Text(
                                      'Thời gian',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 60.sp),
                                Container(
                                  width: 1,
                                  color: AppColors.bNormal,
                                  height: 50,
                                ),
                                SizedBox(width: 60.sp),
                                Column(
                                  children: [
                                    Text(
                                      MappingTrainingResourceHelper.normalizeLocation(
                                            widget.schedule.location,
                                          ) ??
                                          'Mọi nơi',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 15.sp),
                                    Text(
                                      'Địa điểm',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 25.sp),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  TrainingAssets.trainingNoteIcon,
                                  height: 30.sp,
                                  width: 30.sp,
                                ),
                                SizedBox(width: 10.sp),
                                SizedBox(
                                  width: 250.sp,
                                  child: Text(
                                    widget.schedule.exerciseGroups!.note ?? '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 25.sp),
                            Container(
                              width: double.infinity * 0.9,
                              height: 60.sp,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Thời gian nghỉ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '60 giây',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Transform.scale(
                                      scale: 0.8,
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
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 15,
                          ),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.wWhite,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
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

                      SizedBox(height: 80),
                    ],
                  ),
                ),
              );
            },
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
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
                padding: EdgeInsets.symmetric(vertical: 16),
                minimumSize: Size(double.infinity, 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text("Bắt đầu", style: TextStyle(fontSize: 20)),
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
      padding: const EdgeInsets.symmetric(vertical: 6),
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
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.transparent),
          child: Row(
            children: [
              Container(
                height: 60,
                width: 110,
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
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 10.sp),
                    Text(
                      '${result.sets} ${result.sets == '1' ? 'set' : 'sets'} | ${result.repsPerSet ?? result.durationPerSet}',
                      style: const TextStyle(color: AppColors.bNormal),
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
