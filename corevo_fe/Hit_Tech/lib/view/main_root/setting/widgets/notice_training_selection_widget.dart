import 'package:flutter/material.dart';
import 'package:hit_tech/core/constants/app_assets.dart';

import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_dimension.dart';

class NoticeTrainingSelectionWidget extends StatelessWidget {
  bool _isCheck = false;

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
                left: 30.0,
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
                        // Icon bên trái
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.bNormal,
                          ),
                        ),

                        // Text ở giữa, chỉ hiển thị khi _isCheck = true
                        if (_isCheck)
                          Center(
                            child: Text(
                              "Nhắc nhở luyện tập",
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
                  !_isCheck
                      ? Image.asset(TrainingAssets.noticeTraining)
                      : _buildNotice(
                          title: "Tập chân",
                          time: "15:00",
                          days: "Hằng ngày",
                          isActive: true,
                          onDelete: () {},
                          onEdit: () {},
                          onToggle: (value) {},
                        ),
                  const SizedBox(height: 20),
                  if (!_isCheck)
                    Text(
                      "Nhắc Nhở Luyện Tập",
                      style: TextStyle(
                        fontSize: 24,
                        color: AppColors.dark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (!_isCheck)
                    Text(
                      "Giúp bạn duy trì thói quen tập luyện đều đặn bằng\n"
                      "cách gửi thông báo nhắc nhở vào thời gian phù hợp \n"
                      "trong ngày.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.lightActive,
                      ),
                    ),
                ],
              ),
            ),

            // Button dưới cùng
            Positioned(
              left: 30,
              right: 10,
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
                  "Thêm",
                  style: TextStyle(fontSize: 20, color: AppColors.wWhite),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotice({
    required String title,
    required String time,
    required String days,
    required bool isActive,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    required ValueChanged<bool> onToggle,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        color: AppColors.wWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Title bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.bNormal,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppDimensions.borderRadius),
              ),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.wWhite,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          // Main content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      days,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.lightActive,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Transform.scale(
                  scale: 0.9,
                  child: Switch(
                    value: isActive,
                    onChanged: onToggle,
                    activeTrackColor: AppColors.bNormal,
                    // màu track khi bật
                    activeColor: AppColors.wWhite,
                    // màu nút tròn khi bật
                    inactiveTrackColor: AppColors.moreLighter,
                    // màu track khi tắt
                    inactiveThumbColor:
                        AppColors.wWhite, // màu nút tròn khi tắt
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.bLightHover),

          // Action buttons
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: onDelete,
                    child: const Text(
                      'Xóa',
                      style: TextStyle(color: AppColors.bNormal),
                    ),
                  ),
                ),
                const VerticalDivider(width: 1, color: AppColors.bLightHover),
                Expanded(
                  child: TextButton(
                    onPressed: onEdit,
                    child: const Text(
                      'Sửa',
                      style: TextStyle(color: AppColors.bNormal),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
