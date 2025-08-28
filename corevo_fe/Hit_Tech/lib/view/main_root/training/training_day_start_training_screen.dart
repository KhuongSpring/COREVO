import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/model/response/exercise_set_progress.dart';
import 'package:hit_tech/model/response/training/training_schedule_exercise_response.dart';
import 'package:hit_tech/model/response/training/training_schedule_response.dart';
import 'package:hit_tech/view/main_root/training/widget/active_dialog.dart';
import 'package:hit_tech/view/main_root/training/widget/training_count_sec_screen.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/constants/app_dimension.dart';
import '../../../model/response/training/training_exercise_preview_response.dart';
import '../../../service/training_service.dart';
import '../../../utils/change_notifier.dart';
import '../../../utils/mapping_training_resource_helper.dart';

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
            child: Image.asset(AppAssets.mainBackground, fit: BoxFit.cover),
          ),

          Column(
            children: [
              SizedBox(height: AppDimensions.spacingXL),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingS,
                ),
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
                        fontSize: AppDimensions.textSizeM,
                        color: AppColors.dark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      formatSecondsToTime(totalTime),
                      style: TextStyle(
                        fontSize: AppDimensions.textSizeM,
                        color: AppColors.dark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(AppDimensions.paddingL),
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
              SizedBox(height: AppDimensions.size80),
            ],
          ),
          Positioned(
            left: AppDimensions.paddingM,
            right: AppDimensions.paddingM,
            bottom: AppDimensions.paddingL,
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
                              await _handleCompleteExercise(
                                exerciseProgressList[exerciseIndex].exerciseId,
                              );

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
                padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
                minimumSize: Size(
                  AppDimensions.spacingWidthInfinite,
                  AppDimensions.paddingXL,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusSmall,
                  ),
                ),
              ),
              child: Text(
                "Tiếp theo",
                style: TextStyle(fontSize: AppDimensions.textSizeL),
              ),
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
      padding: EdgeInsets.symmetric(vertical: AppDimensions.size4),
      child: GestureDetector(
        onTap: onToggleExpand,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.size4,
            vertical: AppDimensions.paddingS,
          ),
          width: AppDimensions.spacingWidthInfinite,
          decoration: BoxDecoration(
            color: AppColors.wWhite,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: AppDimensions.size64,
                    width: AppDimensions.size112,
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
                  SizedBox(width: AppDimensions.spacingSM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: AppDimensions.spacingSM),
                        Text(
                          previewExercise.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.dark,
                            fontSize: AppDimensions.textSizeM,
                          ),
                        ),
                        SizedBox(height: AppDimensions.spacingS),
                        Text(
                          '$completedCount/$totalSet hoàn thành',
                          style: TextStyle(
                            color: AppColors.bNormal,
                            fontSize: AppDimensions.textSizeS,
                          ),
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
      padding: EdgeInsets.only(
        left: AppDimensions.size40,
        right: AppDimensions.spacingML,
        top: AppDimensions.spacingML,
      ),
      color: AppColors.wWhite,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: AppDimensions.paddingS),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Set',
                  style: TextStyle(
                    color: AppColors.dark,
                    fontSize: AppDimensions.textSizeS,
                  ),
                ),
                Text(
                  'Rep / Thời gian',
                  style: TextStyle(
                    color: AppColors.dark,
                    fontSize: AppDimensions.textSizeS,
                  ),
                ),
                Text(
                  '',
                  style: TextStyle(
                    color: AppColors.dark,
                    fontSize: AppDimensions.textSizeS,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppDimensions.spacingS),
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
        padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
        margin: EdgeInsets.only(bottom: AppDimensions.paddingS),
        decoration: BoxDecoration(
          color: isCompleted ? AppColors.bNormalActive : AppColors.wWhite,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: AppDimensions.paddingM,
                right: AppDimensions.paddingXXL,
              ),
              child: Text(
                '${setIndex + 1}',
                style: TextStyle(
                  fontSize: AppDimensions.textSizeS,
                  color: isCompleted ? AppColors.wWhite : AppColors.dark,
                ),
              ),
            ),
            Container(
              height: AppDimensions.size24,
              width: AppDimensions.size104,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.wWhite : Color(0xffDADADA),
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusSmall,
                ),
              ),
              child: Center(
                child: Text(
                  MappingTrainingResourceHelper.getRepOrSecOfExercise(
                    exercise.duration,
                  ),
                  style: TextStyle(
                    fontSize: AppDimensions.textSizeS,
                    color: AppColors.dark,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: AppDimensions.paddingM),
              child: Image.asset(
                isCompleted ? AppAssets.tickActive : AppAssets.tickNonActive,
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
