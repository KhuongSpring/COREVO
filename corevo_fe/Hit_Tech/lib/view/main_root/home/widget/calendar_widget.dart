import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/utils/mapping_training_resource_helper.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/constants/app_color.dart';
import '../../../../model/response/training/training_schedule_response.dart';

class CalendarWidget extends StatefulWidget {
  final Function(DateTime)? onDaySelected;
  final DateTime? selectedDay;
  List<TrainingScheduleResponse> schedules = [];
  final List<bool> currentMonthCompletions;

  CalendarWidget({
    super.key,
    this.onDaySelected,
    this.selectedDay,
    required this.schedules,
    required this.currentMonthCompletions,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late final DateTime _focusedDay;
  late final DateTime _firstDay;
  late final DateTime _lastDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();

    _firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    _lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    _selectedDay = widget.selectedDay;
  }

  @override
  Widget build(BuildContext context) {
    final Set<DateTime> _underlinedDays =
        MappingTrainingResourceHelper.buildMarkedTrainingDays(
          widget.schedules,
          DateTime.now().year,
          DateTime.now().month,
        );

    final DateTime now = DateTime.now();
    final int year = now.year;
    final int month = now.month;

    final Set<DateTime> completedDays = {};
    for (int i = 0; i < widget.currentMonthCompletions.length; i++) {
      if (widget.currentMonthCompletions[i]) {
        completedDays.add(DateTime(year, month, i + 1));
      }
    }

    return TableCalendar(
      rowHeight: 45,
      firstDay: _firstDay,
      lastDay: _lastDay,
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
      calendarStyle: CalendarStyle(
        defaultTextStyle: const TextStyle(color: Colors.black),
        todayTextStyle: const TextStyle(color: Colors.white),
      ),
      headerStyle: const HeaderStyle(
        titleTextStyle: TextStyle(color: Colors.black),
        formatButtonVisible: false,
        titleCentered: true,
        leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
        rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, focusDay) {
          final DateTime today = DateTime.now();
          final bool isMarked = _underlinedDays.any(
                (d) => d.year == day.year && d.month == day.month && d.day == day.day,
          );

          final int dayIndex = day.day - 1;
          final bool isCompleted = day.month == today.month &&
              day.year == today.year &&
              dayIndex >= 0 &&
              dayIndex < widget.currentMonthCompletions.length &&
              widget.currentMonthCompletions[dayIndex];

          if (isMarked && day.isBefore(DateTime(today.year, today.month, today.day)) && !isCompleted) {
            return Positioned(
              bottom: 6,
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }

          if (isMarked) {
            final bool isToday = isSameDay(day, DateTime.now());
            return Positioned(
              bottom: 6,
              child: Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: isToday ? Colors.white : AppColors.lightActive,
                  shape: BoxShape.circle
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
        todayBuilder: (context, day, focusedDay) {
          return Container(
            height: 45.sp,
            width: 45.sp,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.bNormal,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${day.day}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );


  }
}
