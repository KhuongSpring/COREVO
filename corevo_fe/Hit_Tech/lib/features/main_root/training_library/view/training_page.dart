import 'package:flutter/material.dart';

import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_dimension.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  bool isSearching = false;
  String? selectedOption;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String dropdownValue = '--';

    return Scaffold(
      appBar: isSearching
          ? null
          : AppBar(
              forceMaterialTransparency: true,
              backgroundColor: AppColors.bLight,
              elevation: 0,
              title: const Text("Các bài tập"),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.bookmark_border),
                  onPressed: () {},
                ),
              ],
            ),
      backgroundColor: AppColors.bLight,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {
            isSearching = false;
          });
        },
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: isSearching ? 8 : 14),
              Row(
                children: [
                  // Ô tìm kiếm
                  Expanded(
                    flex: 5,
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      height: 40,
                      child: TextField(
                        onTap: () {
                          setState(() {
                            isSearching = true;
                          });
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            isSearching = false;
                          });
                        },
                        onSubmitted: (value) {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            isSearching = false;
                          });
                        },
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Tìm kiếm...",
                          hintStyle: TextStyle(fontSize: 14),
                          prefixIcon: const Icon(Icons.search, size: 14),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.bLightActive2,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  if (isSearching)
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            icon: const Icon(Icons.arrow_drop_down),
                            isExpanded: true,
                            items: <String>['--', 'Nhóm cơ', 'Mục tiêu', 'Loại']
                                .map(
                                  (String value) => DropdownMenuItem(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.dark,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              if (!isSearching)
                Expanded(
                  child: Scrollbar(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      children: [_buildProfileSection()],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Build Inner tile
  Widget _buildInnerTile(String imagePath, String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 0),
        leading: Image.asset(imagePath),
        title: Text(title, style: TextStyle(fontSize: 14)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.bDarkHover,
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bLight,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Column(
        children: [
          _buildInnerTile('assets/icons/facebook_icon.png', 'Ngực'),
          _buildInnerTile('assets/icons/facebook_icon.png', 'Vai'),
          _buildInnerTile('assets/icons/facebook_icon.png', 'Lưng'),
          _buildInnerTile('assets/icons/facebook_icon.png', 'Tay trước'),
          _buildInnerTile('assets/icons/facebook_icon.png', 'Tay sau'),
          _buildInnerTile('assets/icons/facebook_icon.png', 'Lưng'),
          _buildInnerTile('assets/icons/facebook_icon.png', 'Mông'),
          _buildInnerTile('assets/icons/facebook_icon.png', 'Đùi trước'),
          _buildInnerTile('assets/icons/facebook_icon.png', 'Đùi sau'),
        ],
      ),
    );
  }
}
