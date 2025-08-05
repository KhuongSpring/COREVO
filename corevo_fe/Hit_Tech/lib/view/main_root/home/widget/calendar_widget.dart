import 'package:flutter/material.dart';
import 'package:hit_tech/utils/mapping_training_resource_helper.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/constants/app_color.dart';
import '../../../../model/response/training/training_schedule_response.dart';

class CalendarWidget extends StatefulWidget {
  final Function(DateTime)? onDaySelected;
  final DateTime? selectedDay;
  List<TrainingScheduleResponse> schedules = [];

  CalendarWidget({
    super.key,
    this.onDaySelected,
    this.selectedDay,
    required this.schedules,
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

    return TableCalendar(
      firstDay: _firstDay,
      lastDay: _lastDay,
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
      onDaySelected: (selected, focused) {
        setState(() {
          _selectedDay = selected;
        });
        widget.onDaySelected?.call(selected);
      },
      calendarStyle: const CalendarStyle(
        defaultTextStyle: TextStyle(color: Colors.black),
        todayTextStyle: TextStyle(color: Colors.white),
        selectedTextStyle: TextStyle(color: Colors.white),
        todayDecoration: BoxDecoration(
          color: AppColors.bNormal,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: AppColors.bNormal,
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: const HeaderStyle(
        titleTextStyle: TextStyle(color: Colors.black),
        formatButtonVisible: false,
        titleCentered: true,
        leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
        rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          final bool isMarked = _underlinedDays.any(
            (d) =>
                d.year == day.year && d.month == day.month && d.day == day.day,
          );

          if (isMarked) {
            final bool isToday = isSameDay(day, DateTime.now());

            return Positioned(
              bottom: 12,
              child: Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: isToday ? Colors.white : AppColors.bNormal,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
