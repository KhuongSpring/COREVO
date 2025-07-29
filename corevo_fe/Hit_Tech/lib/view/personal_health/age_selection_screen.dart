import 'package:flutter/material.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';
import 'package:hit_tech/view/personal_health/height_selection_screen.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_string.dart';

class AgeSelectionScreen extends StatefulWidget {
  final String gender;

  const AgeSelectionScreen({super.key, required this.gender});

  @override
  _AgeSelectionScreenstate createState() => _AgeSelectionScreenstate();
}

class _AgeSelectionScreenstate extends State<AgeSelectionScreen> {
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
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
                            final progress = 2 / 5;
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
                      'Tuổi',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Nhập tuổi của bạn để điều chỉnh mục tiêu phù hợp với giai đoạn của cơ thể.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),

              // Year picker
              Expanded(
                child: Center(
                  child: SizedBox(
                    height: 280,
                    width: screenWidth * 0.9,
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
                                  ? const Color(0xFFDCEEFB)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                '$year',
                                style: TextStyle(
                                  fontSize: isSelected ? 32 : 20,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? AppColors.bNormal
                                      : const Color(0xFF989DA1),
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

              const SizedBox(height: 30),

              // Continue Button
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
                          builder: (context) => HeightSelectionScreen(
                            gender: widget.gender,
                            age: selectedYear ?? 2005,
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
}
