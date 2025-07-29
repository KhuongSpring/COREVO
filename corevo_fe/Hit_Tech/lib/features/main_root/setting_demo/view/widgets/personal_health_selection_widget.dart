import 'package:flutter/material.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_dimension.dart';

class PersonalHealthSelectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bLight,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              TrainingAssets.mainBackground,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 50),
              // Header + Avatar
              Column(
                children: [
                  Stack(
                    children: [
                      Positioned(
                        left: 20,
                        top: 0,
                        bottom: 70,
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.bNormal,
                        ),
                      ),

                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage(
                            TrainingAssets.facebookIcon,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Truong NguyenX',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.normal,
                    ),
                  ),
                  const Text(
                    'nguyenxtruong05@gmail.com',
                    style: TextStyle(fontSize: 12, color: AppColors.lightActive),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Các mục
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [_buildProfileSection()],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Build Inner tile
  Widget _buildInnerTile(IconData icon, String title) {
    return ListTile(
      title: Text(title, style: TextStyle(fontSize: 14)),
      trailing: Text(
        "Check",
        style: TextStyle(color: AppColors.bNormal, fontSize: 14),
      ),
      onTap: () {},
    );
  }

  Widget _buildProfileSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Column(
        children: [
          _buildInnerTile(Icons.person_outline, 'Chiều cao'),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildInnerTile(Icons.favorite_border, 'Cân nặng'),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildInnerTile(Icons.favorite_border, 'Tuổi'),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildInnerTile(Icons.favorite_border, 'Giới tính'),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildInnerTile(Icons.favorite_border, 'Mức độ hoạt động'),
        ],
      ),
    );
  }
}
