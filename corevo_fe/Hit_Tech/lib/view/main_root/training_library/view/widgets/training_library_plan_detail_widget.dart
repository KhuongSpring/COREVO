import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hit_tech/core/constants/app_assets.dart';
import 'package:hit_tech/model/response/training/training_exercise_preview_response.dart';
import 'package:hit_tech/model/response/training/training_exercise_response.dart';
import 'package:hit_tech/model/response/training/training_plan_response.dart';
import 'package:hit_tech/model/response/training/training_schedule_response.dart';
import 'package:hit_tech/utils/mapping_training_resource_helper.dart';
import 'package:hit_tech/view/main_root/training_library/view/widgets/training_library_exercise_detail_widget.dart';

import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_dimension.dart';
import '../../../../../model/response/training/training_schedule_exercise_group_response.dart';
import '../../../../../model/response/training/training_schedule_exercise_response.dart';
import '../../../../../service/training_service.dart';

class TrainingLibraryPlanDetailWidget extends StatefulWidget {
  final TrainingPlanResponse plan;

  const TrainingLibraryPlanDetailWidget({super.key, required this.plan});

  @override
  State<TrainingLibraryPlanDetailWidget> createState() =>
      _TrainingLibraryPlanDetailWidgetState();
}

class _TrainingLibraryPlanDetailWidgetState
    extends State<TrainingLibraryPlanDetailWidget> {
  bool _showLoading = true;

  List<String> categoryPlan = [];
  List<TrainingExercisePreviewResponse> previewExercises = [];

  @override
  void initState() {
    super.initState();

    categoryPlan.add(widget.plan.type);
    categoryPlan.addAll(
      MappingTrainingResourceHelper.mappingLevelList(widget.plan.levelIds),
    );

    _handleGetPreviewExercise();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showLoading = false;
        });
      }
    });
  }

  Future<void> _handleGetPreviewExercise() async {
    try {
      final response = await TrainingService.getTrainingScheduleById(
        widget.plan.id,
      );

      if (response.status == 'SUCCESS') {
        List<TrainingScheduleResponse> listSchedule = response.days;
        for (int i = 0; i < listSchedule.length; i++) {
          TrainingScheduleExerciseGroupResponse? g =
              listSchedule[i].exerciseGroups;
          List<TrainingScheduleExerciseResponse>? l = g?.exercises;
          for (int i = 0; i < l!.length; i++) {
            try {
              final response = await TrainingService.getExerciseById(
                l[i].exerciseId,
              );

              if (response.status == 'SUCCESS') {
                final newId = l[i].exerciseId;

                final isDuplicate = previewExercises.any((e) => e.id == newId);

                if (!isDuplicate) {
                  final result = MappingTrainingResourceHelper.parse(
                    l[i].duration,
                  );
                  previewExercises.add(
                    TrainingExercisePreviewResponse(
                      id: newId,
                      name: response.data['name'],
                      imageURL: response.data['imageURL'],
                      description: response.data['description'],
                      levelName:
                          '${result.sets} sets | ${result.repsPerSet ?? result.durationPerSet}',
                    ),
                  );
                }
              }
            } catch (e, stackTrace) {}
          }
        }
        setState(() {
          _showLoading = false;
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(AppAssets.trainingPlan1, fit: BoxFit.cover),
          ),

          Padding(
            padding: EdgeInsets.only(
              top: AppDimensions.paddingXL,
              left: AppDimensions.paddingS,
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
            initialChildSize: 0.8.w,
            minChildSize: 0.8.w,
            maxChildSize: 1.0.w,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingML,
                  vertical: AppDimensions.paddingL,
                ),
                decoration: BoxDecoration(
                  color: AppColors.wWhite,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppDimensions.borderRadiusLarge),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      Text(
                        '${MappingTrainingResourceHelper.mappingGoalToVietnamese(widget.plan.goals)} - ${widget.plan.name}',
                        style: TextStyle(
                          fontSize: AppDimensions.textSizeL,
                          fontWeight: FontWeight.bold,
                          color: AppColors.dark,
                        ),
                      ),
                      SizedBox(height: AppDimensions.spacingSM),
                      Text(
                        generateDesAndAim(widget.plan.name),
                        style: TextStyle(height: 1.5.w, color: AppColors.dark),
                      ),
                      SizedBox(height: AppDimensions.spacingSM),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: categoryPlan
                                .map(
                                  (label) => Padding(
                                    padding: EdgeInsets.only(
                                      right: AppDimensions.paddingS,
                                    ),
                                    child: _buildCategoryPlan(label),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: AppDimensions.spacingSM),
                      const Divider(color: AppColors.bNormal),
                      SizedBox(height: AppDimensions.spacingSM),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Các bài tập (${previewExercises.length})',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppDimensions.textSizeM,
                            color: AppColors.dark,
                          ),
                        ),
                      ),
                      SizedBox(height: AppDimensions.spacingSM),

                      // List bài tập
                      ...List.generate(previewExercises.length, (index) {
                        return _buildExerciseItem(
                          exercise: previewExercises[index],
                        );
                      }),

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
            bottom: AppDimensions.paddingM,
            child: ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => TrainingDayStartTrainingScreen(
                //       schedule: widget.schedule,
                //       previewExercises: previewExercises,
                //       exercises: exercises,
                //     ),
                //   ),
                // );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.bNormal,
                foregroundColor: AppColors.wWhite,
                padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
                minimumSize: Size(
                  AppDimensions.spacingWidthInfinite,
                  AppDimensions.size32,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusSmall,
                  ),
                ),
              ),
              child: Text(
                "Bắt đầu",
                style: TextStyle(
                  fontSize: AppDimensions.textSizeL,
                  color: AppColors.wWhite,
                ),
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

  Widget _buildCategoryPlan(String label) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingS,
        vertical: AppDimensions.paddingS,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgHealthInfor,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: AppDimensions.textSizeXS,
          fontWeight: FontWeight.w500,
          color: AppColors.dark,
        ),
      ),
    );
  }

  Widget _buildExerciseItem({
    required TrainingExercisePreviewResponse exercise,
  }) {
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
                        color: Colors.black,
                        fontSize: AppDimensions.textSizeM,
                      ),
                    ),
                    SizedBox(height: AppDimensions.spacingSM),
                    Text(
                      exercise.levelName,
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

  String generateDesAndAim(String planName) {
    const mapping = {
      "Fat Burn Express":
          "Tập luyện liên tục, đốt năng lượng theo từng nhịp tim.\nMục tiêu:\n1. Đốt cháy mỡ toàn thân hiệu quả.\n2. Tăng nhịp tim – cải thiện sức bền tim mạch.\n3. Giảm cân nhanh nhưng vẫn nhẹ nhàng với khớp.\n4. Phù hợp với người thừa cân nhẹ đến trung bình, ít vận động trước đó.",
      "Shred and Burn":
          "Tập gym cường độ cao, đốt mỡ tối đa với máy móc và bài tập kháng lực.\nMục tiêu:\n1. Giảm mỡ nhưng vẫn giữ hoặc tăng nhẹ khối cơ nạc.\n2. Cải thiện hình thể rõ rệt (săn chắc, khỏe mạnh).\n3. Thích hợp cho người muốn giảm mỡ khoa học kết hợp tập tạ.\n4. Cải thiện tốc độ trao đổi chất về lâu dài.",
      "Bodyweigt Burn":
          "Dùng trọng lượng cơ thể để xây dựng hành trình đốt mỡ linh hoạt và bền bỉ.\nMục tiêu:\n1. Giảm mỡ thông qua bài tập toàn thân bằng chính trọng lượng cơ thể.\n2. Cải thiện khả năng kiểm soát cơ thể, tư thế, sự linh hoạt.\n3. Phù hợp với người không có dụng cụ, không đến phòng gym.\n4. Giúp cải thiện sức bền và vóc dáng săn chắc.",
      "Muscle Mass Builder":
          "Nơi cơ bắp được xây nên bằng thép, kỷ luật và sức bền tại phòng gym.\nMục tiêu:\n1. Tăng khối lượng cơ toàn thân (lean mass).\n2. Cải thiện sức mạnh và kích thước cơ bắp.\n3. Tối ưu hóa hormone tăng trưởng tự nhiên.",
      "Bodyweight Hypertrophy":
          "Xây dựng cơ bắp bằng chính trọng lượng cơ thể - kiểm soát, sức mạnh và kỷ luật.\nMục tiêu:\n1. Tăng cơ toàn thân thông qua sức mạnh trọng lượng cơ thể.\n2. Xây dựng thể hình săn chắc, khỏe khoắn.\n3. Cải thiện khả năng kiểm soát cơ thể và sức bền cơ bắp.",
      "Body Control Muscle":
          "Làm chủ cơ thể qua từng chuyển động - tăng cơ bằng kiểm soát, độ khó và độ sâu kỹ thuật.\nMục tiêu:\n1. Tăng cơ toàn thân bằng bodyweight.\n2. Phát triển khả năng kiểm soát cơ thể và sức mạnh cơ lõi.\n3. Săn chắc và tạo hình rõ nét.",
      "Lean Muscle Assist":
          "Cardio cường độ thấp hỗ trợ tăng cơ, thực hiện vào ngày nghỉ hoặc cuối buổi tập.\nMục tiêu:\n1. Cải thiện lưu thông máu, hỗ trợ phục hồi cơ.\n2. Tăng khả năng tập luyện bền bỉ.\n3. Duy trì nhịp tim ổn định trong quá trình tăng cơ.",
      "Lean and Fit":
          "Cân bằng giữa sức mạnh và sự dẻo dai - giữ form săn chắc mà không cần tạ nặng.\nMục tiêu:\n1. Giữ cơ bắp hiện có, không tăng thêm quá nhiều khối lượng.\n2. Duy trì tỷ lệ mỡ – cơ cân đối.\n3. Giữ thói quen vận động và trao đổi chất ổn định.",
      "Steady Fit":
          "Nhịp độ ổn định cho vóc dáng bền vững - đi bộ, chạy chậm mà không lo mất cơ.\nMục tiêu:\n1. Duy trì sức khỏe tim mạch và thể lực nền.\n2. Đốt năng lượng vừa đủ để giữ cân.\n3. Tăng cường khả năng trao đổi chất và sức bền.",
      "Balanced Body":
          "Cân bằng từ hơi thở đến cơ thể - giữ dáng nhẹ nhàng với yoga định hướng core.\nMục tiêu:\n1. Giữ vóc dáng cân đối qua sự linh hoạt và kiểm soát cơ thể.\n2. Giảm stress, ngủ sâu, cải thiện nội tiết tố.\n3. Tăng tuần hoàn, hỗ trợ tiêu hóa và giữ dáng tự nhiên.",
      "Endurance Engine":
          "Mỗi bước chạy là nền móng cho sức bền bền vững.\nMục tiêu:\n1. Tăng sức bền tim mạch (aerobic capacity).\n2. Cải thiện khả năng vận động lâu dài không mệt.\n3. Chuẩn bị thể lực nền cho chạy bộ, đạp xe, thể thao.",
      "Strength-Endurance Hybrid":
          "Kết hợp sức mạnh và bền bỉ trong từng set - tập luyện không chỉ nặng mà còn dẻo dai.\nMục tiêu:\n1. Tăng sức bền cơ bắp và khả năng vận động liên tục.\n2. Vừa xây dựng sức mạnh, vừa tăng khả năng lặp lại động tác.\n3. Phù hợp với người chơi thể thao, muốn 'không đuối sức'.",
      "Bodyweight Stamina":
          "Sức bền xây dựng từ từng chuyển động liền mạch - tập toàn thân không ngừng nghỉ.\nMục tiêu:\n1. Tăng sức bền toàn thân bằng các bài tập trọng lượng cơ thể.\n2. Cải thiện khả năng kiểm soát hơi thở và nhịp tim khi vận động dài.\n3. Phù hợp cho người không có điều kiện đến phòng tập.",
      "Healthy Heart Routine":
          "Nhịp tim khỏe từ từng bước nhỏ - cardio nhẹ nhàng, bền bỉ cho mọi thể trạng.\nMục tiêu:\n1. Tăng hiệu quả bơm máu và nhịp tim.\n2. Giảm huyết áp, cholesterol, kiểm soát cân nặng.\n3. Tăng sức khỏe hệ tuần hoàn và khả năng hô hấp.",
      "Cardio + Strength Circuit":
          "Tập đều cả tim và cơ - nhịp tim ổn định, chuyển động không ngừng.\nMục tiêu:\n1. Hỗ trợ hệ tim mạch bằng các bài tập tạ nhẹ kết hợp cardio.\n2. Tăng lưu thông máu, cải thiện nhịp tim khi vận động.\n3. Duy trì tim khỏe mạnh trong khi tập gym.",
      "Hearful Flow":
          "Nhịp thở chậm, chuyển động êm - nuôi dưỡng trái tim và sự bình an từ bên trong.\nMục tiêu:\n1. Điều hòa huyết áp, nhịp tim và hô hấp.\n2. Giảm stress – nguyên nhân gây nguy cơ tim mạch.\n3. Tăng lưu thông máu và giảm viêm nội tạng.",
      "Calm and Clarity":
          "Chậm lại để lắng nghe - thư giãn thân - tĩnh tâm trí qua từng hơi thở sâu và chuyển động nhẹ.\nMục tiêu:\n1. Giải tỏa căng thẳng tinh thần và cơ thể.\n2. Tăng khả năng kiểm soát cảm xúc và cải thiện chất lượng giấc ngủ.\n3. Kích hoạt hệ thần kinh phó giao cảm (relaxation mode).",
      "Mindful Movement":
          "Chuyển động chậm rãi, tâm trí an yên - đi bộ hay đạp xe để thả lỏng và lắng nghe chính mình.\nMục tiêu:\n1. Giải phóng endorphin tự nhiên (hormone hạnh phúc).\n2. Giảm stress và rối loạn lo âu nhẹ.\n3. Kết hợp vận động và hít thở giúp làm dịu hệ thần kinh.",
      "Reset and Recharge":
          "Lắc lư, thả lỏng, thở sâu - phục hồi cả thân và tâm qua từng chuyển động đầy chánh niệm.\nMục tiêu:\n1. Giải phóng căng cứng ở cổ, vai, lưng do ngồi lâu / stress.\n2. Duy trì vận động nhẹ nhàng mà không tạo áp lực.\n3. Làm dịu cơ thể và tinh thần.",
      "Height Stretch Flow":
          "Mỗi hơi thở giúp bạn vươn dài hơn - kéo giãn nhẹ nhàng cho cơ thể khỏe và cao hơn từng ngày.\nMục tiêu:\n1. Kéo giãn cột sống, làm thẳng tư thế.\n2. Kích thích hormone tăng trưởng (GH) vào buổi sáng hoặc trước khi ngủ.\n3. Tăng độ linh hoạt cột sống, cải thiện postural height.",
      "Jump and Stretch Combo":
          "Bật cao hơn, vươn dài hơn - kết hợp vận động và kéo giãn để tối ưu chiều cao.\nMục tiêu:\n1. Kích thích hormone tăng trưởng tự nhiên.\n2. Giãn các sụn ở đầu xương khi chưa đóng.\n3. Tăng nhịp tim nhẹ để thúc đẩy trao đổi chất.",
      "Posture and Core Strength":
          "Lưng thẳng - dáng cao. Xây dựng tư thế vững vàng từ bên trong.\nMục tiêu:\n1. Tăng chiều cao thông qua cải thiện tư thế.\n2. Kéo dài cột sống và giữ vai – lưng thẳng.\n3. Cải thiện core để hỗ trợ giữ vóc dáng thẳng.",
    };

    return mapping[planName] ?? planName;
  }
}
