import 'package:flutter/material.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';
import 'package:hit_tech/view/training_flow/widget/training_location_selection_widget.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_color.dart';
import '../../../model/request/training_flow_request.dart';
import '../../../service/training_flow_service.dart';

class TrainingFrequencySelectionWidget extends StatefulWidget {
  final String? nextStep;
  final Map<String, List<String>> selectedValues;
  final List<String> options;

  const TrainingFrequencySelectionWidget({
    Key? key,
    required this.nextStep,
    required this.selectedValues,
    required this.options,
  }) : super(key: key);

  @override
  _TrainingFrequencySelectionState createState() =>
      _TrainingFrequencySelectionState();
}

class _TrainingFrequencySelectionState
    extends State<TrainingFrequencySelectionWidget> {
  int selectedIndex = 0;

  String? get currentStep => widget.nextStep;

  Map<String, List<String>> get selectedValues => widget.selectedValues;

  List<String> get options => widget.options;

  final List<String> soBuoi = ['1', '2', '3', '4', '5+'];
  final List<String> moTa = [
    '"Tôi rất bận rộn, chỉ muốn tập 1 lần mỗi tuần cho đỡ cứng người."',
    '“Tôi muốn bắt đầu nhẹ nhàng, có thời gian thư giãn và chăm sóc bản thân.”',
    '“Tôi đang cố gắng duy trì thói quen tập luyện đều đặn mỗi tuần.”',
    '“Tôi muốn nâng cao thể lực và cảm thấy cơ thể khỏe mạnh hơn từng ngày.”',
    '“Vận động là một phần không thể thiếu trong cuộc sống của tôi.”',
  ];
  final List<String> hinhAnhLich = [
    TrainingAssets.frequency1,
    TrainingAssets.frequency2,
    TrainingAssets.frequency3,
    TrainingAssets.frequency4,
    TrainingAssets.frequency5,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bLight,
      body: Stack(
        children: [
          // Ảnh nền
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
                            final progress = 5 / 7;
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
              SizedBox(height: 30),
              // Header
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  color: AppColors.bLightHover,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusSmall,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20.0,
                      height: 90.0,
                      decoration: BoxDecoration(color: AppColors.bLightActive2),
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: Text(
                        'Bạn thường tập luyện\nbao nhiêu ngày trong tuần?',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkActive,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 70),

              Image.asset(hinhAnhLich[selectedIndex], width: 120, height: 120),
              const SizedBox(height: 25),

              Text(
                '${soBuoi[selectedIndex]} buổi / tuần',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  moTa[selectedIndex],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: AppColors.dark),
                ),
              ),
              const SizedBox(height: 62),
              // Progress Dots
              Container(
                height: 30,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[100],
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusLarge,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(hinhAnhLich.length, (index) {
                    bool isSelected = index == selectedIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: isSelected ? 24 : 16,
                        height: isSelected ? 24 : 16,
                        decoration: BoxDecoration(
                          color: AppColors.bNormal,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.white, width: 5)
                              : null,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                  ),
                                ]
                              : [],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),

          // Overlay mờ dần từ dưới lên
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [AppColors.wWhite, Colors.transparent],
                    stops: [0.0, 0.0],
                  ),
                ),
              ),
            ),
          ),

          // Button "Tiếp tục" nổi lên trên cùng
          Positioned(
            left: 16,
            right: 16,
            bottom: 70,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedIndex != null
                    ? AppColors.bNormal
                    : AppColors.bLightNotActive,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: selectedIndex != null
                  ? () async {
                final request = TrainingFlowRequest(
                  currentStep: currentStep,
                  selectedValue: options,
                  selectedValues: selectedValues,
                );

                try {
                  final response = await TrainingFlowService.sendStep(
                    request,
                  );

                  var selectedValues = response.selectedValues;

                  print(response.nextStep);
                  print(selectedValues);
                  print(response.options);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TrainingLocationSelectionWidget(
                        nextStep: response.nextStep,
                        selectedValues: selectedValues,
                        options: response.options,
                      ),
                    ),
                  );
                } catch (e) {
                  print("Error: $e");
                }
              }
                  : null,
              child: Text(
                "Tiếp tục",
                style: TextStyle(
                  fontSize: 20,
                  color: selectedIndex != null
                      ? AppColors.wWhite
                      : AppColors.wDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
