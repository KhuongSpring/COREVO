import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/model/response/training/training_schedule_exercise_response.dart';
import 'package:hit_tech/model/response/training/training_schedule_response.dart';
import 'package:hit_tech/view/main_root/training/widget/training_count_sec_screen.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_color.dart';
import '../../../model/response/training/training_exercise_preview_response.dart';
import '../../../model/response/training/training_exercise_response.dart';
import '../../../service/training_service.dart';
import '../../../utils/mapping_training_resource_helper.dart';
import '../training_library/view/widgets/training_library_exercise_detail_widget.dart';

class TrainingDayStartTrainingScreen extends StatefulWidget {
  final TrainingScheduleResponse schedule;
  final List<TrainingExercisePreviewResponse> previewExercises;
  final List<TrainingScheduleExerciseResponse> exercises;

  TrainingDayStartTrainingScreen({
    super.key,
    required this.schedule,
    required this.previewExercises,
    required this.exercises,
  });

  @override
  State<TrainingDayStartTrainingScreen> createState() =>
      _TrainingDayStartTrainingScreenState();
}

class _TrainingDayStartTrainingScreenState
    extends State<TrainingDayStartTrainingScreen> {
  @override
  Widget build(BuildContext context) {
    int currentIndex = 0;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              TrainingAssets.mainBackground,
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios),
                      ),
                      Text(
                        widget.schedule.name,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '00:00',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: widget.previewExercises.length,
                    itemBuilder: (context, index) {
                      final previewExercise = widget.previewExercises[index];
                      final exercise = widget.exercises[index];
                      return _buildExerciseItem(
                        previewExercise: previewExercise,
                        exercise: exercise,
                        // imageUrl: exercise.imageURL, nếu cần ảnh
                      );
                    },
                  ),
                ),
              ],
            ),
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
                    builder: (context) => TrainingCountSecScreen(
                      exerciseId: widget.previewExercises[currentIndex].id,
                    )
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
              child: Text("Tiếp theo", style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseItem({
    required TrainingExercisePreviewResponse previewExercise,
    required TrainingScheduleExerciseResponse exercise,
  }) {
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
            final response = await TrainingService.getExerciseById(
              previewExercise.id,
            );

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
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          width: double.infinity,
          height: 100.sp,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Container(
                height: 60,
                width: 110,
                color: Colors.grey.shade300,
                child: previewExercise.imageURL == null
                    ? const Icon(Icons.image, color: Colors.grey)
                    : CachedNetworkImage(
                        imageUrl: previewExercise.imageURL,
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
                    SizedBox(height: 12.sp),
                    Text(
                      previewExercise.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 8.sp),
                    Text(
                      '0/${MappingTrainingResourceHelper.getSetOfExercise(exercise.duration)} hoàn thành',
                      style: const TextStyle(color: AppColors.bNormal),
                    ),
                  ],
                ),
              ),
              IconButton(onPressed: (){}, icon: Icon(Icons.keyboard_arrow_down))
            ],
          ),
        ),
      ),
    );
  }
}
