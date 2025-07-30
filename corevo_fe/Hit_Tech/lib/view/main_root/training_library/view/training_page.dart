import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_dimension.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bLight,
      body: Stack(
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
                    child: Column(
                      children: [
                        buildTrainingPlanSection(
                          title: "Giảm cân",
                          plans: [
                            _buildTrainingPlanItem(),
                            _buildTrainingPlanItem(),
                            _buildTrainingPlanItem(),
                          ],
                        ),
                        const SizedBox(height: 20),
                        buildTrainingPlanSection(
                          title: "Giảm cân",
                          plans: [
                            _buildTrainingPlanItem(),
                            _buildTrainingPlanItem(),
                          ],
                        ),
                        const SizedBox(height: 20),
                        buildTrainingPlanSection(
                          title: "Giảm cân",
                          plans: [
                            _buildTrainingPlanItem(),
                            _buildTrainingPlanItem(),
                            _buildTrainingPlanItem(),
                          ],
                        ),
                        const SizedBox(height: 20),
                        buildTrainingPlanSection(
                          title: "Giảm cân",
                          plans: [
                            _buildTrainingPlanItem(),
                            _buildTrainingPlanItem(),
                            _buildTrainingPlanItem(),
                          ],
                        ),
                        const SizedBox(height: 20),
                        buildTrainingPlanSection(
                          title: "Giảm cân",
                          plans: [
                            _buildTrainingPlanItem(),
                            _buildTrainingPlanItem(),
                            _buildTrainingPlanItem(),
                          ],
                        ),
                        const SizedBox(height: 20),
                        buildTrainingPlanSection(
                          title: "Giảm cân",
                          plans: [
                            _buildTrainingPlanItem(),
                            _buildTrainingPlanItem(),
                            _buildTrainingPlanItem(),
                          ],
                        ),
                        const SizedBox(height: 20),
                        buildTrainingPlanSection(
                          title: "Giảm cân",
                          plans: [
                            _buildTrainingPlanItem(),
                            _buildTrainingPlanItem(),
                            _buildTrainingPlanItem(),
                          ],
                        ),
                        const SizedBox(height: 20),
                        buildTrainingPlanSection(
                          title: "Giảm cân",
                          plans: [
                            _buildTrainingPlanItem(),
                            _buildTrainingPlanItem(),
                            _buildTrainingPlanItem(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
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

  Widget _buildFilterButton(
    String label, {
    bool selected = false,
    bool isCalis = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: (isCalis) ? 10 : 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildTrainingPlanItem() {
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
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
                    children: const [
                      Text(
                        'Fat Burn Express',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      SizedBox(
                        width: 180,
                        child: Text(
                          'Giúp đốt mỡ, tăng sức bền và bùng nổ năng lượng.',
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
}
