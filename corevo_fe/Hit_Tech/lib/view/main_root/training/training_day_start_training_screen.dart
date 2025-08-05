import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/model/response/training/training_schedule_response.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_color.dart';
import '../../../model/response/training/training_exercise_preview_response.dart';
import '../../../model/response/training/training_exercise_response.dart';
import '../../../service/training_service.dart';
import '../../../utils/mapping_training_resource_helper.dart';
import '../training_library/view/widgets/training_library_exercise_detail_widget.dart';

class TrainingDayStartTrainingScreen extends StatefulWidget {
  final TrainingScheduleResponse schedule;
  final List<TrainingExercisePreviewResponse> exercises;

  TrainingDayStartTrainingScreen({
    super.key,
    required this.schedule,
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
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios),
        title: Center(child: Text(widget.schedule.name)),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 10),
            child: Text(
              '00:00',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              TrainingAssets.mainBackground,
              fit: BoxFit.cover,
            ),
          ),

          ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: widget.exercises.length,
            itemBuilder: (context, index) {
              final exercise = widget.exercises[index];
              return _buildExerciseItem(
                exercise: exercise,
                // imageUrl: exercise.imageURL, nếu cần ảnh
              );
            },
          ),

        ],
      ),
    );
  }

  Widget _buildExerciseItem({
    required TrainingExercisePreviewResponse exercise,
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
                      'dddd',
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
