import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/model/response/training/training_plan_response.dart';
import 'package:hit_tech/service/training_service.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_dimension.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
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
                    TrainingAssets.libraryBackground,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(height: 52),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTab("Kế hoạch luyện tập", 0),
                        const SizedBox(width: 20),
                        _buildTab("Các bài tập", 1),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSearchBar(),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildFilterButton("Gym"),
                          _buildFilterButton("Cardio"),
                          _buildFilterButton("Yoga"),
                          _buildFilterButton("Calisthenic", isCalis: true),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 80),
                          child: selectedFilter != null
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: [
                                        ...trainingPlanByType
                                            .map(
                                              (plan) =>
                                                  _buildTrainingPlanItem2(plan),
                                            )
                                            .toList(),
                                      ],
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    buildTrainingPlanSection(
                                      title: normalizePlanName(
                                        trainingPlanLoseFat.first.goals,
                                      ),
                                      plans: (trainingPlanLoseFat).map((plan) {
                                        return _buildTrainingPlanItem(plan);
                                      }).toList(),
                                    ),
                                    const SizedBox(height: 20),
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
                                    const SizedBox(height: 20),
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
                                    const SizedBox(height: 20),
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
                                    const SizedBox(height: 20),
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
                                    const SizedBox(height: 20),
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
                                    const SizedBox(height: 20),
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
                                    const SizedBox(height: 20),
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
          selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: TextStyle(
              fontSize: isSelected ? 24 : 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            child: Text(text),
          ),
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(top: 4),
              height: 3,
              width: isSelected ? 80 : 0,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFD3EDFF),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.lightHover, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm bài tập, kế hoạch...',
                hintStyle: const TextStyle(color: AppColors.lightHover),
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 14, color: AppColors.dark),
              onChanged: (value) {
                // TODO: search logic
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, {bool isCalis = false}) {
    final bool selected = selectedFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedFilter == label) {
            selectedFilter = null;
          } else {
            selectedFilter = label;
            _handleGetTrainingPlanByType();
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isCalis ? 10 : 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.bLightActive2 : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 250),
          style: TextStyle(
            fontSize: selected ? 14 : 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.black,
          ),
          child: Text(label),
        ),
      ),
    );
  }

  Widget _buildTrainingPlanItem(TrainingPlanResponse plan) {
    return Container(
      width: 300,
      height: 200,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(TrainingAssets.trainingPlan1),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Lớp overlay gradient để dễ đọc chữ
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
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
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                // Bên dưới (nút ở góc phải)
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // xử lý khi nhấn "Bắt đầu"
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightHover.withOpacity(0.6),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Bắt đầu',
                      style: TextStyle(color: Colors.white),
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
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 180,
                        child: Text(
                          plan.description,
                          style: TextStyle(fontSize: 12, color: Colors.white70),
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

  Widget _buildTrainingPlanItem2(TrainingPlanResponse plan) {
    return Container(
      width: 380.sp,
      height: 200,
      margin: const EdgeInsets.only(right: 16, bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(TrainingAssets.trainingPlan1),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Lớp overlay gradient để dễ đọc chữ
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
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
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                // Bên dưới (nút ở góc phải)
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // xử lý khi nhấn "Bắt đầu"
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightHover.withOpacity(0.6),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Bắt đầu',
                      style: TextStyle(color: Colors.white),
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
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 250.sp,
                        child: Text(
                          plan.description,
                          style: TextStyle(fontSize: 12, color: Colors.white70),
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
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.dark,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: plans),
          ),
        ),
      ],
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
}
