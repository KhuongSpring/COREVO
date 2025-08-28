import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_assets.dart';
import 'package:hit_tech/view/main_root/setting/widgets/notice_training_creation_widget.dart';

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
              child: Image.asset(AppAssets.mainBackground, fit: BoxFit.cover),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: AppDimensions.paddingS,
                right: AppDimensions.paddingS,
                top: AppDimensions.paddingL,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: AppDimensions.size40,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Icon bên trái
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

                        // Text ở giữa, chỉ hiển thị khi _isCheck = true
                        if (_isCheck)
                          Center(
                            child: Text(
                              "Nhắc nhở luyện tập",
                              style: TextStyle(
                                color: AppColors.dark,
                                fontSize: AppDimensions.textSizeL,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacingML),
                  !_isCheck
                      ? Image.asset(AppAssets.noticeTraining)
                      : _buildNotice(
                          title: "Tập chân",
                          time: "15:00",
                          days: "Hằng ngày",
                          isActive: true,
                          onDelete: () {},
                          onEdit: () {},
                          onToggle: (value) {},
                        ),
                  SizedBox(height: AppDimensions.spacingML),
                  if (!_isCheck)
                    Text(
                      "Nhắc Nhở Luyện Tập",
                      style: TextStyle(
                        fontSize: AppDimensions.textSizeXL,
                        color: AppColors.dark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  SizedBox(height: AppDimensions.spacingML),
                  if (!_isCheck)
                    Text(
                      "Giúp bạn duy trì thói quen tập luyện đều đặn bằng\n"
                      "cách gửi thông báo nhắc nhở vào thời gian phù hợp \n"
                      "trong ngày.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppDimensions.textSizeS,
                        color: AppColors.lightActive,
                      ),
                    ),
                ],
              ),
            ),

            // Button dưới cùng
            Positioned(
              left: AppDimensions.spacingXL,
              right: AppDimensions.spacingXL,
              bottom: AppDimensions.spacingXL,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bNormal,
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NoticeTrainingCreationWidget(),
                    ),
                  );
                },
                child: Text(
                  "Thêm",
                  style: TextStyle(
                    fontSize: AppDimensions.textSizeL,
                    color: AppColors.wWhite,
                  ),
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
      margin: EdgeInsets.symmetric(horizontal: AppDimensions.paddingS),
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
            padding: EdgeInsets.all(AppDimensions.spacingSM),
            decoration: BoxDecoration(
              color: AppColors.bNormal,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppDimensions.borderRadius),
              ),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.wWhite,
                fontWeight: FontWeight.bold,
                fontSize: AppDimensions.textSizeM,
              ),
            ),
          ),

          // Main content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
              vertical: AppDimensions.spacingSM,
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: AppDimensions.textSizeXL,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),
                    SizedBox(height: AppDimensions.size4),
                    Text(
                      days,
                      style: TextStyle(
                        fontSize: AppDimensions.textSizeS,
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

          Divider(height: 1.w, color: AppColors.bLightHover),

          // Action buttons
          SizedBox(
            height: AppDimensions.size48,
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: onDelete,
                    child: Text(
                      'Xóa',
                      style: TextStyle(
                        color: AppColors.bNormal,
                        fontSize: AppDimensions.textSizeS,
                      ),
                    ),
                  ),
                ),
                VerticalDivider(width: 1.w, color: AppColors.bLightHover),
                Expanded(
                  child: TextButton(
                    onPressed: onEdit,
                    child: Text(
                      'Sửa',
                      style: TextStyle(
                        color: AppColors.bNormal,
                        fontSize: AppDimensions.textSizeS,
                      ),
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
