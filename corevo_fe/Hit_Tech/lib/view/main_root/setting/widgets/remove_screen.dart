import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_assets.dart';
import 'package:hit_tech/core/constants/app_color.dart';

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
            child: Image.asset(
              TrainingAssets.mainBackground,
              fit: BoxFit.cover,
            ),
          ),

          // Nội dung
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
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

                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Xóa dữ liệu người dùng',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      const SizedBox(height: 16),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: Colors.white,
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              backgroundColor: Colors.white,
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              childrenPadding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 0,
              ),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.bNormal,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content1,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        content1,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: onConfirm,
                          child: const Text(
                            'Xác nhận',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
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
