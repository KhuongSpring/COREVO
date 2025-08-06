import '../model/response/training/training_schedule_response.dart';

class MappingTrainingResourceHelper {
  static String mappingTargetMuscle(int id) {
    const mapping = {
      1: "Ngực",
      2: "Lưng",
      3: "Vai",
      4: "Tay trước",
      5: "Tay sau",
      6: "Cẳng tay",
      7: "Bụng",
      8: "Cơ liên sườn",
      9: "Lưng dưới",
      10: "Mông",
      11: "Đùi trước",
      12: "Đùi sau",
      13: "Bắp chân",
    };
    return mapping[id] ?? id.toString();
  }

  static List<String> mappingTargetMuscleList(List<int> ids) {
    return ids.map((id) => mappingTargetMuscle(id)).toList();
  }

  static String mappingEquipment(int id) {
    const mapping = {
      1: "Không",
      2: "Thảm yoga",
      3: "Máy chạy bộ",
      4: "Dây kháng lực",
      5: "Dụng cụ gym",
      6: "Xà đơn",
      7: "Xà kép",
    };
    return mapping[id] ?? id.toString();
  }

  static List<String> mappingEquipmentList(List<int> ids) {
    return ids.map((id) => mappingEquipment(id)).toList();
  }

  static String mappingGoalToVietnamese(String englishGoal) {
    const mapping = {
      "Lose fat": "Giảm cân / Giảm mỡ",
      "Gain weight": "Tăng cân",
      "Gain muscle": "Tăng cơ",
      "Maintain body": "Duy trì vóc dáng",
      "Increase endurance": "Tăng sức bền",
      "Improve cardiovascular": "Cải thiện tim mạch",
      "Stress relief/relaxation": "Giảm stress, thư giãn",
      "Increase height": "Tăng chiều cao",
    };

    return mapping[englishGoal] ?? englishGoal;
  }

  static String mappingGoalToEnglish(String vietnameseGoal) {
    const mapping = {
      "Giảm cân / Giảm mỡ": "Lose fat",
      "Tăng cân": "Gain weight",
      "Tăng cơ": "Gain muscle",
      "Duy trì vóc dáng": "Maintain body",
      "Tăng sức bền": "Increase endurance",
      "Cải thiện tim mạch": "Improve cardiovascular",
      "Giảm stress, thư giãn": "Stress relief/relaxation",
      "Tăng chiều cao": "Increase height",
    };

    return mapping[vietnameseGoal] ?? vietnameseGoal;
  }

  static String getThuTiengViet(int weekday) {
    switch (weekday) {
      case 1:
        return 'Thứ Hai';
      case 2:
        return 'Thứ Ba';
      case 3:
        return 'Thứ Tư';
      case 4:
        return 'Thứ Năm';
      case 5:
        return 'Thứ Sáu';
      case 6:
        return 'Thứ Bảy';
      case 7:
        return 'Chủ Nhật';
      default:
        return 'Không rõ';
    }
  }

  static Set<DateTime> buildMarkedTrainingDays(
    List<TrainingScheduleResponse> schedules,
    int year,
    int month,
  ) {
    final Map<String, int> dayOfWeekMap = {
      "MONDAY": 1,
      "TUESDAY": 2,
      "WEDNESDAY": 3,
      "THURSDAY": 4,
      "FRIDAY": 5,
      "SATURDAY": 6,
      "SUNDAY": 7,
    };

    final Set<int> trainingWeekdays = schedules
        .where((s) => s.duration != null)
        .map((s) => dayOfWeekMap[s.dayOfWeek.toUpperCase()]!)
        .toSet();

    final Set<DateTime> markedDays = {};
    final int daysInMonth = DateTime(year, month + 1, 0).day;

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      if (trainingWeekdays.contains(date.weekday)) {
        markedDays.add(date);
      }
    }

    return markedDays;
  }

  static Result parse(String input) {
    List<String> parts = input.split('X');
    if (parts.length < 2) {
      return Result(sets: null, repsPerSet: null, durationPerSet: null);
    }

    String sets = parts[0].trim().replaceAll('sets', '').trim();
    String secondPart = parts[1].trim().toLowerCase();

    if (secondPart.contains('giây') || secondPart.contains('phút')) {
      return Result(sets: sets, repsPerSet: null, durationPerSet: secondPart);
    }

    return Result(sets: sets, repsPerSet: secondPart, durationPerSet: null);
  }

  static String getSetOfExercise(String duration){
    List<String> parts = duration.split('X');
    return parts[0].trim().replaceAll('sets', '').trim();
  }

  static String? normalizeLocation(String? raw) {
    return raw
        ?.split('/')
        .map((e) {
      switch (e.trim().toUpperCase()) {
        case 'GYM':
          return 'Phòng Gym';
        case 'HOME':
          return 'Tại nhà';
        case 'OUTSIDE':
          return 'Ngoài trời';
        case 'ANYWHERE':
          return 'Mọi nơi';
        default:
          return e.trim();
      }
    })
        .join(' / ');
  }

}

class Result {
  final String? sets;
  final String? repsPerSet;
  final String? durationPerSet;

  Result({this.sets, this.repsPerSet, this.durationPerSet});
}
