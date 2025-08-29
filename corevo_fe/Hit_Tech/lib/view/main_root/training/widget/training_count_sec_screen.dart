import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_color.dart';

import '../../../../core/constants/app_dimension.dart';
import '../../../../model/response/exercise_set_progress.dart';
import '../../../../model/response/training/training_exercise_response.dart';
import '../../../../service/training_service.dart';
import '../../../../utils/mapping_training_resource_helper.dart';
import '../../../../utils/training_exercise_image_helper.dart';

enum TimerPhase { work, rest }

class TrainingCountSecScreen extends StatefulWidget {
  final int exerciseId;
  final ExerciseSetProgress exerciseSetProgress;
  final int exerciseIndex;
  final Future<void> Function(
    int exerciseIndex,
    int setIndex,
    bool value,
    int total,
  )
  onSetCompleted;
  final int totalSet;
  final int completedSet;

  const TrainingCountSecScreen({
    super.key,
    required this.exerciseId,
    required this.onSetCompleted,
    required this.exerciseSetProgress,
    required this.exerciseIndex,
    required this.totalSet,
    required this.completedSet,
  });

  @override
  State<TrainingCountSecScreen> createState() => _TrainingCountSecScreenState();
}

class _TrainingCountSecScreenState extends State<TrainingCountSecScreen> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();

  TrainingExerciseResponse? exercise;

  Widget? _imageWidget;
  double? _imageWidth;
  double? _imageHeight;

  bool _isReady = false;
  bool _isMore = false;

  TimerPhase _currentPhase = TimerPhase.work;
  int _workDuration = 45;
  int _restDuration = 30;
  int _remainingSeconds = 45;
  Timer? _timer;

  int _setIndex = 0;

  @override
  void initState() {
    super.initState();
    _handleGetExercise();
    _startTimer();
    _controller.addListener(() {
      if (_controller.size <= 0.3.sp) {
        setState(() {
          _isMore = false;
        });
      }
    });

    for (int i = 0; i < widget.exerciseSetProgress.totalSets; i++) {
      if (widget.exerciseSetProgress.setCompleted[i] == false) {
        setState(() {
          _setIndex = i;
        });
        break;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _handleGetExercise() async {
    try {
      final response = await TrainingService.getExerciseById(widget.exerciseId);

      if (response.status == 'SUCCESS') {
        setState(() {
          exercise = TrainingExerciseResponse.fromJson(response.data);
        });

        _loadAndUseImage();
      } else {
        print('Fail');
      }
    } catch (e) {
      print(e);
    }
  }

  void _loadAndUseImage() async {
    if (exercise?.imageURL == null) return;

    final result = await loadImageWithSize(exercise!.imageURL);

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

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (_) async {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        if (_currentPhase == TimerPhase.rest) {
          _timer?.cancel();
          if (mounted) {
            await widget.onSetCompleted(
              widget.exerciseIndex,
              _setIndex,
              true,
              _workDuration + _restDuration,
            );
            if (mounted) Navigator.pop(context);
            return;
          }
        } else if (_currentPhase == TimerPhase.work) {
          if (mounted) {
            widget.onSetCompleted(
              widget.exerciseIndex,
              _setIndex,
              true,
              _workDuration + _remainingSeconds,
            );
          }
        }
        _switchPhase();
      }
    });
  }

  void _switchPhase() {
    setState(() {
      if (_currentPhase == TimerPhase.work) {
        _currentPhase = TimerPhase.rest;
        _remainingSeconds = _restDuration;
      } else {
        _currentPhase = TimerPhase.work;
        _remainingSeconds = _workDuration;
      }
    });
  }

  void _add20Seconds() {
    setState(() => _remainingSeconds += 20);
  }

  @override
  Widget build(BuildContext context) {
    if (exercise == null) {
      return const Center(child: CircularProgressIndicator());
    }

    List<String> primaryTargetMuscle =
        MappingTrainingResourceHelper.mappingTargetMuscleList(
          exercise!.primaryMuscleIds,
        );
    List<String> secondaryTargetMuscle =
        MappingTrainingResourceHelper.mappingTargetMuscleList(
          exercise!.secondaryMuscleIds,
        );
    List<String> equipments =
        MappingTrainingResourceHelper.mappingEquipmentList(
          exercise!.equipmentIds,
        );

    String? min = exercise!.minRep == 0
        ? '${exercise!.minDuration}'
        : '${exercise!.minRep}';
    String? max = exercise!.maxRep == 0
        ? '${exercise!.maxDuration} secs'
        : '${exercise!.maxRep} reps';

    return Scaffold(
      backgroundColor: AppColors.bNormal,
      body: Stack(
        children: [
          Positioned(
            top: AppDimensions.paddingXL,
            left: AppDimensions.paddingS,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios, color: AppColors.wWhite),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _currentPhase == TimerPhase.work ? 'Tập luyện' : 'Nghỉ ngơi',
                  style: TextStyle(
                    fontSize: AppDimensions.textSizeXL,
                    color: AppColors.wWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppDimensions.spacingML),
                Text(
                  _formatTime(_remainingSeconds),
                  style: TextStyle(
                    fontSize: 54.w,
                    color: AppColors.wWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppDimensions.spacingXXXL),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _currentPhase == TimerPhase.work
                          ? () {}
                          : _add20Seconds,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentPhase == TimerPhase.work
                            ? AppColors.bLightNotActive
                            : AppColors.wWhite,
                        foregroundColor: _currentPhase == TimerPhase.work
                            ? AppColors.wWhite
                            : AppColors.bNormal,
                        padding: EdgeInsets.symmetric(
                          vertical: AppDimensions.paddingS,
                        ),
                        minimumSize: Size(
                          AppDimensions.size104,
                          AppDimensions.size32,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.borderRadiusLarge,
                          ),
                        ),
                      ),
                      child: Text(
                        '+20s',
                        style: TextStyle(
                          fontSize: AppDimensions.textSizeM,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: AppDimensions.spacingML),
                    ElevatedButton(
                      onPressed:
                          (_currentPhase == TimerPhase.work &&
                              _remainingSeconds > 19)
                          ? () {}
                          : () {
                              widget.onSetCompleted(
                                widget.exerciseIndex,
                                _setIndex,
                                true,
                                _workDuration - _remainingSeconds,
                              );

                              Navigator.pop(context);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            (_currentPhase == TimerPhase.work &&
                                _remainingSeconds > 19)
                            ? AppColors.bLightNotActive
                            : AppColors.wWhite,
                        foregroundColor:
                            (_currentPhase == TimerPhase.work &&
                                _remainingSeconds > 19)
                            ? AppColors.wWhite
                            : AppColors.bNormal,
                        padding: EdgeInsets.symmetric(
                          vertical: AppDimensions.paddingS,
                        ),
                        minimumSize: Size(
                          AppDimensions.size104,
                          AppDimensions.size32,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.borderRadiusLarge,
                          ),
                        ),
                      ),
                      child: Text(
                        'Bỏ qua',
                        style: TextStyle(
                          fontSize: AppDimensions.textSizeM,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimensions.size152),
              ],
            ),
          ),
          Positioned(
            bottom: AppDimensions.size288,
            left: AppDimensions.size8,
            child: Text(
              'Tiếp theo ${widget.completedSet}/${widget.totalSet}',
              style: TextStyle(
                color: AppColors.wWhite,
                fontSize: AppDimensions.textSizeM,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Positioned(
            bottom: AppDimensions.size264 + 4.w,
            left: AppDimensions.size8,
            child: Text(
              '${exercise?.name} - Set ${_setIndex + 1}/${widget.exerciseSetProgress.totalSets}',
              style: TextStyle(
                color: AppColors.wWhite,
                fontSize: AppDimensions.textSizeM,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: Duration(microseconds: 300),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              child: (_isMore)
                  ? DraggableScrollableSheet(
                      key: ValueKey('sheet'),
                      controller: _controller,
                      initialChildSize: 0.95.w,
                      minChildSize: 0.3.w,
                      maxChildSize: 0.95.w,
                      builder: (context, scrollController) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacingML,
                            vertical: AppDimensions.paddingL,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.wWhite,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(
                                AppDimensions.borderRadiusLarge,
                              ),
                            ),
                          ),
                          child: _isReady
                              ? Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        bottom: AppDimensions.size72,
                                      ),
                                      child: SingleChildScrollView(
                                        controller: scrollController,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Container(
                                                height: AppDimensions.size4,
                                                width:
                                                    AppDimensions.width * 0.3.w,
                                                decoration: BoxDecoration(
                                                  color: AppColors.bNormal,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        AppDimensions
                                                            .borderRadiusLarge,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: AppDimensions.spacingXL,
                                            ),
                                            Text(
                                              exercise!.name,
                                              style: TextStyle(
                                                fontSize:
                                                    AppDimensions.textSizeXL,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.dark,
                                              ),
                                            ),
                                            SizedBox(
                                              height: AppDimensions.spacingXL,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    (_imageHeight == 630.0)
                                                    ? 0.w
                                                    : AppDimensions.size48,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      AppDimensions
                                                          .borderRadius,
                                                    ),
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                child: Container(
                                                  width: (_imageHeight == 630.0)
                                                      ? AppDimensions.width
                                                      : AppDimensions.width *
                                                            0.8.w,
                                                  height:
                                                      (_imageHeight == 630.0)
                                                      ? AppDimensions.size200
                                                      : AppDimensions.size280,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.wWhite,
                                                    border: Border.all(
                                                      color: AppColors.bNormal,
                                                      width: 3.w,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          AppDimensions
                                                              .borderRadius,
                                                        ),
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
                                            SizedBox(
                                              height: AppDimensions.spacingM,
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Container(
                                                width: AppDimensions.size184,
                                                height: AppDimensions.size48,
                                                decoration: BoxDecoration(
                                                  color: AppColors.bNormal,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        AppDimensions
                                                            .borderRadiusTiny,
                                                      ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '${(exercise!.minSet == exercise!.maxSet) ? exercise!.minSet : '${exercise!.minSet} - ${exercise!.maxSet}'}'
                                                    ' sets | '
                                                    '$min - '
                                                    '$max',
                                                    style: TextStyle(
                                                      fontSize: AppDimensions
                                                          .textSizeS,
                                                      color: AppColors.wWhite,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: AppDimensions.spacingML,
                                            ),
                                            Text(
                                              "GIỚI THIỆU",
                                              style: TextStyle(
                                                fontSize:
                                                    AppDimensions.textSizeM,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.bNormal,
                                              ),
                                            ),
                                            SizedBox(
                                              height: AppDimensions.spacingSM,
                                            ),
                                            Text(
                                              exercise!.description,
                                              style: TextStyle(
                                                fontSize:
                                                    AppDimensions.textSizeM,
                                                color: AppColors.dark,
                                              ),
                                            ),
                                            SizedBox(
                                              height: AppDimensions.spacingXL,
                                            ),
                                            Text(
                                              "NHÓM CƠ TÁC ĐỘNG",
                                              style: TextStyle(
                                                fontSize:
                                                    AppDimensions.textSizeM,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.bNormal,
                                              ),
                                            ),
                                            SizedBox(
                                              height: AppDimensions.spacingSM,
                                            ),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  ...List.generate(
                                                    primaryTargetMuscle.length,
                                                    (index) {
                                                      return _buildTrainingCategory(
                                                        primaryTargetMuscle[index],
                                                        isPrimary: true,
                                                      );
                                                    },
                                                  ),
                                                  ...List.generate(
                                                    secondaryTargetMuscle
                                                        .length,
                                                    (index) {
                                                      return _buildTrainingCategory(
                                                        secondaryTargetMuscle[index],
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: AppDimensions.spacingXL,
                                            ),
                                            Text(
                                              "DỤNG CỤ LUYỆN TẬP",
                                              style: TextStyle(
                                                fontSize:
                                                    AppDimensions.textSizeM,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.bNormal,
                                              ),
                                            ),
                                            SizedBox(
                                              height: AppDimensions.spacingSM,
                                            ),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  ...List.generate(
                                                    equipments.length,
                                                    (index) {
                                                      return _buildTrainingCategory(
                                                        equipments[index],
                                                        isEquipment: true,
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: AppDimensions.spacingXL,
                                            ),
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
                                          setState(() {
                                            _isMore = false;
                                          });
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
                                          style: TextStyle(
                                            fontSize: AppDimensions.spacingML,
                                          ),
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
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3.w,
                                    ),
                                  ),
                                ),
                        );
                      },
                    )
                  : Align(
                      key: ValueKey('static'),
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: AppDimensions.spacingWidthInfinite,
                        decoration: BoxDecoration(
                          color: AppColors.wWhite,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(
                              AppDimensions.borderRadiusLarge,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: (_imageHeight == 630.0)
                              ? AppDimensions.paddingXL
                              : AppDimensions.paddingXXXL,
                          vertical: AppDimensions.paddingXL,
                        ),
                        child: _isReady
                            ? Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.borderRadius,
                                    ),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: Container(
                                      width: (_imageHeight == 630.0)
                                          ? AppDimensions.width
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
                                          const Icon(
                                            Icons.image,
                                            color: Colors.grey,
                                          ),
                                    ),
                                  ),
                                  Positioned(
                                    right: AppDimensions.spacingSM,
                                    top: AppDimensions.spacingSM,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isMore = true;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.bNormal,
                                          shape: BoxShape.circle,
                                        ),
                                        height: AppDimensions.spacingML,
                                        width: AppDimensions.spacingML,
                                        child: Center(
                                          child: Text(
                                            "?",
                                            style: TextStyle(
                                              fontSize:
                                                  AppDimensions.textSizeXS,
                                              color: AppColors.wWhite,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
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
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3.w,
                                  ),
                                ),
                              ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingCategory(
    String label, {
    bool isPrimary = false,
    bool isEquipment = false,
  }) {
    return Container(
      width: isEquipment ? AppDimensions.size112 : AppDimensions.size88,
      height: AppDimensions.size40,
      margin: EdgeInsets.only(right: AppDimensions.paddingS),
      decoration: BoxDecoration(
        color: isPrimary ? AppColors.bNormal : AppColors.bLight,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6.w,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 250),
        style: TextStyle(
          fontSize: AppDimensions.textSizeM,
          fontWeight: FontWeight.w600,
          color: isPrimary ? AppColors.wWhite : AppColors.dark,
        ),
        child: Center(child: Text(label)),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
