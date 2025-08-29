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
                              fontSize: AppDimensions.textSizeM,
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
                  _buildTextField(),
                  SizedBox(height: AppDimensions.spacingM),
                  _buildTimeBox(),
                  SizedBox(height: AppDimensions.spacingM),
                  _buildRepeatBox(),
                ],
              ),
            ),

            // Button dưới cùng
            Positioned(
              left: AppDimensions.paddingXL,
              right: AppDimensions.paddingXL,
              bottom: AppDimensions.paddingXL,
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
                  // Thêm logic
                },
                child: Text(
                  "Xác nhận",
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

  Widget _buildTextField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppDimensions.paddingS),
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: TextField(
        style: TextStyle(
          color: AppColors.dark,
          fontSize: AppDimensions.textSizeS,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Nhập tên lời nhắc',
          hintStyle: TextStyle(
            color: AppColors.lightHover,
            fontSize: AppDimensions.textSizeS,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeBox() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppDimensions.paddingS),
      padding: EdgeInsets.only(
        left: AppDimensions.paddingM,
        top: AppDimensions.size4,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Thời gian',
                style: TextStyle(
                  fontSize: AppDimensions.textSizeM,
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
              SizedBox(width: AppDimensions.spacingSM),
            ],
          ),
          SizedBox(height: AppDimensions.spacingXL),
          Container(
            width: AppDimensions.spacingWidthInfinite,
            padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
            margin: EdgeInsets.only(
              right: AppDimensions.paddingL,
              bottom: AppDimensions.paddingXL,
            ),
            decoration: BoxDecoration(
              color: AppColors.bNormal,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '01',
                  style: TextStyle(
                    fontSize: AppDimensions.textSizeXL,
                    color: AppColors.wWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: AppDimensions.size72),
                Text(
                  ':',
                  style: TextStyle(
                    fontSize: AppDimensions.textSizeXL,
                    color: AppColors.wWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: AppDimensions.size72),
                Text(
                  '01',
                  style: TextStyle(
                    fontSize: AppDimensions.textSizeXL,
                    color: AppColors.wWhite,
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
      width: AppDimensions.spacingWidthInfinite,
      margin: EdgeInsets.symmetric(horizontal: AppDimensions.paddingS),
      padding: EdgeInsets.symmetric(
        vertical: AppDimensions.paddingM,
        horizontal: AppDimensions.spacingSM,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lặp lại',
            style: TextStyle(
              fontSize: AppDimensions.textSizeM,
              fontWeight: FontWeight.w500,
              color: AppColors.dark,
            ),
          ),
          SizedBox(height: AppDimensions.spacingSM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: days
                .map(
                  (day) => Container(
                    padding: EdgeInsets.all(AppDimensions.spacingSM),
                    decoration: BoxDecoration(
                      color: AppColors.bNormal,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      day,
                      style: TextStyle(
                        color: AppColors.wWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: AppDimensions.textSizeM,
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
