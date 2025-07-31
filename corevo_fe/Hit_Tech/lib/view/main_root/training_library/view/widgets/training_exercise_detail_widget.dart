import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/model/response/training/training_exercise_response.dart';

import '../../../../../core/constants/app_color.dart';
import '../../../../../service/training_service.dart';
import '../../../../../utils/training_exercise_image_helper.dart';

class TrainingExerciseDetailWidget extends StatefulWidget {
  final TrainingExerciseResponse exercise;

  const TrainingExerciseDetailWidget({super.key, required this.exercise});

  @override
  State<TrainingExerciseDetailWidget> createState() =>
      _TrainingExerciseDetailWidgetState();
}

class _TrainingExerciseDetailWidgetState
    extends State<TrainingExerciseDetailWidget> {
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

    return DraggableScrollableSheet(
      initialChildSize: 0.9.sp,
      minChildSize: 0.52.sp,
      maxChildSize: 0.9.sp,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: _isReady
              ? SingleChildScrollView(
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
                            height: (_imageHeight == 630.0) ? 200.sp : 280.sp,
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
                                const Icon(Icons.image, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
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
}
