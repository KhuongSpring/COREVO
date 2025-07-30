import 'package:flutter/material.dart';
import 'package:hit_tech/view/personal_health/weight_selection_screen.dart';
import '../../../../core/constants/app_color.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_dimension.dart';
import '../../core/constants/app_string.dart';

class HeightSelectionScreen extends StatefulWidget {
  final String gender;
  final int age;

  const HeightSelectionScreen({super.key, required this.gender, required this.age});

  @override
  _HeightSelectionScreenState createState() => _HeightSelectionScreenState();
}

class _HeightSelectionScreenState extends State<HeightSelectionScreen> {
  int height = 200;

  @override
  Widget build(BuildContext context) {
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
                            final progress = 3 / 5;
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

              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      top: 40,
                      left: 30,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '$height',
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
                    Positioned(
                      left: 40,
                      top: 120,
                      bottom: 40,
                      child: Container(
                        width: 180,
                        child: _buildGenderImage(widget.gender),
                      ),
                    ),
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
                              final total = scrollController.maxScrollExtent;
                              final pos = scrollController.pixels;
                              if (total > 0) {
                                final progress = pos / total;
                                final range = 200 - 100;
                                final newHeight = (200 - progress * range).round();
                                setState(() {
                                  height = newHeight.clamp(100, 200);
                                });
                              }
                            }
                            return false;
                          },
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(vertical: 100),
                            itemCount: 100,
                            itemBuilder: (context, index) {
                              final h = 200 - index;
                              final isMain = h % 10 == 0 || h % 5 == 0;
                              final isNear = (h - height).abs() <= 2;
                              return Container(
                                height: 30,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (isMain) ...[
                                      Text(
                                        '$h',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: isNear ? Color(0xFF2196F3) : Color(0xFF333333),
                                          fontWeight: isNear ? FontWeight.bold : FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                    ],
                                    Container(
                                      width: isMain ? 25 : 15,
                                      height: isNear ? 3 : 2,
                                      decoration: BoxDecoration(
                                        color: isNear
                                            ? Color(0xFF2196F3)
                                            : (isMain ? Color(0xFF333333) : Color(0xFF9E9E9E)),
                                        borderRadius: BorderRadius.circular(1),
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
                          builder: (context) => WeightSelectionScreen(
                            gender: widget.gender,
                            age: widget.age,
                            height: height,
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
          )
        ],
      )
    );
  }

  Widget _buildGenderImage(String? gender) {
    if (gender == 'Female') {
      return Image.asset(
        TrainingAssets.imageGenderGirl,
        fit: BoxFit.contain,
        alignment: Alignment.bottomCenter,
      );
    } else {
      return Image.asset(
        TrainingAssets.imageGenderBoy,
        fit: BoxFit.contain,
        alignment: Alignment.bottomCenter,
      );
    }
  }
}
