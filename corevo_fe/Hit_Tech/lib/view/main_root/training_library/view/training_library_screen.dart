import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/model/response/training/training_plan_response.dart';
import 'package:hit_tech/service/training_service.dart';
import 'package:hit_tech/view/main_root/training_library/view/widgets/training_library_exercise_widget.dart';
import 'package:hit_tech/view/main_root/training_library/view/widgets/training_library_plan_detail_widget.dart';
import 'package:hit_tech/view/main_root/training_library/view/widgets/training_library_search.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_dimension.dart';

class TrainingLibraryScreen extends StatefulWidget {
  const TrainingLibraryScreen({super.key});

  @override
  State<TrainingLibraryScreen> createState() => _TrainingLibraryScreenState();
}

class _TrainingLibraryScreenState extends State<TrainingLibraryScreen> {
  int selectedIndex = 0;
  bool _isLoading = true;
  String? selectedFilter;

  List<TrainingPlanResponse> trainingPlanLoseFat = [];
  List<TrainingPlanResponse> trainingPlanGainWeight = [];
  List<TrainingPlanResponse> trainingPlanGainMuscle = [];
  List<TrainingPlanResponse> trainingPlanMaintainBody = [];
  List<TrainingPlanResponse> trainingPlanIncreaseEndurance = [];
  List<TrainingPlanResponse> trainingPlanImproveCardiovascular = [];
  List<TrainingPlanResponse> trainingPlanStressRelief = [];
  List<TrainingPlanResponse> trainingPlanIncreaseHeight = [];

  List<TrainingPlanResponse> trainingPlanByType = [];
  List<String> targetMuscleCategory = [
    AppAssets.chestCategory,
    AppAssets.backCategory,
    AppAssets.shouldersCategory,
    AppAssets.bicepCategory,
    AppAssets.tricepCategory,
    AppAssets.absCategory,
    AppAssets.gluteCategory,
    AppAssets.quadsCategory,
    AppAssets.hamstringCategory,
    AppAssets.cardioCategory,
    AppAssets.yogaCategory,
    AppAssets.calisthenicCategory,
  ];

  @override
  void initState() {
    super.initState();
    _handleGetAllTrainingPlan();
  }

  Future<void> _handleGetAllTrainingPlan() async {
    try {
      final response = await TrainingService.getAllTrainingPlan(1, 23);

      if (response.status == 'SUCCESS') {
        setState(() {
          trainingPlanLoseFat.addAll([
            response.items[0],
            response.items[1],
            response.items[2],
          ]);
          trainingPlanGainWeight.addAll([response.items[3], response.items[4]]);
          trainingPlanGainMuscle.addAll([
            response.items[5],
            response.items[6],
            response.items[7],
          ]);
          trainingPlanMaintainBody.addAll([
            response.items[8],
            response.items[9],
            response.items[10],
          ]);
          trainingPlanIncreaseEndurance.addAll([
            response.items[11],
            response.items[12],
            response.items[13],
          ]);
          trainingPlanImproveCardiovascular.addAll([
            response.items[14],
            response.items[15],
            response.items[16],
          ]);
          trainingPlanStressRelief.addAll([
            response.items[17],
            response.items[18],
            response.items[19],
          ]);
          trainingPlanIncreaseHeight.addAll([
            response.items[20],
            response.items[21],
            response.items[22],
          ]);
          _isLoading = false;
        });
        return;
      }
    } catch (e, stackTrace) {
      print(stackTrace);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleGetTrainingPlanByType() async {
    try {
      final response = await TrainingService.getTrainingPlanByType(
        selectedFilter!,
        1,
        23,
      );

      if (response.status == 'SUCCESS') {
        setState(() {
          trainingPlanByType.clear();
          trainingPlanByType.addAll(response.items);
        });
        return;
      }
    } catch (e, stackTrace) {
      print(stackTrace);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bLight,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    AppAssets.libraryBackground1,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: AppDimensions.spacingHuge),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTab("Kế hoạch luyện tập", 0),
                        SizedBox(width: AppDimensions.spacingML),
                        _buildTab("Các bài tập", 1),
                      ],
                    ),
                    SizedBox(height: AppDimensions.spacingL),
                    _buildSearchBar(),
                    SizedBox(height: AppDimensions.spacingXL),
                    (selectedIndex == 0)
                        ? Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom: AppDimensions.size80,
                                  top: AppDimensions.spacingSM,
                                ),
                                child: Column(
                                  children: [
                                    buildTrainingPlanSection(
                                      title: normalizePlanName(
                                        trainingPlanLoseFat.first.goals,
                                      ),
                                      plans: (trainingPlanLoseFat).map((plan) {
                                        return _buildTrainingPlanItem(plan);
                                      }).toList(),
                                    ),
                                    SizedBox(height: AppDimensions.spacingML),
                                    buildTrainingPlanSection(
                                      title: normalizePlanName(
                                        trainingPlanGainWeight.first.goals,
                                      ),
                                      plans: (trainingPlanGainWeight).map((
                                        plan,
                                      ) {
                                        return _buildTrainingPlanItem(plan);
                                      }).toList(),
                                    ),
                                    SizedBox(height: AppDimensions.spacingML),
                                    buildTrainingPlanSection(
                                      title: normalizePlanName(
                                        trainingPlanGainMuscle.first.goals,
                                      ),
                                      plans: (trainingPlanGainMuscle).map((
                                        plan,
                                      ) {
                                        return _buildTrainingPlanItem(plan);
                                      }).toList(),
                                    ),
                                    SizedBox(height: AppDimensions.spacingML),
                                    buildTrainingPlanSection(
                                      title: normalizePlanName(
                                        trainingPlanMaintainBody.first.goals,
                                      ),
                                      plans: (trainingPlanMaintainBody).map((
                                        plan,
                                      ) {
                                        return _buildTrainingPlanItem(plan);
                                      }).toList(),
                                    ),
                                    SizedBox(height: AppDimensions.spacingML),
                                    buildTrainingPlanSection(
                                      title: normalizePlanName(
                                        trainingPlanIncreaseEndurance
                                            .first
                                            .goals,
                                      ),
                                      plans: (trainingPlanIncreaseEndurance)
                                          .map((plan) {
                                            return _buildTrainingPlanItem(plan);
                                          })
                                          .toList(),
                                    ),
                                    SizedBox(height: AppDimensions.spacingML),
                                    buildTrainingPlanSection(
                                      title: normalizePlanName(
                                        trainingPlanImproveCardiovascular
                                            .first
                                            .goals,
                                      ),
                                      plans: (trainingPlanImproveCardiovascular)
                                          .map((plan) {
                                            return _buildTrainingPlanItem(plan);
                                          })
                                          .toList(),
                                    ),
                                    SizedBox(height: AppDimensions.spacingML),
                                    buildTrainingPlanSection(
                                      title: normalizePlanName(
                                        trainingPlanStressRelief.first.goals,
                                      ),
                                      plans: (trainingPlanStressRelief).map((
                                        plan,
                                      ) {
                                        return _buildTrainingPlanItem(plan);
                                      }).toList(),
                                    ),
                                    SizedBox(height: AppDimensions.spacingML),
                                    buildTrainingPlanSection(
                                      title: normalizePlanName(
                                        trainingPlanIncreaseHeight.first.goals,
                                      ),
                                      plans: (trainingPlanIncreaseHeight).map((
                                        plan,
                                      ) {
                                        return _buildTrainingPlanItem(plan);
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom: AppDimensions.size48,
                                  top: AppDimensions.spacingSM,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppDimensions.paddingM,
                                  ),
                                  child: Column(
                                    children: [
                                      _buildTargetMuscleCategory('Ngực', 20, 0),
                                      SizedBox(height: AppDimensions.spacingML),
                                      _buildTargetMuscleCategory('Lưng', 20, 1),
                                      SizedBox(height: AppDimensions.spacingML),
                                      _buildTargetMuscleCategory('Vai', 20, 2),
                                      SizedBox(height: AppDimensions.spacingML),
                                      _buildTargetMuscleCategory(
                                        'Tay trước',
                                        20,
                                        3,
                                      ),
                                      SizedBox(height: AppDimensions.spacingML),
                                      _buildTargetMuscleCategory(
                                        'Tay sau',
                                        20,
                                        4,
                                      ),
                                      SizedBox(height: AppDimensions.spacingML),
                                      _buildTargetMuscleCategory('Bụng', 20, 5),
                                      SizedBox(height: AppDimensions.spacingML),
                                      _buildTargetMuscleCategory('Mông', 20, 6),
                                      SizedBox(height: AppDimensions.spacingML),
                                      _buildTargetMuscleCategory(
                                        'Đùi trước',
                                        20,
                                        7,
                                      ),
                                      SizedBox(height: AppDimensions.spacingML),
                                      _buildTargetMuscleCategory(
                                        'Đùi sau',
                                        20,
                                        8,
                                      ),
                                      SizedBox(height: AppDimensions.spacingML),
                                      _buildTypeCategory('Cardio', 20, 9),
                                      SizedBox(height: AppDimensions.spacingML),
                                      _buildTypeCategory('Yoga', 20, 10),
                                      SizedBox(height: AppDimensions.spacingML),
                                      _buildTypeCategory('Calisthenic', 20, 11),
                                      SizedBox(height: AppDimensions.spacingXL),
                                    ],
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

  Widget _buildTab(String text, int index) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = null;
          selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: TextStyle(
              fontSize: isSelected
                  ? AppDimensions.textSizeXL
                  : AppDimensions.textSizeM,
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
            child: Text(text),
          ),
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: EdgeInsets.only(top: AppDimensions.paddingXS),
              height: AppDimensions.size4,
              width: isSelected ? AppDimensions.size80 : 0,
              decoration: BoxDecoration(
                color: AppColors.dark,
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusLarge,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Hero(
      tag: 'searchBar',
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: AppDimensions.size48,
          margin: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
          decoration: BoxDecoration(
            color: const Color(0xFFD3EDFF),
            borderRadius: BorderRadius.circular(
              AppDimensions.borderRadiusLarge,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(
              AppDimensions.borderRadiusLarge,
            ),
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => TrainingLibrarySearch(),
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              );
            },
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: AppColors.lightHover,
                  size: AppDimensions.iconSizeL,
                ),
                SizedBox(width: AppDimensions.spacingS),
                Text(
                  'Tìm kiếm bài tập, kế hoạch...',
                  style: TextStyle(
                    fontSize: AppDimensions.textSizeS,
                    color: AppColors.lightHover,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrainingPlanItem(TrainingPlanResponse plan) {
    return Container(
      width: AppDimensions.size304,
      height: AppDimensions.size200,
      margin: EdgeInsets.only(right: AppDimensions.paddingM),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        image: DecorationImage(
          image: AssetImage(AppAssets.trainingPlan1),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Lớp overlay gradient để dễ đọc chữ
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusLarge,
                ),
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          // Nội dung
          Padding(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            child: Stack(
              children: [
                // Bên dưới (nút ở góc phải)
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TrainingLibraryPlanDetailWidget(plan: plan),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightHover.withOpacity(0.6),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingS,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.borderRadiusLarge,
                        ),
                      ),
                    ),
                    child: Text(
                      'Bắt đầu',
                      style: TextStyle(
                        color: AppColors.wWhite,
                        fontSize: AppDimensions.textSizeS,
                      ),
                    ),
                  ),
                ),
                // Bên trái (2 dòng text)
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name,
                        style: TextStyle(
                          fontSize: AppDimensions.textSizeL,
                          fontWeight: FontWeight.bold,
                          color: AppColors.wWhite,
                        ),
                      ),
                      SizedBox(height: AppDimensions.size4),
                      SizedBox(
                        width: AppDimensions.size184,
                        child: Text(
                          plan.description,
                          style: TextStyle(
                            fontSize: AppDimensions.textSizeXS,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTrainingPlanSection({
    required String title,
    required List<Widget> plans,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: AppDimensions.paddingM),
          child: Text(
            title,
            style: TextStyle(
              fontSize: AppDimensions.textSizeM,
              fontWeight: FontWeight.w500,
              color: AppColors.dark,
            ),
          ),
        ),
        SizedBox(height: AppDimensions.size4),
        Padding(
          padding: EdgeInsets.only(left: AppDimensions.paddingM),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: plans),
          ),
        ),
      ],
    );
  }

  Widget _buildTargetMuscleCategory(
    String categoryName,
    int numberOfExercise,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrainingLibraryExerciseWidget(
              primaryMuscleToQuery: normalizeTargetMuscleName(categoryName),
              primaryMuscle: categoryName.toUpperCase(),
              typeToQuery: '',
              type: '',
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Image.asset(targetMuscleCategory[index], fit: BoxFit.cover),

          Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppDimensions.paddingXXL + 2.w,
              horizontal: AppDimensions.paddingXL,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categoryName,
                  style: TextStyle(
                    color: AppColors.wWhite,
                    fontSize: AppDimensions.textSizeXL,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeCategory(
    String categoryName,
    int numberOfExercise,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrainingLibraryExerciseWidget(
              typeToQuery: normalizeTargetMuscleName(categoryName),
              type: categoryName.toUpperCase(),
              primaryMuscleToQuery: '',
              primaryMuscle: '',
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Image.asset(targetMuscleCategory[index], fit: BoxFit.cover),

          Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppDimensions.paddingXXL,
              horizontal: AppDimensions.paddingXL,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categoryName,
                  style: TextStyle(
                    color: AppColors.wWhite,
                    fontSize: AppDimensions.textSizeXL,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String normalizePlanName(String vietnameseName) {
    const mapping = {
      "Lose fat": "Giảm cân / Giảm mỡ",
      "Gain weight": "Tăng cân",
      "Gain muscle": "Tăng cơ",
      "Maintain Body": "Duy trì vóc dáng",
      "Increase endurance": "Tăng sức bền",
      "Improve cardiovascular": "Cải thiện tim mạch",
      "Stress relief/relaxation": "Giảm stress, thư giãn",
      "Increase height": "Tăng chiều cao",
    };

    return mapping[vietnameseName] ?? vietnameseName;
  }

  String normalizeTargetMuscleName(String vietnameseName) {
    const mapping = {
      "Ngực": "Chest",
      "Lưng": "Back",
      "Vai": "Shoulders",
      "Tay trước": "Biceps",
      "Tay sau": "Triceps",
      "Bụng": "Abs",
      "Mông": "Glutes",
      "Đùi trước": "Quads",
      "Đùi sau": "Hamstrings",
      "Cardio": "Cardio",
      "Yoga": "Yoga",
      "Calisthenic": "Calisthenic",
    };

    return mapping[vietnameseName] ?? vietnameseName;
  }
}
