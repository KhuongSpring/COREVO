import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/view/main_root/home/home_screen.dart';
import 'package:hit_tech/model/request/personal_health_request.dart';
import 'package:hit_tech/model/response/default_response.dart';
import 'package:hit_tech/service/user_service.dart';
import 'package:hit_tech/view/main_root/home_root.dart';
import 'package:hit_tech/view/training_flow/widget/training_goal_selection_widget.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_color.dart';
import '../../core/constants/app_dimension.dart';
import '../../core/constants/app_message.dart';
import '../../core/constants/app_string.dart';
import '../../service/auth_service.dart';

class ActivityLevelSelectionScreen extends StatefulWidget {
  final String gender;
  final int age;
  final int height;
  final double weight;

  const ActivityLevelSelectionScreen({
    super.key,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
  });

  @override
  State<ActivityLevelSelectionScreen> createState() =>
      _ActivityLevelSelectionScreenState();
}

class _ActivityLevelSelectionScreenState
    extends State<ActivityLevelSelectionScreen>
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
                  builder: (context) => TrainingGoalSelectionWidget(),
                ),
              );
              return;
            }
          }
        } catch (e, stackTrace) {
          print(stackTrace);
        }

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeRoot()),
        );
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
      'image': TrainingAssets.imageActivityLevelSedentary,
    },
    {
      'level': 'LEVEL_2',
      'title': 'Hoạt động nhẹ',
      'description': 'Tập nhẹ 1–2 buổi mỗi tuần hoặc đi bộ nhẹ mỗi ngày.',
      'image': TrainingAssets.imageActivityLevelLight,
    },
    {
      'level': 'LEVEL_3',
      'title': 'Hoạt động vừa phải',
      'description': 'Tập luyện đều đặn 3–4 buổi mỗi tuần.',
      'image': TrainingAssets.imageActivityLevelModerate,
    },
    {
      'level': 'LEVEL_4',
      'title': 'Hoạt động nhiều',
      'description': 'Tập luyện cường độ cao hoặc công việc đòi hỏi di chuyển.',
      'image': TrainingAssets.imageActivityLevelActive,
    },
    {
      'level': 'LEVEL_5',
      'title': 'Rất năng động',
      'description': 'Vận động viên chuyên nghiệp hoặc tập luyện hàng ngày.',
      'image': TrainingAssets.imageActivityLevelSuperActive,
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
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[100],
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
              Container(
                padding: EdgeInsets.only(top: 50, right: 70),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.bNormal,
                      ),
                    ),
                    SizedBox(width: 35),
                    Expanded(
                      child: Container(
                        height: 7,
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
                                  width: constraints.maxWidth * progress,
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
              SizedBox(height: 32),
              Container(
                width: screenWidth * 0.9,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: AppColors.bLightNotActive2,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadius,
                  ),
                ),
                child: Column(
                  children: const [
                    Text(
                      'Mức độ hoạt động',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Chọn mức độ vận động hàng ngày của bạn để giúp đề xuất kế hoạch phù hợp.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black),
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
                      Container(
                        width: 230.sp,
                        height: 230.sp,
                        child: currentActivity['image'] != null
                            ? Image.asset(
                                currentActivity['image'],
                                width: 200.w,
                                height: 200.w,
                                fit: BoxFit.contain,
                              )
                            : Icon(
                                Icons.fitness_center,
                                size: 100,
                                color: Colors.blue[400],
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          currentActivity['description'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
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
                    SizedBox(height: 120),
                    Padding(
                      padding: EdgeInsets.only(left: 24, bottom: 70, right: 24),
                      child: SizedBox(
                        width: AppDimensions.normal,
                        height: AppDimensions.heightButton,
                        child: ElevatedButton(
                          onPressed: _handleFillPersonalInformation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.buttonBGBottomGenderfocus,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.circularM,
                              ),
                            ),
                          ),
                          child: Text(
                            AppStrings.genderSelectionContinue,
                            style: TextStyle(
                              fontSize: 20,
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
        ],
      ),
    );
  }

  Widget _buildSlider() {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          height: 50,
          child: Stack(
            children: [
              Positioned(
                top: 19,
                left: 15,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width:
                      (MediaQuery.of(context).size.width - 90) *
                      (currentIndex / 4),
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
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
                        width: isActive ? 40.w : 30.w,
                        height: isActive ? 40.w : 30.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? Colors.blue
                              : isPassed
                              ? Colors.blue
                              : Colors.white,
                          border: Border.all(
                            color: isActive || isPassed
                                ? Colors.blue
                                : Colors.grey[400]!,
                            width: isActive ? 3 : 2,
                          ),
                        ),
                        child: Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: isActive ? 16.w : 12.w,
                            height: isActive ? 16.w : 12.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive
                                  ? Colors.white
                                  : isPassed
                                  ? Colors.white
                                  : Colors.grey[400],
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
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Ít vận động',
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
              Text(
                'Rất năng động',
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
