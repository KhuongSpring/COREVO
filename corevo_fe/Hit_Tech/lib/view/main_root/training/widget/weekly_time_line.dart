import 'package:flutter/material.dart';

class WeeklyTimeline extends StatefulWidget {
  final int selectedIndex;

  const WeeklyTimeline({super.key, required this.selectedIndex});

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

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isSelected ? 36 : 16,
            width: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.blue : Colors.grey.shade700,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 12,
                        spreadRadius: 4,
                      ),
                    ]
                  : [],
            ),
          );
        } else {
          final aboveDot = index ~/ 2;
          final isAboveSelected = aboveDot == widget.selectedIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isAboveSelected ? 250 : 100,
            width: 2,
            color: Colors.grey.shade500,
          );
        }
      }),
    );
  }
}
