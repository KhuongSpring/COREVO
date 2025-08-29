import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';
import 'package:hit_tech/view/personal_health/widget/height_selection_widget.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_string.dart';

class AgeSelectionWidget extends StatefulWidget {
  final String gender;

  const AgeSelectionWidget({super.key, required this.gender});

  @override
  _AgeSelectionScreenstate createState() => _AgeSelectionScreenstate();
}

class _AgeSelectionScreenstate extends State<AgeSelectionWidget> {
  late FixedExtentScrollController _scrollController;
  final List<int> years = List.generate(50, (index) => 2025 - index);
  int? selectedYear;

  @override
  void initState() {
    super.initState();
    final initialYear = 2005;
    final initialIndex = years.indexOf(initialYear);
    selectedYear = initialYear;
    _scrollController = FixedExtentScrollController(initialItem: initialIndex);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected = selectedYear ?? 2005;

    return Scaffold(
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
                                    final progress = 2 / 5;
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
                              'Tuổi',
                              style: TextStyle(
                                fontSize: AppDimensions.textSizeXL,
                                fontWeight: FontWeight.bold,
                                color: AppColors.dark,
                              ),
                            ),
                            SizedBox(height: AppDimensions.spacingS),
                            Text(
                              'Nhập tuổi của bạn để điều chỉnh mục tiêu phù hợp với giai đoạn của cơ thể.',
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

                      // Year picker
                      Expanded(
                        child: Center(
                          child: SizedBox(
                            height: AppDimensions.size280,
                            width: AppDimensions.width * 0.9.w,
                            child: ListWheelScrollView.useDelegate(
                              controller: _scrollController,
                              itemExtent: 60,
                              perspective: 0.005,
                              diameterRatio: 1.2,
                              physics: const FixedExtentScrollPhysics(),
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  selectedYear = years[index];
                                });
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: years.length,
                                builder: (context, index) {
                                  final year = years[index];
                                  final isSelected = year == selected;

                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.bNormal
                                            : Colors.transparent,
                                        width: isSelected ? 2 : 1,
                                      ),
                                      color: isSelected
                                          ? AppColors.bLightHover
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(
                                        AppDimensions.borderRadiusLarge,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$year',
                                        style: TextStyle(
                                          fontSize: isSelected
                                              ? AppDimensions.textSizeXXXL
                                              : AppDimensions.textSizeL,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                          color: isSelected
                                              ? AppColors.bNormal
                                              : AppColors.lighter,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: AppDimensions.spacingXL),

                      // Continue Button
                      Padding(
                        padding: EdgeInsets.only(
                          left: AppDimensions.paddingL,
                          bottom: AppDimensions.size88 + 2.w,
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
                                      HeightSelectionWidget(
                                        gender: widget.gender,
                                        age:
                                            DateTime.now().year -
                                            (selectedYear ?? 1990),
                                      ),
                                  transitionsBuilder:
                                      (_, animation, __, child) {
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
