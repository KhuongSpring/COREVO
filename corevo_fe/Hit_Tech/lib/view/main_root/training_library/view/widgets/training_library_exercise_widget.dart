import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hit_tech/core/constants/app_assets.dart';
import 'package:hit_tech/model/response/training/training_exercise_preview_response.dart';
import 'package:hit_tech/model/response/training/training_exercise_response.dart';
import 'package:hit_tech/view/main_root/training_library/view/widgets/training_library_exercise_detail_widget.dart';

import '../../../../../core/constants/app_color.dart';
import '../../../../../service/training_service.dart';

class TrainingLibraryExerciseWidget extends StatefulWidget {
  final String primaryMuscleToQuery;
  final String primaryMuscle;

  final String typeToQuery;
  final String type;

  const TrainingLibraryExerciseWidget({
    super.key,
    required this.primaryMuscleToQuery,
    required this.primaryMuscle,
    required this.typeToQuery,
    required this.type,
  });

  @override
  State<TrainingLibraryExerciseWidget> createState() =>
      _TrainingLibraryExerciseWidgetState();
}

class _TrainingLibraryExerciseWidgetState
    extends State<TrainingLibraryExerciseWidget> {
  bool _showLoading = true;

  List<TrainingExercisePreviewResponse> exercises = [];

  @override
  void initState() {
    super.initState();

    if (widget.primaryMuscleToQuery != '') {
      _handleGetTrainingExerciseByTargetMuscle();
    } else {
      _handleGetTrainingExerciseByType();
    }

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showLoading = false;
        });
      }
    });
  }

  Future<void> _handleGetTrainingExerciseByTargetMuscle() async {
    try {
      final response = await TrainingService.getTrainingExerciseByTargetMuscle(
        widget.primaryMuscleToQuery,
        1,
        1000,
      );

      if (response.status == 'SUCCESS') {
        final allExercises = response.data
            .expand(
              (level) => (level.exercises as List<dynamic>).map(
                (e) => e as TrainingExercisePreviewResponse,
              ),
            )
            .toList();

        setState(() {
          exercises = allExercises;
        });

        return;
      }
    } catch (e, stackTrace) {
      print(stackTrace);
      setState(() {
        _showLoading = true;
      });
    }
  }

  Future<void> _handleGetTrainingExerciseByType() async {
    try {
      final response = await TrainingService.getTrainingExerciseByType(
        widget.typeToQuery,
        1,
        1000,
      );

      if (response.status == 'SUCCESS') {
        final allExercises = response.data
            .expand(
              (level) => (level.exercises as List<dynamic>).map(
                (e) => e as TrainingExercisePreviewResponse,
              ),
            )
            .toList();

        setState(() {
          exercises = allExercises;
        });

        return;
      }
    } catch (e, stackTrace) {
      print(stackTrace);
      setState(() {
        _showLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Ảnh nền
          Image.asset(TrainingAssets.targetMuscleDetail1, fit: BoxFit.cover),

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
            initialChildSize: 0.75.sp,
            minChildSize: 0.75.sp,
            maxChildSize: 1.0.sp,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      Text(
                        'BÀI TẬP ${widget.primaryMuscle}',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 12.sp),
                      Text(
                        convertDescriptionForTargetMuscle(
                          (widget.primaryMuscle == '')
                              ? widget.type
                              : widget.primaryMuscle,
                        ),
                        style: TextStyle(height: 1.5, color: Colors.black),
                      ),
                      SizedBox(height: 20.sp),
                      const Divider(color: AppColors.bNormal),
                      SizedBox(height: 12.sp),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Các bài tập (${exercises.length})',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // List bài tập
                      ...List.generate(exercises.length, (index) {
                        return _buildExerciseItem(exercise: exercises[index]);
                      }),
                    ],
                  ),
                ),
              );
            },
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
                      exercise.levelName,
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

  String convertDescriptionForTargetMuscle(String targetMuscleName) {
    const mapping = {
      "NGỰC":
          "Không cần bắt đầu với sức mạnh - chỉ cần bắt đầu. Tập ngực là cách đơn giản để xây nền tảng cho một cơ thể khỏe và vững chắc.\nNhóm bài tập này tác động đến ngực trên, giữa và dưới, đồng thời hỗ trợ vai và tay sau. Các bài phổ biến gồm chống đẩy, đẩy tạ, ép ngực và kéo cáp.",
      "LƯNG":
          "Sức mạnh đến từ phía sau. Tập lưng giúp cải thiện tư thế và mở rộng vóc dáng toàn diện.\nNhóm bài tập này tác động đến cơ xô, lưng giữa và lưng dưới. Các bài phổ biến gồm kéo xà, deadlift, chèo tạ và kéo cáp.",
      "VAI":
          "Một bờ vai vững chãi tạo nên thân hình cân đối và sức mạnh toàn thân.\nNhóm bài tập này tác động đến cơ vai trước, giữa và sau. Gồm đẩy vai, nâng tạ bên, kéo dây và flye.",
      "TAY TRƯỚC":
          "Lực kéo mạnh bắt đầu từ tay trước. Biceps không chỉ để đẹp - mà còn để khỏe.\nNhóm bài tập này tác động đến cơ tay trước, gồm các bài như curl tạ, curl dây và chin-up.",
      "TAY SAU":
          "Tay sau chiếm phần lớn khối lượng cánh tay - đừng bỏ qua nếu bạn muốn tay săn chắc và khỏe hơn.\nNhóm bài tập này tác động đến triceps với các bài dips, close-grip push-up và pushdown.",
      "BỤNG":
          "Cơ bụng khỏe là trung tâm của sự ổn định và chuyển động.\nNhóm bài tập này tác động đến bụng trên, giữa, dưới và cơ xiên. Bao gồm crunch, plank, leg raise và mountain climber.",
      "MÔNG":
          "Một cơ mông mạnh không chỉ đẹp mà còn giúp chạy nhanh, nhảy cao và đứng vững.\nNhóm bài tập này tập trung vào cơ mông lớn với các bài như hip thrust, glute bridge và squat.",
      "ĐÙI TRƯỚC":
          "Sức mạnh thân dưới bắt đầu từ đùi trước - nhóm cơ chính khi đứng lên, chạy, bật nhảy.\nNhóm bài tập này tác động vào quads với squat, lunge, leg extension và step-up.",
      "ĐÙI SAU":
          "Muốn di chuyển linh hoạt và giảm chấn thương? Đừng bỏ qua đùi sau.\nNhóm bài tập này tập trung vào hamstrings với các bài như deadlift, leg curl và glute kickback.",
      "CARDIO":
          "Trái tim khỏe là nền tảng cho mọi mục tiêu thể hình.\nNhóm bài tập này giúp cải thiện sức bền và đốt mỡ hiệu quả. Bao gồm chạy bộ, đạp xe, nhảy dây và leo cầu thang.",
      "YOGA":
          "Không chỉ là thư giãn - yoga là nghệ thuật kiểm soát hơi thở, cơ thể và tâm trí.\nNhóm bài tập này tập trung vào kéo giãn, giữ thăng bằng và phục hồi thông qua các tư thế và kỹ thuật thở.",
      "CALISTHENIC":
          "Sức mạnh thật sự đến từ khả năng làm chủ trọng lượng cơ thể.\nNhóm bài tập này bao gồm chống đẩy, xà đơn, plank, squat và các chuyển động liên hoàn không cần thiết bị.",
    };

    return mapping[targetMuscleName] ?? targetMuscleName;
  }
}
