import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

    return Scaffold(
      backgroundColor: AppColors.bLight,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppAssets.mainBackground, fit: BoxFit.cover),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: AppDimensions.height),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  SizedBox(height: 36.w),
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
                          'Cân Nặng',
                          style: TextStyle(
                            fontSize: AppDimensions.textSizeXL,
                            fontWeight: FontWeight.bold,
                            color: AppColors.dark,
                          ),
                        ),
                        SizedBox(height: AppDimensions.spacingS),
                        Text(
                          'Cân nặng hiện tại để tính chỉ số BMI và đề xuất chế độ dinh dưỡng phù hợp.',
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
                  SizedBox(height: AppDimensions.spacingXL),

                  _buildBMIIndicator(bmi, bmiCategory, AppDimensions.width),
                  SizedBox(height: AppDimensions.spacingL),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.bLight,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.borderRadius,
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: AppDimensions.spacingXXL),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                weight.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: AppDimensions.size48,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.bNormal,
                                ),
                              ),
                              SizedBox(width: AppDimensions.spacingS),
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: AppDimensions.paddingS,
                                ),
                                child: Text(
                                  'kg',
                                  style: TextStyle(
                                    fontSize: AppDimensions.textSizeXL,
                                    color: AppColors.lightHover,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppDimensions.spacingGiant),
                          _buildWeightSelector(),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: AppDimensions.spacingML),
                  Padding(
                    padding: EdgeInsets.only(
                      left: AppDimensions.paddingL,
                      bottom: AppDimensions.size56 - 1.w,
                      right: AppDimensions.paddingL,
                    ),
                    child: SizedBox(
                      width: AppDimensions.spacingWidthInfinite,
                      height: AppDimensions.size48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                                  ActivityLevelSelectionWidget(
                                    gender: widget.gender,
                                    age: widget.age,
                                    height: widget.height,
                                    weight: weight,
                                  ),
                              transitionsBuilder: (_, animation, __, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.bNormal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
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
          ),
        ],
      ),
    );
  }

  Widget _buildWeightSelector() {
    return Container(
      height: AppDimensions.size120,
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
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
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.size152),
          itemCount: 800,
          itemBuilder: (context, index) {
            final w = 40.0 + index * 0.1;
            final isMain = (w * 10).round() % 10 == 0;
            final isNear = (w - weight).abs() <= 0.5;
            return SizedBox(
              width: AppDimensions.size16,
              child: Column(
                children: [
                  Container(
                    width: 2,
                    height: isMain ? AppDimensions.size24 : AppDimensions.size16,
                    color: isNear
                        ? AppColors.bNormal
                        : AppColors.lighter,
                  ),
                  if (isMain) SizedBox(height: AppDimensions.spacingS),
                  if (isMain)
                    Text(
                      w.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: AppDimensions.textSizeXS,
                        color: isNear ? AppColors.bNormal : AppColors.lighter,
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
      width: screenWidth * 0.9.w,
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.wWhite,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8.w,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Chỉ số BMI của bạn là ${bmi.toStringAsFixed(1)} - ${category.name}',
            style: TextStyle(
              fontSize: AppDimensions.textSizeM,
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
          ),
          SizedBox(height: AppDimensions.spacingSM),
          LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              return Stack(
                children: [
                  Container(
                    height: AppDimensions.size8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppDimensions.borderRadiusTiny),
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
                    left: position * w - 12.w,
                    top: -AppDimensions.paddingS,
                    child: Container(
                      width: AppDimensions.size24,
                      height: AppDimensions.size24,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.wWhite, width: 2.w),
                      ),
                      child: Icon(Icons.person, size: AppDimensions.iconSizeS, color: AppColors.wWhite),
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
