import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_assets.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';

class NoticeTrainingPage extends StatefulWidget {
  const NoticeTrainingPage({super.key});

  @override
  State<NoticeTrainingPage> createState() => _NoticeTrainingPageState();
}

class _NoticeTrainingPageState extends State<NoticeTrainingPage> {
  bool _hasNotifications = false; // This would come from API/state management

  // Mock data - would come from API
  final List<TrainingNotification> _notifications = [
    TrainingNotification(
      title: "Tập chân",
      time: "15:00",
      days: "Hằng ngày",
      isActive: true,
    ),
  ];

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
              padding: EdgeInsets.only(left: 30.w, right: 10.w, top: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeader(),
                  SizedBox(height: 20.h),
                  _buildContent(),
                ],
              ),
            ),
            _buildAddButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 40.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back_ios, color: AppColors.bNormal),
            ),
          ),
          if (_hasNotifications)
            Center(
              child: Text(
                "Nhắc nhở luyện tập",
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (!_hasNotifications) {
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(TrainingAssets.noticeTraining),
            SizedBox(height: 20.h),
            Text(
              "Nhắc Nhở Luyện Tập",
              style: TextStyle(
                fontSize: 24.sp,
                color: AppColors.dark,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "Giúp bạn duy trì thói quen tập luyện đều đặn bằng\n"
              "cách gửi thông báo nhắc nhở vào thời gian phù hợp \n"
              "trong ngày.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: AppColors.lightActive),
            ),
          ],
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: _notifications.length,
          itemBuilder: (context, index) {
            final notification = _notifications[index];
            return _buildNotificationCard(notification, index);
          },
        ),
      );
    }
  }

  Widget _buildNotificationCard(TrainingNotification notification, int index) {
    return Container(
      margin: EdgeInsets.only(right: 15.w, bottom: 16.h),
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
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.bNormal,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppDimensions.borderRadius),
              ),
            ),
            child: Text(
              notification.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.wWhite,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ),
          // Main content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.time,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      notification.days,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.lightActive,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Transform.scale(
                  scale: 0.9,
                  child: Switch(
                    value: notification.isActive,
                    onChanged: (value) {
                      setState(() {
                        _notifications[index] = notification.copyWith(
                          isActive: value,
                        );
                      });
                    },
                    activeTrackColor: AppColors.bNormal,
                    activeColor: AppColors.wWhite,
                    inactiveTrackColor: AppColors.moreLighter,
                    inactiveThumbColor: AppColors.wWhite,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.bLightHover),
          // Action buttons
          SizedBox(
            height: 50.h,
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => _deleteNotification(index),
                    child: const Text(
                      'Xóa',
                      style: TextStyle(color: AppColors.bNormal),
                    ),
                  ),
                ),
                const VerticalDivider(width: 1, color: AppColors.bLightHover),
                Expanded(
                  child: TextButton(
                    onPressed: () => _editNotification(index),
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

  Widget _buildAddButton() {
    return Positioned(
      left: 30.w,
      right: 10.w,
      bottom: 30.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.bNormal,
          minimumSize: Size(double.infinity, 55.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppDimensions.borderRadiusLarge,
            ),
          ),
        ),
        onPressed: _addNotification,
        child: Text(
          "Thêm",
          style: TextStyle(fontSize: 20.sp, color: AppColors.wWhite),
        ),
      ),
    );
  }

  void _addNotification() {
    // Navigate to create notification page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NoticeTrainingCreationPage(),
      ),
    ).then((result) {
      if (result != null && result is TrainingNotification) {
        setState(() {
          _notifications.add(result);
          _hasNotifications = true;
        });
      }
    });
  }

  void _editNotification(int index) {
    // Navigate to edit notification page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            NoticeTrainingCreationPage(notification: _notifications[index]),
      ),
    ).then((result) {
      if (result != null && result is TrainingNotification) {
        setState(() {
          _notifications[index] = result;
        });
      }
    });
  }

  void _deleteNotification(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa lời nhắc này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _notifications.removeAt(index);
                if (_notifications.isEmpty) {
                  _hasNotifications = false;
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// Simple creation page (placeholder)
class NoticeTrainingCreationPage extends StatelessWidget {
  final TrainingNotification? notification;

  const NoticeTrainingCreationPage({super.key, this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(notification == null ? 'Tạo lời nhắc' : 'Sửa lời nhắc'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Trang tạo/sửa lời nhắc'),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () {
                // Return mock data
                Navigator.pop(
                  context,
                  TrainingNotification(
                    title: "Tập mới",
                    time: "16:00",
                    days: "Thứ 2, 4, 6",
                    isActive: true,
                  ),
                );
              },
              child: Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }
}

// Data models
class TrainingNotification {
  final String title;
  final String time;
  final String days;
  final bool isActive;

  TrainingNotification({
    required this.title,
    required this.time,
    required this.days,
    required this.isActive,
  });

  TrainingNotification copyWith({
    String? title,
    String? time,
    String? days,
    bool? isActive,
  }) {
    return TrainingNotification(
      title: title ?? this.title,
      time: time ?? this.time,
      days: days ?? this.days,
      isActive: isActive ?? this.isActive,
    );
  }
}
