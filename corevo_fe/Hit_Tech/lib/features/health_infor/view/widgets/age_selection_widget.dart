import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/health_bloc.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/heath_event.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/heath_state.dart';

class AgeSelectionWidget extends StatefulWidget {
  @override
  _AgeSelectionWidgetState createState() => _AgeSelectionWidgetState();
}

class _AgeSelectionWidgetState extends State<AgeSelectionWidget> {
  late FixedExtentScrollController _scrollController;
  final List<int> years = List.generate(50, (index) => 2025 - index);

  @override
  void initState() {
    super.initState();
    final state = context.read<HealthInfoBloc>().state;
    final currentAge = state is HealthInfoFormState ? state.age : null;
    final initialYear = DateTime.now().year - (currentAge ?? 20);
    final initialIndex = years
        .indexOf(initialYear)
        .clamp(0, years.length - 1)
        .toInt();

    _scrollController = FixedExtentScrollController(initialItem: initialIndex);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HealthInfoBloc, HealthInfoState>(
      builder: (context, state) {
        final formState = state is HealthInfoFormState
            ? state
            : HealthInfoFormState();

        final selectedYearFromState =
            DateTime.now().year - (formState.age ?? 20);
        final selectedYear = years.contains(selectedYearFromState)
            ? selectedYearFromState
            : 2005;

        return Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.bLightNotActive2,
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                ),
                child: Column(
                  children: [
                    Text(
                      'Tuổi',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF07314F),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Nhập tuổi của bạn để điều chỉnh mục tiêu phù hợp với giai đoạn của cơ thể.',
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

              // Year picker
              Expanded(
                child: Center(
                  child: Container(
                    height: 280,
                    child: ListWheelScrollView.useDelegate(
                      controller: _scrollController,
                      itemExtent: 60,
                      perspective: 0.005,
                      diameterRatio: 1.2,
                      physics: FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (index) {
                        final year = years[index];
                        final age = DateTime.now().year - year;
                        context.read<HealthInfoBloc>().add(UpdateAge(age));
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: years.length,
                        builder: (context, index) {
                          final year = years[index];
                          final isSelected = year == selectedYear;

                          return AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.bNormal
                                    : Color(0xFFffff),
                                width: isSelected ? 2 : 1,
                              ),
                              color: isSelected
                                  ? Color(0xFFDCEEFB)
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
                                      : Color(0xFF989DA1),
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

              SizedBox(height: 30),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (formState.age != null) {
                      context.read<HealthInfoBloc>().add(NextStep());
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Vui lòng chọn tuổi')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.bNormal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'Tiếp tục',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
