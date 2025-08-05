import 'package:flutter/material.dart';
import 'package:hit_tech/view/personal_health/widget/activity_level_selection_widget.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_dimension.dart';
import '../../../core/constants/app_string.dart';

class WeightSelectionWidget extends StatefulWidget {
  final String gender;
  final int age;
  final int height;

  const WeightSelectionWidget({
    super.key,
    required this.gender,
    required this.age,
    required this.height,
  });

  @override
  _WeightSelectionWidgetState createState() => _WeightSelectionWidgetState();
}

class _WeightSelectionWidgetState extends State<WeightSelectionWidget> {
  double weight = 40.0;

  @override
  Widget build(BuildContext context) {
    final bmi = _calculateBMI(weight, widget.height);
    final bmiCategory = _getBMICategory(bmi);
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.bLight,
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
                            final progress = 4 / 5;
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

              _buildBMIIndicator(bmi, bmiCategory, screenWidth),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.bLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            weight.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2196F3),
                            ),
                          ),
                          SizedBox(width: 8),
                          Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Text(
                              'kg',
                              style: TextStyle(
                                fontSize: 24,
                                color: Color(0xFF888888),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 60),
                      _buildWeightSelector(),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 24, bottom: 70, right: 24),
                child: SizedBox(
                  width: AppDimensions.normal,
                  height: AppDimensions.heightButton,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ActivityLevelSelectionWidget(
                            gender: widget.gender,
                            age: widget.age,
                            height: widget.height,
                            weight: weight,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonBGBottomGenderfocus,
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
        ],
      ),
    );
  }

  Widget _buildWeightSelector() {
    return Container(
      height: 120,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            final scroll = notification.metrics;
            final total = scroll.maxScrollExtent;
            final pos = scroll.pixels;
            if (total > 0) {
              final newWeight = 40.0 + (pos / total) * (120.0 - 40.0);
              setState(() => weight = newWeight.clamp(40.0, 120.0));
            }
          }
          return false;
        },
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 150),
          itemCount: 800,
          itemBuilder: (context, index) {
            final w = 40.0 + index * 0.1;
            final isMain = (w * 10).round() % 10 == 0;
            final isNear = (w - weight).abs() <= 0.5;
            return Container(
              width: 16,
              child: Column(
                children: [
                  Container(
                    width: 2,
                    height: isMain ? 25 : 15,
                    color: isNear
                        ? Color(0xFF2196F3)
                        : (isMain ? Color(0xFF333333) : Color(0xFFCCCCCC)),
                  ),
                  if (isMain) SizedBox(height: 6),
                  if (isMain)
                    Text(
                      '${w.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isNear ? Color(0xFF2196F3) : Color(0xFF666666),
                        fontWeight: isNear
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBMIIndicator(
    double bmi,
    BMICategory category,
    double screenWidth,
  ) {
    final position = _getBMIPosition(bmi);
    final color = _getBMIColor(bmi);
    return Container(
      width: screenWidth * 0.9,
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
            'Chỉ số BMI của bạn là ${bmi.toStringAsFixed(1)} - ${category.name}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF07314F),
            ),
          ),
          SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              return Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Container(color: Colors.blue[300])),
                        Expanded(child: Container(color: Colors.green[400])),
                        Expanded(child: Container(color: Colors.orange[400])),
                        Expanded(child: Container(color: Colors.red[400])),
                      ],
                    ),
                  ),
                  Positioned(
                    left: position * w - 12,
                    top: -8,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(Icons.person, size: 14, color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  double _calculateBMI(double weight, int height) {
    final h = height / 100.0;
    return weight / (h * h);
  }

  BMICategory _getBMICategory(double bmi) {
    if (bmi < 18.5) return BMICategory('Thiếu cân');
    if (bmi < 25) return BMICategory('Bình thường');
    if (bmi < 30) return BMICategory('Thừa cân');
    return BMICategory('Béo phì');
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.blue[300]!;
    if (bmi < 25) return Colors.green[400]!;
    if (bmi < 30) return Colors.orange[400]!;
    return Colors.red[400]!;
  }

  double _getBMIPosition(double bmi) {
    final clamped = bmi.clamp(15.0, 35.0);
    return (clamped - 15.0) / 20.0;
  }
}

class BMICategory {
  final String name;

  const BMICategory(this.name);
}
