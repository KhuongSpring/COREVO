import 'package:flutter/material.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';
import 'package:hit_tech/view/training_flow/widget/training_location_selection_widget.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_color.dart';
import '../../../model/request/training/training_flow_request.dart';
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
    AppAssets.frequency1,
    AppAssets.frequency2,
    AppAssets.frequency3,
    AppAssets.frequency4,
    AppAssets.frequency5,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bLight,
      body: Stack(
        children: [
          // Ảnh nền
          Positioned.fill(
            child: Image.asset(AppAssets.mainBackground, fit: BoxFit.cover),
          ),

          Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: AppDimensions.size48,
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
              SizedBox(height: AppDimensions.spacingXL),
              // Header
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                ),
                decoration: BoxDecoration(
                  color: AppColors.bLightHover,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusSmall,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: AppDimensions.size16,
                      height: AppDimensions.size88,
                      decoration: BoxDecoration(color: AppColors.bLightActive2),
                    ),
                    SizedBox(width: AppDimensions.size16),
                    Expanded(
                      child: Text(
                        'Bạn thường tập luyện\nbao nhiêu ngày trong tuần?',
                        style: TextStyle(
                          fontSize: AppDimensions.textSizeXL,
                          fontWeight: FontWeight.w600,
                          color: AppColors.dark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppDimensions.spacingXXL),

              Image.asset(
                hinhAnhLich[selectedIndex],
                width: AppDimensions.size120,
                height: AppDimensions.size120,
              ),
              SizedBox(height: AppDimensions.spacingL),

              Text(
                '${soBuoi[selectedIndex]} buổi / tuần',
                style: TextStyle(
                  fontSize: AppDimensions.textSizeL,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
              ),
              SizedBox(height: AppDimensions.spacingML),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingL,
                ),
                child: Text(
                  moTa[selectedIndex],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppDimensions.textSizeM,
                    color: AppColors.dark,
                  ),
                ),
              ),
              SizedBox(height: AppDimensions.spacingGiant),
              // Progress Dots
              Container(
                height: AppDimensions.size32,
                margin: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingXL,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingS,
                ),
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
                        width: isSelected
                            ? AppDimensions.iconSizeXL
                            : AppDimensions.iconSizeL,
                        height: isSelected
                            ? AppDimensions.iconSizeXL
                            : AppDimensions.iconSizeM,
                        decoration: BoxDecoration(
                          color: AppColors.bNormal,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(
                                  color: AppColors.wWhite,
                                  width: AppDimensions.size4,
                                )
                              : null,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: AppDimensions.size4,
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
            left: AppDimensions.paddingM,
            right: AppDimensions.paddingM,
            bottom: AppDimensions.size72,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedIndex != null
                    ? AppColors.bNormal
                    : AppColors.bLightNotActive,
                minimumSize: Size(
                  AppDimensions.spacingWidthInfinite,
                  AppDimensions.size56,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusLarge,
                  ),
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
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) =>
                                TrainingLocationSelectionWidget(
                                  nextStep: response.nextStep,
                                  selectedValues: selectedValues,
                                  options: response.options,
                                ),
                            transitionsBuilder: (_, animation, __, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
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
                  fontSize: AppDimensions.textSizeL,
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
