import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_color.dart';

import '../../../../core/constants/app_dimension.dart';

class WeeklyTimeline extends StatefulWidget {
  final int selectedIndex;
  final Function(int index) onChanged;

  const WeeklyTimeline({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  State<WeeklyTimeline> createState() => _WeeklyTimelineState();
}

class _WeeklyTimelineState extends State<WeeklyTimeline> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(7 * 2 - 1, (index) {
        if (index.isEven) {
          final dotIndex = index ~/ 2;
          final isSelected = dotIndex == widget.selectedIndex;

          return GestureDetector(
            onTap: () => widget.onChanged(dotIndex),

            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isSelected ? AppDimensions.size32 : AppDimensions.size16,
              width: AppDimensions.size16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.bNormal : AppColors.lighter,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: AppDimensions.borderRadius,
                          spreadRadius: 4.w,
                        ),
                      ]
                    : [],
              ),
            ),
          );
        } else {
          final aboveDot = index ~/ 2;
          final isAboveSelected = aboveDot == widget.selectedIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isAboveSelected
                ? AppDimensions.size264
                : AppDimensions.size104,
            width: 2.w,
            color: AppColors.lighter,
          );
        }
      }),
    );
  }
}
