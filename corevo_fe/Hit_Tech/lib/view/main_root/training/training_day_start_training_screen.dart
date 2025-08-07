import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/model/response/exercise_set_progress.dart';
import 'package:hit_tech/model/response/training/training_schedule_exercise_response.dart';
import 'package:hit_tech/model/response/training/training_schedule_response.dart';
import 'package:hit_tech/view/main_root/training/widget/active_dialog.dart';
import 'package:hit_tech/view/main_root/training/widget/training_count_sec_screen.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_color.dart';
import '../../../model/response/training/training_exercise_preview_response.dart';
import '../../../model/response/training/training_exercise_response.dart';
import '../../../service/training_service.dart';
import '../../../utils/change_notifier.dart';
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
  late List<bool> _isExpandedList;
  int currentIndex = 0;
  int totalSet = 0;
  int completedSet = 0;
  int totalTime = 0;

  List<ExerciseSetProgress> exerciseProgressList = [];
  Map<String, dynamic> completions = {};

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _isExpandedList = List.generate(widget.exercises.length, (_) => false);
    _handleTrainingDailyProgress();

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
      _handleGetSetInfor();
    });
  }

  Future<void> _handleTrainingDailyProgress() async {
    try {
      final response = await TrainingService.getDailyProgress();

      if (response.status == 'SUCCESS') {
        final Map<String, dynamic> fetchedCompletions =
            response.data['completions'];

        final List<ExerciseSetProgress> builtProgressList =
            buildExerciseProgressList(widget.exercises, fetchedCompletions);

        setState(() {
          completions = fetchedCompletions;
          exerciseProgressList = builtProgressList;
        });
      }
    } catch (e, stackTrace) {
      print(stackTrace);
    }
  }

  Future<void> _handleCompleteExercise(int id) async {
    try {
      final response = await TrainingService.completeExercise(id);

      if (response.status == 'SUCCESS') {}
    } catch (e, stackTrace) {
      print(stackTrace);
    }
  }

  List<ExerciseSetProgress> buildExerciseProgressList(
    List<TrainingScheduleExerciseResponse> exercises,
    Map<String, dynamic> completions,
  ) {
    return exercises.map((exercise) {
      final parts = exercise.duration.split('X');
      int setCount = 1;
      if (parts.isNotEmpty) {
        final match = RegExp(r'\d+').firstMatch(parts[0]);
        if (match != null) {
          setCount = int.parse(match.group(0)!);
        }
      }

      final isExerciseCompleted = completions['${exercise.exerciseId}'] == true;

      return ExerciseSetProgress(
        exerciseId: exercise.exerciseId,
        totalSets: setCount,
      )..setCompleted = List.filled(setCount, isExerciseCompleted);
    }).toList();
  }

  void _handleGetSetInfor() {
    int t = 0;
    for (int i = 0; i < widget.previewExercises.length; i++) {
      t += exerciseProgressList[i].totalSets;
    }

    setState(() {
      totalSet = t;
    });
  }

  int _getCompletedSet() {
    int res = 0;
    for (int i = 0; i < widget.previewExercises.length; i++) {
      for (int j = 0; j < exerciseProgressList[i].setCompleted.length; j++) {
        res += exerciseProgressList[i].setCompleted[j] == true ? 1 : 0;
      }
    }

    return res;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
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
              SizedBox(height: 30.sp),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        ActiveDialog().showPauseDialog(context, () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
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
                      formatSecondsToTime(totalTime),
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
                    final completedCount = exerciseProgressList[index]
                        .setCompleted
                        .where((c) => c)
                        .length;

                    return _buildExerciseItem(
                      previewExercise: previewExercise,
                      exercise: exercise,
                      isExpanded: _isExpandedList[index],
                      onToggleExpand: () {
                        setState(() {
                          _isExpandedList[index] = !_isExpandedList[index];
                        });
                      },
                      exerciseIndex: index,
                      completedCount: completedCount,
                    );
                  },
                ),
              ),
              SizedBox(height: 40.sp),
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: ElevatedButton(
              onPressed: () {
                final currentProgress = exerciseProgressList[currentIndex];

                bool isCompleted = currentProgress.setCompleted.every(
                  (set) => set,
                );

                int nextIndex = currentIndex;

                if (isCompleted) {
                  for (
                    int i = currentIndex + 1;
                    i < exerciseProgressList.length;
                    i++
                  ) {
                    if (!exerciseProgressList[i].setCompleted.every(
                      (set) => set,
                    )) {
                      nextIndex = i;
                      break;
                    }
                  }
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrainingCountSecScreen(
                      exerciseId: widget.previewExercises[nextIndex].id,
                      onSetCompleted:
                          (
                            int exerciseIndex,
                            int setIndex,
                            bool value,
                            int total,
                          ) async {
                            if (setIndex ==
                                exerciseProgressList[exerciseIndex].totalSets -
                                    1) {
                              int exerciseId =
                                  exerciseProgressList[exerciseIndex]
                                      .exerciseId;

                              await _handleCompleteExercise(exerciseId);

                              Provider.of<TrainingProgressNotifier>(
                                context,
                                listen: false,
                              ).markNeedsRefresh();
                            }

                            setState(() {
                              exerciseProgressList[exerciseIndex]
                                      .setCompleted[setIndex] =
                                  value;
                              totalTime += total;
                            });
                          },
                      exerciseSetProgress: exerciseProgressList[nextIndex],
                      exerciseIndex: nextIndex,
                      totalSet: totalSet,
                      completedSet: _getCompletedSet(),
                    ),
                  ),
                );

                setState(() {
                  currentIndex = nextIndex;
                });
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
    required bool isExpanded,
    required VoidCallback onToggleExpand,
    required int exerciseIndex,
    required int completedCount,
  }) {
    final totalSet = exerciseProgressList[exerciseIndex].totalSets;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: onToggleExpand,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Row(
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
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.broken_image,
                              color: Colors.red,
                            ),
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
                          '$completedCount/$totalSet hoàn thành',
                          style: const TextStyle(color: AppColors.bNormal),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ],
              ),
              if (isExpanded)
                _buildExpandedContent(exercise, context, exerciseIndex),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedContent(
    TrainingScheduleExerciseResponse exercise,
    BuildContext context,
    int exerciseIndex,
  ) {
    return Container(
      padding: const EdgeInsets.only(left: 40, right: 20, top: 20),
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Set',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                Text(
                  'Rep / Thời gian',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                Text('', style: TextStyle(color: Colors.black, fontSize: 14)),
              ],
            ),
          ),
          SizedBox(height: 10.sp),
          _buildChildItem(context, exercise, exerciseIndex),
        ],
      ),
    );
  }

  Widget _buildChildItem(
    BuildContext context,
    TrainingScheduleExerciseResponse exercise,
    int exerciseIndex,
  ) {
    final setCount = exerciseProgressList[exerciseIndex].totalSets;

    return Column(
      children: List.generate(setCount, (setIndex) {
        return _buildContainer(exercise, exerciseIndex, setIndex);
      }),
    );
  }

  Widget _buildContainer(
    TrainingScheduleExerciseResponse exercise,
    int exerciseIndex,
    int setIndex,
  ) {
    final isCompleted =
        exerciseProgressList[exerciseIndex].setCompleted[setIndex];

    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: isCompleted ? AppColors.bNormalActive : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 40),
              child: Text(
                '${setIndex + 1}',
                style: TextStyle(
                  fontSize: 14,
                  color: isCompleted ? Colors.white : Colors.black,
                ),
              ),
            ),
            Container(
              height: 25,
              width: 100,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.white : Color(0xffDADADA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  MappingTrainingResourceHelper.getRepOrSecOfExercise(
                    exercise.duration,
                  ),
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Image.asset(
                isCompleted
                    ? TrainingAssets.tickActive
                    : TrainingAssets.tickNonActive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String formatSecondsToTime(int totalSeconds) {
  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;

  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}
