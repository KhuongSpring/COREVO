import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/health_bloc.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/heath_event.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/heath_state.dart';

class WeightSelectionWidget extends StatelessWidget {
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
                          'Cân Nặng',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF07314F),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Cân nặng hiện tại để tính chỉ số BMI và đề xuất chế độ dinh dưỡng phù hợp.',
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

                  // BMI Indicator
                  _buildBMIIndicator(formState),

                  SizedBox(height: 20),

                  // Main content area
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.bLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 40),
                          // Weight display - Fixed horizontal layout
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${(formState.weight ?? 66.1).toStringAsFixed(1)}',
                                  style: TextStyle(
                                    fontSize: 72,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2196F3),
                                    height:
                                        1.0, // Đảm bảo line height không làm text bị dãn
                                  ),
                                ),
                                SizedBox(width: 8),
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 8,
                                  ), // Căn chỉnh với baseline của số
                                  child: Text(
                                    'kg',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Color(0xFF888888),
                                      fontWeight: FontWeight.w500,
                                      height: 1.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 60),

                          // Horizontal weight ruler at bottom
                          Container(
                            height: 120,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Stack(
                              children: [
                                // Ruler marks
                                Container(
                                  height: 60,
                                  child: NotificationListener<ScrollNotification>(
                                    onNotification: (notification) {
                                      if (notification
                                          is ScrollUpdateNotification) {
                                        final scrollController =
                                            notification.metrics;
                                        final totalScrollableWidth =
                                            scrollController.maxScrollExtent;
                                        final currentScrollPosition =
                                            scrollController.pixels;

                                        if (totalScrollableWidth > 0) {
                                          final scrollProgress =
                                              currentScrollPosition /
                                              totalScrollableWidth;
                                          final weightRange =
                                              120.0 - 40.0; // 80kg range
                                          final newWeight =
                                              40.0 +
                                              (scrollProgress * weightRange);
                                          final clampedWeight = newWeight.clamp(
                                            40.0,
                                            120.0,
                                          );

                                          context.read<HealthInfoBloc>().add(
                                            UpdateWeight(clampedWeight),
                                          );
                                        }
                                      }
                                      return false;
                                    },
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics: BouncingScrollPhysics(),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 150,
                                      ),
                                      itemCount: 800,
                                      itemBuilder: (context, index) {
                                        final weight = 40.0 + (index * 0.1);
                                        final isMainMark =
                                            (weight * 10).round() % 10 == 0;
                                        final currentWeight =
                                            formState.weight ?? 66.1;
                                        final isNearSelected =
                                            (weight - currentWeight).abs() <=
                                            0.5;

                                        return Container(
                                          width: 16,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 2,
                                                height: isMainMark ? 25 : 15,
                                                decoration: BoxDecoration(
                                                  color: isNearSelected
                                                      ? Color(0xFF2196F3)
                                                      : (isMainMark
                                                            ? Color(0xFF333333)
                                                            : Color(
                                                                0xFFCCCCCC,
                                                              )),
                                                  borderRadius:
                                                      BorderRadius.circular(1),
                                                ),
                                              ),
                                              if (isMainMark) ...[
                                                SizedBox(height: 6),
                                                Text(
                                                  '${weight.toStringAsFixed(0)}',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.visible,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: isNearSelected
                                                        ? Color(0xFF2196F3)
                                                        : Color(0xFF666666),
                                                    fontWeight: isNearSelected
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),

                                Positioned(
                                  left: 0,
                                  right: 0,
                                  top: 0,
                                  child: Center(
                                    child: Container(
                                      width: 3,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF2196F3),
                                        borderRadius: BorderRadius.circular(
                                          1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF2196F3),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
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

                  SizedBox(height: 20),

                  // Continue Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<HealthInfoBloc>().add(NextStep());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2196F3),
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

  Widget _buildBMIIndicator(HealthInfoFormState formState) {
    final height = formState.height ?? 182;
    final weight = formState.weight ?? 66.1;
    final bmi = _calculateBMI(weight, height);
    final bmiCategory = _getBMICategory(bmi);
    final bmiColor = _getBMIColor(bmi);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Chỉ số BMI của bạn là ${bmi.toStringAsFixed(1)} - ${bmiCategory.name}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF07314F),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          _buildBMIScale(bmi),
        ],
      ),
    );
  }

  Widget _buildBMIScale(double currentBMI) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scaleWidth = constraints.maxWidth;
        final iconPosition = _getBMIPosition(currentBMI) * scaleWidth;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '15',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  '20',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  '25',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  '30',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 4),

            Stack(
              clipBehavior: Clip.none,
              children: [
                // BMI Scale Bar
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      // Underweight
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue[300],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              bottomLeft: Radius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      // Normal
                      Expanded(
                        flex: 5,
                        child: Container(color: Colors.green[400]),
                      ),
                      // Overweight
                      Expanded(
                        flex: 5,
                        child: Container(color: Colors.orange[400]),
                      ),
                      // Obese
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red[400],
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(4),
                              bottomRight: Radius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  left: iconPosition - 12,
                  top: -8,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _getBMIColor(currentBMI),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(Icons.person, size: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Thiếu cân',
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
                Text(
                  'Bình thường',
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
                Text(
                  'Thừa cân',
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
                Text(
                  'Béo phì',
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  double _calculateBMI(double weight, int height) {
    final heightInM = height / 100.0;
    return weight / (heightInM * heightInM);
  }

  BMICategory _getBMICategory(double bmi) {
    if (bmi < 18.5) return BMICategory.underweight;
    if (bmi < 25) return BMICategory.normal;
    if (bmi < 30) return BMICategory.overweight;
    return BMICategory.obese;
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.blue[300]!;
    if (bmi < 25) return Colors.green[400]!;
    if (bmi < 30) return Colors.orange[400]!;
    return Colors.red[400]!;
  }

  double _getBMIPosition(double bmi) {
    // Map BMI to position on scale (0.0 to 1.0)
    final clampedBMI = bmi.clamp(15.0, 35.0);
    return (clampedBMI - 15.0) / 20.0; // 15-35 BMI range mapped to 0-1
  }

  Widget _buildGenderImage(String? gender) {
    // Remove gender image since we're using simple number display
    return SizedBox.shrink();
  }
}

enum BMICategory {
  underweight('Thiếu cân'),
  normal('Bình thường'),
  overweight('Thừa cân'),
  obese('Béo phì');

  const BMICategory(this.name);
  final String name;
}
