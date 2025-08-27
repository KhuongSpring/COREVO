import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/view/main_root/home/home_screen.dart';
import 'package:hit_tech/model/request/personal_health_request.dart';
import 'package:hit_tech/model/response/default_response.dart';
import 'package:hit_tech/service/user_service.dart';
import 'package:hit_tech/view/main_root/home_root.dart';
import 'package:hit_tech/view/training_flow/training_flow_start_page.dart';
import 'package:hit_tech/view/training_flow/widget/training_goal_selection_widget.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/constants/app_dimension.dart';
import '../../../core/constants/app_message.dart';
import '../../../core/constants/app_string.dart';
import '../../../service/auth_service.dart';

// Loi UI: Bottom Over 1.6
class ActivityLevelSelectionWidget extends StatefulWidget {
  final String gender;
  final int age;
  final int height;
  final double weight;

  const ActivityLevelSelectionWidget({
    super.key,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
  });

  @override
  State<ActivityLevelSelectionWidget> createState() =>
      _ActivityLevelSelectionWidgetState();
}

class _ActivityLevelSelectionWidgetState
    extends State<ActivityLevelSelectionWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _sliderAnimationController;

  Future<void> _handleFillPersonalInformation() async {
    try {
      final String selectedActivityLevel = currentIndex == 0
          ? 'SEDENTARY'
          : currentIndex == 1
          ? 'LIGHTLY_ACTIVE'
          : currentIndex == 2
          ? 'MODERATELY_ACTIVE'
          : currentIndex == 3
          ? 'VERY_ACTIVE'
          : 'EXTREMELY_ACTIVE';

      final request = PersonalHealthRequest(
        gender: widget.gender.toUpperCase(),
        age: widget.age,
        height: widget.height,
        weight: widget.weight,
        activityLevel: selectedActivityLevel,
      );

      final DefaultResponse response = await UserService.fillPersonalHealth(
        request,
      );

      if (response.status == 'SUCCESS') {
        try {
          final subResponse = await UserService.getProfile();

          if (subResponse.status == "SUCCESS") {
            if (subResponse.trainingPlans == null ||
                subResponse.trainingPlans!.isEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrainingFlowStartPage(),
                ),
              );
              return;
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeRoot(user: subResponse),
              ),
            );
          }
        } catch (e, stackTrace) {
          print(stackTrace);
        }
      } else {
        _showSnackBar('Lỗi', isError: true);
      }
    } catch (e) {
      _showSnackBar(HttpMessage.errGeneral, isError: false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  final List<Map<String, dynamic>> activityLevels = [
    {
      'level': 'LEVEL_1',
      'title': 'Ít vận động',
      'description':
          'Hầu như không tập luyện thể dục và ít di chuyển hàng ngày.',
      'image': AppAssets.imageActivityLevelSedentary,
    },
    {
      'level': 'LEVEL_2',
      'title': 'Hoạt động nhẹ',
      'description': 'Tập nhẹ 1–2 buổi mỗi tuần hoặc đi bộ nhẹ mỗi ngày.',
      'image': AppAssets.imageActivityLevelLight,
    },
    {
      'level': 'LEVEL_3',
      'title': 'Hoạt động vừa phải',
      'description': 'Tập luyện đều đặn 3–4 buổi mỗi tuần.',
      'image': AppAssets.imageActivityLevelModerate,
    },
    {
      'level': 'LEVEL_4',
      'title': 'Hoạt động nhiều',
      'description': 'Tập luyện cường độ cao hoặc công việc đòi hỏi di chuyển.',
      'image': AppAssets.imageActivityLevelActive,
    },
    {
      'level': 'LEVEL_5',
      'title': 'Rất năng động',
      'description': 'Vận động viên chuyên nghiệp hoặc tập luyện hàng ngày.',
      'image': AppAssets.imageActivityLevelSuperActive,
    },
  ];

  int currentIndex = 0;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _sliderAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _sliderAnimationController.dispose();
    super.dispose();
  }

  void _onSliderChanged(int index) {
    if (index != currentIndex) {
      setState(() {
        currentIndex = index;
      });

      _animationController.reset();
      _animationController.forward();

      _sliderAnimationController.reset();
      _sliderAnimationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentActivity = activityLevels[currentIndex];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppAssets.mainBackground, fit: BoxFit.cover),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: AppDimensions.height),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          top: AppDimensions.paddingXL,
                          right: AppDimensions.size72,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.arrow_back_ios_new,
                                color: AppColors.bNormal,
                              ),
                            ),
                            SizedBox(width: AppDimensions.spacingXL),
                            Expanded(
                              child: Container(
                                height: AppDimensions.size8,
                                decoration: BoxDecoration(
                                  color: AppColors.moreLighter,
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.borderRadius,
                                  ),
                                ),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final progress = 5 / 5;
                                    return Stack(
                                      children: [
                                        Container(
                                          width:
                                              constraints.maxWidth * progress,
                                          decoration: BoxDecoration(
                                            color: AppColors.bNormal,
                                            borderRadius: BorderRadius.circular(
                                              AppDimensions.borderRadius,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppDimensions.spacingXL),

                      Container(
                        width: AppDimensions.width * 0.9.w,
                        padding: EdgeInsets.symmetric(
                          vertical: AppDimensions.paddingL,
                          horizontal: AppDimensions.paddingL,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.bLightNotActive2,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.borderRadius,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Mức độ hoạt động',
                              style: TextStyle(
                                fontSize: AppDimensions.textSizeXL,
                                fontWeight: FontWeight.bold,
                                color: AppColors.dark,
                              ),
                            ),
                            SizedBox(height: AppDimensions.spacingS),
                            Text(
                              'Chọn mức độ vận động hàng ngày của bạn để giúp đề xuất kế hoạch phù hợp.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: AppDimensions.textSizeM,
                                color: AppColors.dark,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        flex: 4,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: AppDimensions.size232,
                                height: AppDimensions.size232,
                                child: currentActivity['image'] != null
                                    ? Image.asset(
                                        currentActivity['image'],
                                        width: AppDimensions.size200,
                                        height: AppDimensions.size200,
                                        fit: BoxFit.contain,
                                      )
                                    : Icon(
                                        Icons.fitness_center,
                                        size: AppDimensions.size104,
                                      ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppDimensions.paddingM,
                                ),
                                child: Text(
                                  currentActivity['description'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: AppDimensions.textSizeS,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            _buildSlider(),
                            SizedBox(height: AppDimensions.size128 - 2.w),
                            Padding(
                              padding: EdgeInsets.only(
                                left: AppDimensions.paddingL,
                                bottom: AppDimensions.size56,
                                right: AppDimensions.paddingL,
                              ),
                              child: SizedBox(
                                width: AppDimensions.spacingWidthInfinite,
                                height: AppDimensions.size48,
                                child: ElevatedButton(
                                  onPressed: _handleFillPersonalInformation,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.bNormal,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppDimensions.borderRadiusLarge,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    AppStrings.genderSelectionContinue,
                                    style: TextStyle(
                                      fontSize: AppDimensions.textSizeL,
                                      color: AppColors.wWhite,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider() {
    return Column(
      children: [
        SizedBox(
          width: AppDimensions.width * 0.9.w,
          height: AppDimensions.size48,
          child: Stack(
            children: [
              Positioned(
                top: AppDimensions.spacingML,
                left: AppDimensions.spacingM,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: (AppDimensions.width - 100.w) * (currentIndex / 4.w),
                  height: AppDimensions.size4,
                  decoration: BoxDecoration(
                    color: AppColors.bNormal,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusTiny,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: AppDimensions.paddingS,
                  right: AppDimensions.paddingS,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (index) {
                    final isActive = index == currentIndex;
                    final isPassed = index < currentIndex;

                    return GestureDetector(
                      onTap: isSubmitting
                          ? null
                          : () => _onSliderChanged(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: isActive
                            ? AppDimensions.size40
                            : AppDimensions.size32,
                        height: isActive
                            ? AppDimensions.size40
                            : AppDimensions.size32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? AppColors.bNormal
                              : isPassed
                              ? AppColors.bNormal
                              : AppColors.wWhite,
                          border: Border.all(
                            color: isActive || isPassed
                                ? AppColors.bNormal
                                : AppColors.moreLighter,
                            width: isActive ? 3 : 2,
                          ),
                        ),
                        child: Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: isActive
                                ? AppDimensions.size16
                                : AppDimensions.iconSizeXS,
                            height: isActive
                                ? AppDimensions.size16
                                : AppDimensions.iconSizeXS,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive
                                  ? AppColors.wWhite
                                  : isPassed
                                  ? AppColors.wWhite
                                  : AppColors.moreLighter,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingXXL),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ít vận động',
                style: TextStyle(
                  fontSize: AppDimensions.textSizeS,
                  color: AppColors.dark,
                ),
              ),
              Text(
                'Rất năng động',
                style: TextStyle(
                  fontSize: AppDimensions.textSizeS,
                  color: AppColors.dark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
