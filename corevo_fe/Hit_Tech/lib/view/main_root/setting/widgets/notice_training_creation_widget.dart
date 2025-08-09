import 'package:flutter/material.dart';
import 'package:hit_tech/core/constants/app_assets.dart';

import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_dimension.dart';

class NoticeTrainingCreationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bLight,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                TrainingAssets.mainBackground,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                right: 10.0,
                top: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            color: AppColors.bNormal,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),

                        Center(
                          child: Text(
                            "Tạo lời nhắc",
                            style: TextStyle(
                              color: AppColors.dark,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(),
                  const SizedBox(height: 16),
                  _buildTimeBox(),
                  const SizedBox(height: 16),
                  _buildRepeatBox(),
                ],
              ),
            ),

            // Button dưới cùng
            Positioned(
              left: 30,
              right: 30,
              bottom: 30,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bNormal,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusLarge,
                    ),
                  ),
                ),
                onPressed: () {
                  // Thêm logic
                },
                child: Text(
                  "Xác nhận",
                  style: TextStyle(fontSize: 20, color: AppColors.wWhite),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const TextField(
        style: TextStyle(color: AppColors.dark, fontSize: 14),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Nhập tên lời nhắc',
          hintStyle: TextStyle(color: AppColors.lightHover, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildTimeBox() {
    return Container(
      padding: const EdgeInsets.only(left: 16, top: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Thời gian',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.dark,
                ),
              ),
              const Spacer(),
              Transform.scale(
                scale: 0.9,
                child: Switch(
                  value: true,
                  onChanged: (value) {},
                  activeTrackColor: AppColors.bNormal,
                  // màu track khi bật
                  activeColor: AppColors.wWhite,
                  // màu nút tròn khi bật
                  inactiveTrackColor: AppColors.moreLighter,
                  // màu track khi tắt
                  inactiveThumbColor: AppColors.wWhite, // màu nút tròn khi tắt
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 30),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            margin: EdgeInsets.only(right: 20, bottom: 30),
            decoration: BoxDecoration(
              color: AppColors.bNormal,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '01',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 70),
                Text(
                  ':',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 70),
                Text(
                  '01',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
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

  Widget _buildRepeatBox() {
    final days = ['2', '3', '4', '5', '6', '7', 'CN'];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lặp lại',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.dark,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: days
                .map(
                  (day) => Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.bNormal,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      day,
                      style: const TextStyle(
                        color: AppColors.wWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
