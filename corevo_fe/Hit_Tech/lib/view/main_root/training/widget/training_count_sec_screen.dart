import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_color.dart';

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
  final Future<void> Function(int exerciseIndex, int setIndex, bool value, int total)
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
          if (mounted){
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
    double screenWidth = MediaQuery.of(context).size.width.sp;

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
            top: 30,
            left: 10,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
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
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.sp),
                Text(
                  _formatTime(_remainingSeconds),
                  style: TextStyle(
                    fontSize: 54,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 50.sp),
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
                        padding: EdgeInsets.symmetric(vertical: 10),
                        minimumSize: Size(100, 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        '+20s',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 20.sp),
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
                                _workDuration - _remainingSeconds
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
                        padding: EdgeInsets.symmetric(vertical: 10),
                        minimumSize: Size(100, 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        'Bỏ qua',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 150.sp),
              ],
            ),
          ),
          Positioned(
            bottom: 290,
            left: 10,
            child: Text(
              'Tiếp theo ${widget.completedSet}/${widget.totalSet}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Positioned(
            bottom: 270,
            left: 10,
            child: Text(
              '${exercise?.name} - Set ${_setIndex + 1}/${widget.exerciseSetProgress.totalSets}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
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
                      initialChildSize: 0.95.sp,
                      minChildSize: 0.3.sp,
                      maxChildSize: 0.95.sp,
                      builder: (context, scrollController) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 24,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          child: _isReady
                              ? Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 70),
                                      child: SingleChildScrollView(
                                        controller: scrollController,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Container(
                                                height: 4,
                                                width: screenWidth * 0.3.sp,
                                                decoration: BoxDecoration(
                                                  color: AppColors.bNormal,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        24.sp,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 30.sp),
                                            Text(
                                              exercise!.name,
                                              style: TextStyle(
                                                fontSize: 24.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(height: 30.sp),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    (_imageHeight == 630.0)
                                                    ? 0
                                                    : 50.sp,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      16.sp,
                                                    ),
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                child: Container(
                                                  width: (_imageHeight == 630.0)
                                                      ? screenWidth.sp
                                                      : screenWidth * 0.8.sp,
                                                  height:
                                                      (_imageHeight == 630.0)
                                                      ? 200.sp
                                                      : 280.sp,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: AppColors.bNormal,
                                                      width: 3,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16.sp,
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
                                            SizedBox(height: 15.sp),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Container(
                                                width: 180,
                                                height: 45,
                                                decoration: BoxDecoration(
                                                  color: AppColors.bNormal,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        5.sp,
                                                      ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '${(exercise!.minSet == exercise!.maxSet) ? exercise!.minSet : '${exercise!.minSet} - ${exercise!.maxSet}'}'
                                                    ' sets | '
                                                    '$min - '
                                                    '$max',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: AppColors.wWhite,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                              exercise!.description,
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
                                          setState(() {
                                            _isMore = false;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.bNormal,
                                          foregroundColor: AppColors.wWhite,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                        ),
                                        child: Text(
                                          "Đóng",
                                          style: TextStyle(fontSize: 20),
                                        ),
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
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
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
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: (_imageHeight == 630.0) ? 30.sp : 50.sp,
                          vertical: 30.sp,
                        ),
                        child: _isReady
                            ? Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16.sp),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: Container(
                                      width: (_imageHeight == 630.0)
                                          ? screenWidth.sp
                                          : screenWidth * 0.8.sp,
                                      height: (_imageHeight == 630.0)
                                          ? 200.sp
                                          : 280.sp,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: AppColors.bNormal,
                                          width: 3,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          16.sp,
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
                                    right: 12,
                                    top: 12,
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
                                        height: 20.sp,
                                        width: 20.sp,
                                        child: Center(
                                          child: Text(
                                            "?",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
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
                                height: 200,
                                child: const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
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

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
