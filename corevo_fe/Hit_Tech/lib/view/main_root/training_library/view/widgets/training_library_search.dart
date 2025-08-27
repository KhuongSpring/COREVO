import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/model/request/training/training_dynamic_search_request.dart';
import 'package:hit_tech/model/response/training/training_exercise_preview_response.dart';
import 'package:hit_tech/service/training_service.dart';
import 'package:hit_tech/utils/mapping_training_resource_helper.dart';
import 'package:hit_tech/view/main_root/training_library/view/widgets/training_library_exercise_detail_widget.dart';
import 'package:hit_tech/view/main_root/training_library/view/widgets/training_library_plan_detail_widget.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../model/response/training/training_exercise_response.dart';
import '../../../../../model/response/training/training_plan_response.dart';
import '../../../../../service/shared_preferences.dart';

class TrainingLibrarySearch extends StatefulWidget {
  const TrainingLibrarySearch({super.key});

  @override
  State<TrainingLibrarySearch> createState() => _TrainingLibrarySearchState();
}

class _TrainingLibrarySearchState extends State<TrainingLibrarySearch> {
  bool _isSearched = false;

  List<String> _history = [];
  final Set<String> _selectedEquipments = {};
  String? _selectedGoal;
  String? _selectedLevel;
  String? _selectedLocation;

  List<String> goalCategoryNoActive = [
    AppAssets.goalCategoryNoActive1,
    AppAssets.goalCategoryNoActive2,
    AppAssets.goalCategoryNoActive3,
    AppAssets.goalCategoryNoActive4,
    AppAssets.goalCategoryNoActive5,
    AppAssets.goalCategoryNoActive6,
    AppAssets.goalCategoryNoActive7,
    AppAssets.goalCategoryNoActive8,
  ];
  List<String> goalCategoryActive = [
    AppAssets.goalCategoryActive1,
    AppAssets.goalCategoryActive2,
    AppAssets.goalCategoryActive3,
    AppAssets.goalCategoryActive4,
    AppAssets.goalCategoryActive5,
    AppAssets.goalCategoryActive6,
    AppAssets.goalCategoryActive7,
    AppAssets.goalCategoryActive8,
  ];

  List<TrainingPlanResponse> trainingPlanResponses = [];
  List<TrainingExercisePreviewResponse> trainingExercisePreviewResponses = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    final history = await SharedPreferencesService.getHistory();
    setState(() {
      _history = history;
    });
  }

  void _clearAllSearchHistory() async {
    await SharedPreferencesService.clearHistory();
    _loadHistory();
  }

  void _removeSearchHistory(String query) async {
    await SharedPreferencesService.removeHistory(query);
    _loadHistory();
  }

  void _onSearch(String query) async {
    if (query.isNotEmpty) {
      await SharedPreferencesService.addHistory(query);
      _loadHistory();

      List<int> levelRequest = [];
      List<int> locationRequest = [];
      List<int> equipmentRequest = [];

      if (_selectedLevel != null && _selectedLevel != '') {
        levelRequest.add(
          MappingTrainingResourceHelper.mappingLevelToId(_selectedLevel!),
        );
      }

      if (_selectedLocation != null && _selectedLocation != '') {
        levelRequest.add(
          MappingTrainingResourceHelper.mappingLocationToId(_selectedLocation!),
        );
      }

      if (_selectedEquipments.isNotEmpty) {
        for (String s in _selectedEquipments) {
          equipmentRequest.add(
            MappingTrainingResourceHelper.mappingEquipmentToId(s),
          );
        }
      }

      _selectedGoal ??= '';

      TrainingDynamicSearchRequest request = TrainingDynamicSearchRequest(
        searchSentence: query,
        levels: levelRequest,
        locations: locationRequest,
        equipments: equipmentRequest,
        goal: MappingTrainingResourceHelper.mappingGoalToEnglish(
          removeNewLine(_selectedGoal!),
        ),
      );

      try {
        final response1 = await TrainingService.searchDynamicTrainingPlan(
          request,
        );

        final response2 = await TrainingService.searchDynamicTrainingExercise(
          request,
        );

        if (response1.status == 'SUCCESS' && response2.status == 'SUCCESS') {
          final List<int> result1 = List<int>.from(response1.data);
          final List<TrainingExercisePreviewResponse> result2 =
              (response2.data as List)
                  .map((e) => TrainingExercisePreviewResponse.fromJson(e))
                  .toList();

          trainingPlanResponses.clear();
          trainingExercisePreviewResponses.clear();

          for (final c in result1) {
            final response = await TrainingService.getTrainingPlanById(c);

            if (response.status == "SUCCESS") {
              trainingPlanResponses.add(
                TrainingPlanResponse.fromJson(response.data),
              );
            }
          }

          setState(() {
            trainingExercisePreviewResponses = result2;
          });
        }
      } catch (e, stackTrace) {
        print(stackTrace);
      }

      setState(() {
        _isSearched = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              AppAssets.mainBackground,
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 100.sp,
                        color: AppColors.bNormal,
                      ),
                    ),
                    Column(
                      children: [
                        Hero(
                          tag: 'searchBar',
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              height: 48,
                              margin: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 30,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD3EDFF),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.search,
                                    color: AppColors.lightHover,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText:
                                            'Tìm kiếm bài tập, kế hoạch...',
                                        hintStyle: const TextStyle(
                                          color: AppColors.lightHover,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.dark,
                                      ),
                                      onSubmitted: _onSearch,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (!_isSearched) ..._buildBeforeSearch(),
                        if (_isSearched)
                          ..._buildAfterSearch(
                            trainingPlanResponses,
                            trainingExercisePreviewResponses,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Back Icon
          Positioned(
            left: 0,
            bottom: 30,
            child: GestureDetector(
              onTap: () {
                (_isSearched)
                    ? setState(() {
                        _isSearched = false;
                      })
                    : Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(20.sp),
                  ),
                  color: AppColors.bNormalActive,
                ),
                height: 45.sp,
                width: 120.sp,
                padding: EdgeInsets.symmetric(horizontal: 15.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quay lại',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.wWhite,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Image.asset(
                      AppAssets.backIcon,
                      color: AppColors.wWhite,
                      scale: 0.9,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBeforeSearch() {
    return [
      if (_history.isNotEmpty)
        Padding(
          padding: EdgeInsets.only(top: 35.sp, left: 16.sp, right: 16.sp),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tìm kiếm gần đây',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.dark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: _clearAllSearchHistory,
                    child: Text(
                      'Xóa hết',
                      style: TextStyle(fontSize: 14, color: AppColors.bNormal),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.sp),
              Align(
                alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < _history.length; i++)
                        InkWell(
                          onTap: () => _onSearch(_history[i]),
                          child: Container(
                            margin: EdgeInsets.only(right: 10.sp),
                            height: 40.sp,
                            decoration: BoxDecoration(
                              color: Color(0xffDADADA),
                              borderRadius: BorderRadius.circular(10.sp),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.sp,
                                vertical: 10.sp,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _history[i],
                                    style: TextStyle(
                                      color: AppColors.dark,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(width: 10.sp),
                                  GestureDetector(
                                    onTap: () {
                                      _removeSearchHistory(_history[i]);
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.red,
                                      size: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

      // Equipment
      Padding(
        padding: EdgeInsets.only(
          top: _history.isEmpty ? 40.sp : 20.sp,
          left: 16.sp,
          right: 16.sp,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dụng cụ luyện tập',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.dark,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.sp),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildEquipmentCategory('Không có'),
                      _buildEquipmentCategory('Máy chạy bộ'),
                      _buildEquipmentCategory('Đầy đủ thiết bị gym'),
                    ],
                  ),
                  SizedBox(height: 8.sp),
                  Row(
                    children: [
                      _buildEquipmentCategory('Thảm tập'),
                      _buildEquipmentCategory('Dây kháng lực'),
                      _buildEquipmentCategory('Xà đơn'),
                      _buildEquipmentCategory('Xà kép'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Goal
      Padding(
        padding: EdgeInsets.only(top: 20.sp, left: 16.sp, right: 16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mục tiêu',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.dark,
                fontWeight: FontWeight.bold,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildGoalCategory(
                        'Giảm cân /\nGiảm mỡ',
                        AppAssets.goalCategoryNoActive1,
                        AppAssets.goalCategoryActive1,
                      ),
                      _buildGoalCategory(
                        'Tăng cân',
                        AppAssets.goalCategoryNoActive2,
                        AppAssets.goalCategoryActive2,
                      ),
                      _buildGoalCategory(
                        'Tăng cơ',
                        AppAssets.goalCategoryNoActive3,
                        AppAssets.goalCategoryActive3,
                      ),
                      _buildGoalCategory(
                        'Duy trì\nvóc dáng',
                        AppAssets.goalCategoryNoActive4,
                        AppAssets.goalCategoryActive4,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildGoalCategory(
                        'Tăng sức\nbền',
                        AppAssets.goalCategoryNoActive5,
                        AppAssets.goalCategoryActive5,
                      ),
                      _buildGoalCategory(
                        'Cải thiện\ntim mạch',
                        AppAssets.goalCategoryNoActive6,
                        AppAssets.goalCategoryActive6,
                      ),
                      _buildGoalCategory(
                        'Giảm stress,\nthư giãn',
                        AppAssets.goalCategoryNoActive7,
                        AppAssets.goalCategoryActive7,
                      ),
                      _buildGoalCategory(
                        'Tăng chiều\ncao',
                        AppAssets.goalCategoryNoActive8,
                        AppAssets.goalCategoryActive8,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Level
      Padding(
        padding: EdgeInsets.only(top: 20.sp, left: 16.sp, right: 16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kinh nghiệm',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.dark,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.sp),
            Row(
              children: [
                _buildLevelCategory(
                  'Mới bắt đầu',
                  AppAssets.levelHorizontal1,
                ),
                _buildLevelCategory('Cơ bản', AppAssets.levelHorizontal2),
                _buildLevelCategory(
                  'Nâng cao',
                  AppAssets.levelHorizontal3,
                ),
              ],
            ),
          ],
        ),
      ),

      // Location
      Padding(
        padding: EdgeInsets.only(top: 20.sp, left: 16.sp, right: 16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nơi tập',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.dark,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.sp),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildLocationCategory(
                    'Tại nhà',
                    AppAssets.locationHomeSelected,
                    AppAssets.locationHome,
                  ),
                  _buildLocationCategory(
                    'Ngoài trời',
                    AppAssets.locationOutSideSelected,
                    AppAssets.locationOutSide,
                  ),
                  _buildLocationCategory(
                    'Phòng gym',
                    AppAssets.locationGymSelected,
                    AppAssets.locationGym,
                  ),
                  _buildLocationCategory(
                    'Mọi nơi',
                    AppAssets.locationAnywhereSelected,
                    AppAssets.locationAnywhere,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildAfterSearch(
    List<TrainingPlanResponse> t,
    List<TrainingExercisePreviewResponse> e,
  ) {
    return [
      Padding(
        padding: EdgeInsets.only(top: 35.sp, left: 16.sp, right: 16.sp),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (TrainingPlanResponse x in t) _buildTrainingPlanResult(x),
                ],
              ),
            ),
            SizedBox(height: 20.sp,),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.wWhite,
                  borderRadius: BorderRadius.circular(30.sp)
                ),
                padding: EdgeInsets.all(12.sp),
                child: Column(
                  children: [
                    ...List.generate(e.length, (index) {
                      return _buildExerciseItem(exercise: e[index]);
                    }),
                  ],
                ),
              ),
            ),
            SizedBox(height: 100.sp,)
          ],
        ),
      ),
    ];
  }

  Widget _buildEquipmentCategory(String text) {
    final bool isSelected = _selectedEquipments.contains(text);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedEquipments.remove(text);
          } else {
            _selectedEquipments.add(text);
          }
        });
      },
      child: Container(
        height: 40.sp,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.sp),
          color: isSelected ? AppColors.bNormal : AppColors.wWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        margin: EdgeInsets.only(right: 10.sp),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: isSelected ? AppColors.wWhite : AppColors.dark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoalCategory(
    String text,
    String imageNoActive,
    String imageActive,
  ) {
    final bool isSelected = _selectedGoal == text;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedGoal == text) {
            _selectedGoal = '';
          } else {
            _selectedGoal = text;
          }
        });
      },
      child: Container(
        height: 90.sp,
        width: 170.sp,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.sp),
          color: AppColors.bgHealthInfor,
        ),
        margin: EdgeInsets.only(right: 10.sp),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.sp),
          child: Stack(
            children: [
              // ảnh nền
              Positioned.fill(
                child: Image.asset(
                  isSelected ? imageActive : imageNoActive,
                  fit: BoxFit.fill,
                ),
              ),

              // text
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.sp, top: 10.sp),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isSelected ? AppColors.wWhite : AppColors.dark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelCategory(String text, String image) {
    bool isSelected = _selectedLevel == text;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedLevel == text) {
            _selectedLevel = '';
          } else {
            _selectedLevel = text;
          }
        });
      },
      child: Container(
        height: 70.sp,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.sp),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
          border: isSelected
              ? Border.all(color: AppColors.bNormal, width: 2)
              : null,
        ),
        margin: EdgeInsets.only(right: 10.sp),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(image),
              SizedBox(height: 10.sp),
              Text(
                text,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.dark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCategory(
    String text,
    String imageNoActive,
    String imageActive,
  ) {
    bool isSelected = _selectedLocation == text;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedLocation == text) {
            _selectedLocation = '';
          } else {
            _selectedLocation = text;
          }
        });
      },
      child: Container(
        height: 50.sp,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.sp),
          color: isSelected ? AppColors.bNormal : AppColors.wWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        margin: EdgeInsets.only(right: 10.sp),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(isSelected ? imageActive : imageNoActive),
              SizedBox(width: 10.sp),
              Text(
                text,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isSelected ? AppColors.wWhite : AppColors.dark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrainingPlanResult(TrainingPlanResponse plan) {
    return Container(
      width: 300,
      height: 180,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(AppAssets.trainingPlan1),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TrainingLibraryPlanDetailWidget(plan: plan),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightHover.withOpacity(0.6),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                    children: [
                      Text(
                        plan.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 180,
                        child: Text(
                          plan.description,
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

  Widget _buildExerciseItem({
    required TrainingExercisePreviewResponse exercise,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: () async {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
          try {
            final response = await TrainingService.getExerciseById(exercise.id);

            if (response.status == 'SUCCESS') {
              Navigator.of(context).pop();

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => TrainingLibraryExerciseDetailWidget(
                  exercise: TrainingExerciseResponse.fromJson(response.data),
                ),
              );
            } else {
              Navigator.of(context).pop();
            }
          } catch (e) {
            Navigator.of(context).pop();
          }
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.transparent),
          child: Row(
            children: [
              Container(
                height: 60,
                width: 110,
                color: Colors.grey.shade300,
                child: exercise.imageURL == null
                    ? const Icon(Icons.image, color: Colors.grey)
                    : CachedNetworkImage(
                        imageUrl: exercise.imageURL,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.broken_image, color: Colors.red),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 10.sp),
                    Text(
                      exercise.levelName,
                      style: const TextStyle(color: AppColors.bNormal),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String removeNewLine(String input) {
    return input.replaceAll('\n', ' ');
  }
}
