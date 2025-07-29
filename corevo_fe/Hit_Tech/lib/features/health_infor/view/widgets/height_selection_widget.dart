import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/health_bloc.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/heath_event.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/heath_state.dart';

import '../../../../core/constants/app_color.dart';

class HeightSelectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HealthInfoBloc, HealthInfoState>(
      builder: (context, state) {
        final formState = state is HealthInfoFormState
            ? state
            : HealthInfoFormState();

        return Scaffold(
          backgroundColor: AppColors.bLight,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // Header section
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
                          'Chiều Cao',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF07314F),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Chiều cao hiện tại để giúp tính toán chỉ số thể hình và đề xuất chế độ phù hợp.',
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

                  SizedBox(height: 30),

                  // Main content area
                  Expanded(
                    child: Stack(
                      children: [
                        // Background
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.bLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        // Height display at top left
                        Positioned(
                          top: 40,
                          left: 30,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '${formState.height ?? 182}',
                                style: TextStyle(
                                  fontSize: 56,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF000000),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'cm',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF888888),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Blue indicator line under height
                        Positioned(
                          top: 110,
                          left: 30,
                          child: Container(
                            width: 120,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Color(0xFF2196F3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),

                        // Character image in center-left
                        Positioned(
                          left: 60,
                          top: 120,
                          bottom: 100,
                          child: Container(
                            width: 180,
                            child: _buildGenderImage(formState.gender),
                          ),
                        ),

                        // Ruler on the right side
                        Positioned(
                          right: 20,
                          top: 80,
                          bottom: 100,
                          child: Container(
                            width: 80,
                            child: NotificationListener<ScrollNotification>(
                              onNotification: (notification) {
                                if (notification is ScrollUpdateNotification) {
                                  final scrollController = notification.metrics;
                                  final totalScrollableHeight =
                                      scrollController.maxScrollExtent;
                                  final currentScrollPosition =
                                      scrollController.pixels;

                                  if (totalScrollableHeight > 0) {
                                    final scrollProgress =
                                        currentScrollPosition /
                                        totalScrollableHeight;
                                    final heightRange = 200 - 100; // 60cm range
                                    final newHeight =
                                        (200 - (scrollProgress * heightRange))
                                            .round();
                                    final clampedHeight = newHeight.clamp(
                                      100,
                                      200,
                                    );

                                    context.read<HealthInfoBloc>().add(
                                      UpdateHeight(clampedHeight),
                                    );
                                  }
                                }
                                return false;
                              },
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.symmetric(vertical: 100),
                                itemCount: 100,
                                itemBuilder: (context, index) {
                                  final height = 200 - (index);
                                  final isMainMark =
                                      (height % 10 == 0) || (height % 5 == 0);
                                  final currentHeight = formState.height ?? 182;
                                  final isNearSelected =
                                      (height - currentHeight).abs() <= 2;

                                  return Container(
                                    height: 30,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        if (isMainMark) ...[
                                          Text(
                                            '$height',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: isNearSelected
                                                  ? Color(0xFF2196F3)
                                                  : Color(0xFF333333),
                                              fontWeight: isNearSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                        ],
                                        Container(
                                          width: isMainMark ? 25 : 15,
                                          height: isNearSelected ? 3 : 2,
                                          decoration: BoxDecoration(
                                            color: isNearSelected
                                                ? Color(0xFF2196F3)
                                                : (isMainMark
                                                      ? Color(0xFF333333)
                                                      : Color(0xFF9E9E9E)),
                                            borderRadius: BorderRadius.circular(
                                              1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Continue Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<HealthInfoBloc>().add(NextStep());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.bNormal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        'Tiếp tục',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGenderImage(String? gender) {
    if (gender == 'MALE') {
      return Image.asset(
        'assets/images/health_infor/boy.png',
        fit: BoxFit.contain,
        alignment: Alignment.bottomCenter,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: BoxDecoration(
              color: Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.male, size: 120, color: Color(0xFF2196F3)),
          );
        },
      );
    } else if (gender == 'FEMALE') {
      return Image.asset(
        'assets/images/health_infor/girl.png',
        fit: BoxFit.contain,
        alignment: Alignment.bottomCenter,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFE0F4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.female, size: 120, color: Color(0xFFE91E63)),
          );
        },
      );
    } else {
      // Default fallback
      return Container(
        decoration: BoxDecoration(
          color: Color(0xFFE8F5E8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.person, size: 120, color: Color(0xFF4CAF50)),
      );
    }
  }
}
