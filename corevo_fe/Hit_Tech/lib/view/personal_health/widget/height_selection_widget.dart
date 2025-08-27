import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/view/personal_health/widget/weight_selection_widget.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_dimension.dart';
import '../../../core/constants/app_string.dart';

class HeightSelectionWidget extends StatefulWidget {
  final String gender;
  final int age;

  const HeightSelectionWidget({
    super.key,
    required this.gender,
    required this.age,
  });

  @override
  _HeightSelectionWidgetState createState() => _HeightSelectionWidgetState();
}

class _HeightSelectionWidgetState extends State<HeightSelectionWidget> {
  int height = 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bLight,
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
                                    final progress = 3 / 5;
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
                              'Chiều Cao',
                              style: TextStyle(
                                fontSize: AppDimensions.textSizeXL,
                                fontWeight: FontWeight.bold,
                                color: AppColors.dark,
                              ),
                            ),
                            SizedBox(height: AppDimensions.size8),
                            Text(
                              'Chiều cao hiện tại để giúp tính toán chỉ số thể hình và đề xuất chế độ phù hợp.',
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
                        child: Stack(
                          children: [
                            Positioned(
                              top: AppDimensions.paddingXXL,
                              left: AppDimensions.paddingXL,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    '$height',
                                    style: TextStyle(
                                      fontSize: AppDimensions.size56,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.dark,
                                    ),
                                  ),
                                  SizedBox(width: AppDimensions.spacingS),
                                  Text(
                                    'cm',
                                    style: TextStyle(
                                      fontSize: AppDimensions.textSizeL,
                                      color: AppColors.lightActive,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: AppDimensions.size112,
                              left: AppDimensions.paddingXL,
                              child: Container(
                                width: AppDimensions.size120,
                                height: 4.w,
                                decoration: BoxDecoration(
                                  color: AppColors.bNormal,
                                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusTiny),
                                ),
                              ),
                            ),
                            Positioned(
                              left: AppDimensions.paddingXXL,
                              top: AppDimensions.size120,
                              bottom: AppDimensions.paddingXXL,
                              child: SizedBox(
                                width: AppDimensions.size176,
                                child: _buildGenderImage(widget.gender),
                              ),
                            ),
                            Positioned(
                              right: AppDimensions.paddingL,
                              top: AppDimensions.size80,
                              bottom: AppDimensions.size104,
                              child: SizedBox(
                                width: AppDimensions.size80,
                                child: NotificationListener<ScrollNotification>(
                                  onNotification: (notification) {
                                    if (notification
                                        is ScrollUpdateNotification) {
                                      final scrollController =
                                          notification.metrics;
                                      final total =
                                          scrollController.maxScrollExtent;
                                      final pos = scrollController.pixels;
                                      if (total > 0) {
                                        final progress = pos / total;
                                        final range = 200 - 100;
                                        final newHeight =
                                            (200 - progress * range).round();
                                        setState(() {
                                          height = newHeight.clamp(100, 200);
                                        });
                                      }
                                    }
                                    return false;
                                  },
                                  child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    padding: EdgeInsets.symmetric(
                                      vertical: AppDimensions.size104,
                                    ),
                                    itemCount: 100,
                                    itemBuilder: (context, index) {
                                      final h = 200 - index;
                                      final isMain = h % 10 == 0 || h % 5 == 0;
                                      final isNear = (h - height).abs() <= 2;
                                      return SizedBox(
                                        height: AppDimensions.size32,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            if (isMain) ...[
                                              Text(
                                                '$h',
                                                style: TextStyle(
                                                  fontSize: AppDimensions.textSizeM,
                                                  color: isNear
                                                      ? AppColors.bNormal
                                                      : AppColors.lightActive,
                                                  fontWeight: isNear
                                                      ? FontWeight.bold
                                                      : FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(width: AppDimensions.spacingS),
                                            ],
                                            Container(
                                              width: isMain ? AppDimensions.size24 : AppDimensions.size16,
                                              height: isNear ? 3 : 2,
                                              decoration: BoxDecoration(
                                                color: isNear
                                                    ? AppColors.bNormal
                                                    : (isMain
                                                          ? AppColors.lightActive
                                                          : AppColors.lighter),
                                                borderRadius:
                                                    BorderRadius.circular(AppDimensions.borderRadiusTiny),
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
                                      WeightSelectionWidget(
                                        gender: widget.gender,
                                        age: widget.age,
                                        height: height,
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

  Widget _buildGenderImage(String? gender) {
    if (gender == 'Female') {
      return Image.asset(
        AppAssets.imageGenderGirl,
        fit: BoxFit.contain,
        alignment: Alignment.bottomCenter,
      );
    } else {
      return Image.asset(
        AppAssets.imageGenderBoy,
        fit: BoxFit.contain,
        alignment: Alignment.bottomCenter,
      );
    }
  }
}
