class MappingTrainingResourceHelper{

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

}