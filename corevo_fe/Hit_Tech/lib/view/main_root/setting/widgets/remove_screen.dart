import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_assets.dart';
import 'package:hit_tech/core/constants/app_color.dart';

import '../../../../core/constants/app_dimension.dart';
import '../../../../service/shared_preferences.dart';
import '../../../../service/user_service.dart';
import '../../../auth/login_screen.dart';

class RemoveScreen extends StatefulWidget {
  const RemoveScreen({super.key});

  @override
  State<RemoveScreen> createState() => _RemoveScreenState();
}

class _RemoveScreenState extends State<RemoveScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppAssets.mainBackground, fit: BoxFit.cover),
          ),

          // Nội dung
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingSM,
                    vertical: AppDimensions.spacingSM,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios),
                        ),
                      ),

                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Xóa dữ liệu người dùng',
                          style: TextStyle(
                            fontSize: AppDimensions.textSizeM,
                            fontWeight: FontWeight.bold,
                            color: AppColors.dark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppDimensions.spacingML),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingM,
                  ),
                  child: Column(
                    children: [
                      DeleteOptionTile(
                        title: 'Xóa kế hoạch tập luyện',
                        content1:
                            'Hành động này sẽ xóa toàn bộ kế hoạch luyện tập hiện tại, bao gồm các buổi tập, mục tiêu đã đặt và tiến trình liên quan.',
                        content2:
                            'Bạn có thể tạo kế hoạch mới bất cứ lúc nào sau đó.',
                        onConfirm: () async {
                          try {
                            final response =
                                await UserService.resetPTrainingPlan();

                            if (response.status == 'SUCCESS') {
                              await SharedPreferencesService.logout();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                              return;
                            }
                          } catch (e) {
                            print(e);
                          }
                        },
                      ),
                      SizedBox(height: AppDimensions.spacingM),
                      DeleteOptionTile(
                        title: 'Xóa tài khoản',
                        content1:
                            'Việc xóa tài khoản sẽ loại bỏ toàn bộ dữ liệu cá nhân, bao gồm lịch sử luyện tập, thông tin sức khỏe, và kế hoạch đã lưu.',
                        content2:
                            'Sau khi xóa, bạn sẽ không thể khôi phục lại dữ liệu này.',
                        onConfirm: () async {
                          try {
                            final response =
                                await UserService.deleteMyAccount();

                            if (response.status == 'SUCCESS') {
                              await SharedPreferencesService.clearAll();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                              return;
                            }
                          } catch (e) {
                            print(e);
                          }
                        },
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
}

class DeleteOptionTile extends StatelessWidget {
  final String title;
  final String content1;
  final String content2;
  final VoidCallback onConfirm;

  const DeleteOptionTile({
    super.key,
    required this.title,
    required this.onConfirm,
    required this.content1,
    required this.content2,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        child: Container(
          color: AppColors.wWhite,
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              backgroundColor: AppColors.wWhite,
              tilePadding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingM,
              ),
              title: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: AppDimensions.textSizeM,
                ),
              ),
              childrenPadding: EdgeInsets.symmetric(
                horizontal: 0.w,
                vertical: 0.w,
              ),
              children: [
                Container(
                  width: AppDimensions.spacingWidthInfinite,
                  padding: EdgeInsets.all(AppDimensions.spacingSM),
                  decoration: BoxDecoration(
                    color: AppColors.bNormal,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadius,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content1,
                        style: TextStyle(
                          color: AppColors.wWhite,
                          fontSize: AppDimensions.textSizeS,
                        ),
                      ),
                      SizedBox(height: AppDimensions.spacingSM),
                      Text(
                        content1,
                        style: TextStyle(
                          color: AppColors.wWhite,
                          fontSize: AppDimensions.textSizeS,
                        ),
                      ),
                      SizedBox(height: AppDimensions.spacingSM),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.wWhite,
                            foregroundColor: AppColors.dark,
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingM,
                              vertical: AppDimensions.spacingSM,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.borderRadiusLarge,
                              ),
                            ),
                          ),
                          onPressed: onConfirm,
                          child: Text(
                            'Xác nhận',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppDimensions.textSizeXS,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
