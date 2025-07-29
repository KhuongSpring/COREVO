import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_assets.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/core/constants/app_string.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/health_bloc.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/heath_event.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/heath_state.dart';

class ActivityLevelSelectionWidget extends StatefulWidget {
  ActivityLevelSelectionWidget({super.key});

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

  final List<Map<String, dynamic>> activityLevels = [
    {
      'level': AppStrings.level1,
      'title': AppStrings.activityLevelSedentary,
      'description': AppStrings.activityLevelSedentaryDescription,
      'image': TrainingAssets.imageActivityLevelSedentary,
    },
    {
      'level': AppStrings.level2,
      'title': AppStrings.activityLevelLight,
      'description': AppStrings.activityLevelLightDescription,
      'image': TrainingAssets.imageActivityLevelLight,
    },
    {
      'level': AppStrings.level3,
      'title': AppStrings.activityLevelModerate,
      'description': AppStrings.activityLevelModerateDescription,
      'image': TrainingAssets.imageActivityLevelModerate,
    },
    {
      'level': AppStrings.level4,
      'title': AppStrings.activityLevelActive,
      'description': AppStrings.activityLevelActiveDescription,
      'image': TrainingAssets.imageActivityLevelActive,
    },
    {
      'level': AppStrings.level5,
      'title': AppStrings.activityLevelSuperActive,
      'description': AppStrings.activityLevelSuperActiveDescription,
      'image': TrainingAssets.imageActivityLevelSuperActive,
    },
  ];

  int currentIndex = 0;

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

      final selectedLevel = activityLevels[index]['level'].toString();
      context.read<HealthInfoBloc>().add(UpdateActivityLevel(selectedLevel));
      _animationController.reset();
      _animationController.forward();

      _sliderAnimationController.reset();
      _sliderAnimationController.forward();

      // Update bloc state
      context.read<HealthInfoBloc>().add(
        UpdateActivityLevel(activityLevels[index]['level']),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HealthInfoBloc, HealthInfoState>(
      listener: (context, state) {
        if (state is HealthInfoSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Thông tin sức khỏe đã được gửi thành công!'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacementNamed(context, '/homeRoot');
        } else if (state is HealthInfoError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final formState = state is HealthInfoFormState
            ? state
            : HealthInfoFormState();

        final isLoading = state is HealthInfoLoading;
        final currentActivity = activityLevels[currentIndex];

        return Scaffold(
          backgroundColor: AppColors.bLight,

          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.bLightNotActive2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        AppStrings.activityLevelSelectionTitle,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF07314F),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        AppStrings.activityLevelSelectionDescription,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 280.sp,
                            height: 280.sp,
                            decoration: BoxDecoration(),
                            child: Center(
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
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              currentActivity['description'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                height: 1.5,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 35,
                              left: 15,
                              right: 15,
                              child: Container(
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 35,
                              left: 15,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width:
                                    (MediaQuery.of(context).size.width - 78) *
                                    (currentIndex / 4),
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(5, (index) {
                                final isActive = index == currentIndex;
                                final isPassed = index < currentIndex;

                                return GestureDetector(
                                  onTap: isLoading
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
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
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
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ít vận động',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Rất năng động',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  context.read<HealthInfoBloc>().add(
                                    SubmitHealthInfo(),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            disabledBackgroundColor: Colors.grey[300],
                            elevation: 0,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Tiếp tục',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
