import 'package:hit_tech/core/constants/app_assets.dart';

class TrainingDayImageData{

  static List<String> getListImage(String name, String goal){
    switch(goal){
      case "Lose fat": {
        switch (name){
          case "Fat Burn Express": return getListLoseFatPlan1();
          case "Shred and Burn": return getListLoseFatPlan2();
          case "Bodyweigt Burn": return getListLoseFatPlan3();
        }
      }
      case "Gain weight": {
        switch (name){
          case "Muscle Mass Builder": return getListGainWeightPlan1();
          case "Bodyweight Hypertrophy": return getListGainWeightPlan2();
        }
      }
      case "Gain muscle": {
        switch (name){
          case "Muscle Mass Builder": return getListGainMusclePlan1();
          case "Body Control Muscle": return getListGainMusclePlan2();
          case "Lean Muscle Assist": return getListGainMusclePlan3();
        }
      }
      case "Maintain Body": {
        switch (name){
          case "Lean and Fit": return getListMaintainBodyPlan1();
          case "Balanced Body": return getListMaintainBodyPlan1();
          case "Steady Fit": return getListMaintainBodyPlan3();
        }
      }
      case "Increase endurance": {
        switch (name){
          case "Endurance Engine": return getListIncreaseEndurancePlan1();
          case "Bodyweight Stamina": return getListIncreaseEndurancePlan2();
          case "Strength-Endurance Hybrid": return getListIncreaseEndurancePlan3();
        }
      }
      case "Improve cardiovascular": {
        switch (name){
          case "Healthy Heart Routine": return getListImproveCardiovascularPlan1();
          case "Cardio + Strength Circuit": return getListImproveCardiovascularPlan2();
          case "Hearful Flow": return getListImproveCardiovascularPlan3();
        }
      }
      case "Stress relief/relaxation": {
        switch (name){
          case "Calm and Clarity": return getListStressReliefPlan1();
          case "Mindful Movement": return getListStressReliefPlan2();
          case "Reset and Recharge": return getListStressReliefPlan3();
        }
      }
      case "Increase height": {
        switch (name){
          case "Height Stretch Flow": return getListIncreaseHeightPlan1();
          case "Jump and Stretch Combo": return getListIncreaseHeightPlan2();
          case "Posture and Core Strength": return getListIncreaseHeightPlan3();
        }
      }
    }
    return [];
  }

  static List<String> getListShape(String name, String goal){
    switch(goal){
      case "Lose fat": {
        switch (name){
          case "Fat Burn Express": return getListLoseFatShapePlan1();
          case "Shred and Burn": return getListLoseFatShapePlan2();
          case "Bodyweigt Burn": return getListLoseFatShapePlan3();
        }
      }
      case "Gain weight": {
        switch (name){
          case "Muscle Mass Builder": return getListGainWeightShapePlan1();
          case "Bodyweight Hypertrophy": return getListGainWeightShapePlan2();
        }
      }
      case "Gain muscle": {
        switch (name){
          case "Muscle Mass Builder": return getListGainMuscleShapePlan1();
          case "Body Control Muscle": return getListGainMuscleShapePlan2();
          case "Lean Muscle Assist": return getListGainMuscleShapePlan3();
        }
      }
      case "Maintain Body": {
        switch (name){
          case "Lean and Fit": return getListMaintainBodyShapePlan1();
          case "Balanced Body": return getListMaintainBodyShapePlan1();
          case "Steady Fit": return getListMaintainBodyShapePlan3();
        }
      }
      case "Increase endurance": {
        switch (name){
          case "Endurance Engine": return getListIncreaseEnduranceShapePlan1();
          case "Bodyweight Stamina": return getListIncreaseEnduranceShapePlan2();
          case "Strength-Endurance Hybrid": return getListIncreaseEnduranceShapePlan3();
        }
      }
      case "Improve cardiovascular": {
        switch (name){
          case "Healthy Heart Routine": return getListImproveCardiovascularShapePlan1();
          case "Cardio + Strength Circuit": return getListImproveCardiovascularShapePlan2();
          case "Hearful Flow": return getListImproveCardiovascularShapePlan3();
        }
      }
      case "Stress relief/relaxation": {
        switch (name){
          case "Calm and Clarity": return getListStressReliefShapePlan1();
          case "Mindful Movement": return getListStressReliefShapePlan2();
          case "Reset and Recharge": return getListStressReliefShapePlan3();
        }
      }
      case "Increase height": {
        switch (name){
          case "Height Stretch Flow": return getListIncreaseHeightShapePlan1();
          case "Jump and Stretch Combo": return getListIncreaseHeightShapePlan2();
          case "Posture and Core Strength": return getListIncreaseHeightShapePlan3();
        }
      }
    }
    return [];
  }


  // TRAINING DAY
  // Gain muscle
  static List<String> getListGainMusclePlan1(){
    List<String> l = [];
    l.add('assets/images/training/training_day/gain_muscle/gain_muscle_plan_3_1.png');
    l.add('assets/images/training/training_day/gain_muscle/gain_muscle_plan_3_2.png');
    l.add('assets/images/training/training_day/gain_muscle/gain_muscle_plan_3_3.png');
    l.add(AppAssets.restDayIcon);
    l.add('assets/images/training/training_day/gain_muscle/gain_muscle_plan_3_4.png');
    l.add('assets/images/training/training_day/gain_muscle/gain_muscle_plan_3_5.png');
    l.add(AppAssets.restDayIcon);
    return l;
  }
  static List<String> getListGainMusclePlan2(){
    List<String> l = [];
    l.add('assets/images/training/training_day/gain_muscle/gain_muscle_plan_1_1.png');
    l.add('assets/images/training/training_day/gain_muscle/gain_muscle_plan_1_2.png');
    l.add('assets/images/training/training_day/gain_muscle/gain_muscle_plan_1_3.png');
    l.add('assets/images/training/training_day/gain_muscle/gain_muscle_plan_1_4.png');
    l.add('assets/images/training/training_day/gain_muscle/gain_muscle_plan_1_5.png');
    l.add('assets/images/training/training_day/gain_muscle/gain_muscle_plan_1_6.png');
    l.add(AppAssets.restDayIcon);
    return l;
  }
  static List<String> getListGainMusclePlan3(){
    List<String> l = [];
    l.add('assets/images/training/training_day/gain_muscle/gain_muscle_plan_2_1.png');
    l.add('assets/images/training/training_day/gain_muscle/gain_muscle_plan_2_2.png');
    l.add(AppAssets.restDayIcon);
    l.add('assets/images/training/training_day/gain_muscle/gain_muscle_plan_2_3.png');
    l.add(AppAssets.restDayIcon);
    l.add('assets/images/training/training_day/gain_muscle/gain_muscle_plan_2_4.png');
    l.add(AppAssets.restDayIcon);
    return l;
  }

  // Gain weight
  static List<String> getListGainWeightPlan1(){
    List<String> l = [];
    l.add('assets/images/training/training_day/gain_weight/gain_weight_plan_2_1.png');
    l.add('assets/images/training/training_day/gain_weight/gain_weight_plan_2_2.png');
    l.add('assets/images/training/training_day/gain_weight/gain_weight_plan_2_3.png');
    l.add(AppAssets.restDayIcon);
    l.add('assets/images/training/training_day/gain_weight/gain_weight_plan_2_4.png');
    l.add('assets/images/training/training_day/gain_weight/gain_weight_plan_2_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }
  static List<String> getListGainWeightPlan2(){
    List<String> l = [];
    l.add('assets/images/training/training_day/gain_weight/gain_weight_plan_1_1.png');
    l.add('assets/images/training/training_day/gain_weight/gain_weight_plan_1_2.png');
    l.add('assets/images/training/training_day/gain_weight/gain_weight_plan_1_3.png');
    l.add('assets/images/training/training_day/gain_weight/gain_weight_plan_1_4.png');
    l.add('assets/images/training/training_day/gain_weight/gain_weight_plan_1_5.png');
    l.add('assets/images/training/training_day/gain_weight/gain_weight_plan_2_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }

  // Improve cardiovascular
  static List<String> getListImproveCardiovascularPlan1(){
    List<String> l = [];
    l.add('assets/images/training/training_day/improve_cardiovascular/improve_cardiovascular_plan_2_1.png');
    l.add('assets/images/training/training_day/improve_cardiovascular/improve_cardiovascular_plan_2_2.png');
    l.add('assets/images/training/training_day/improve_cardiovascular/improve_cardiovascular_plan_2_3.png');
    l.add(AppAssets.restDayIcon);
    l.add('assets/images/training/training_day/improve_cardiovascular/improve_cardiovascular_plan_2_4.png');
    l.add('assets/images/training/training_day/improve_cardiovascular/improve_cardiovascular_plan_2_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }
  static List<String> getListImproveCardiovascularPlan2(){
    List<String> l = [];
    l.add('assets/images/training/training_day/improve_cardiovascular/improve_cardiovascular_plan_1_1.png');
    l.add('assets/images/training/training_day/improve_cardiovascular/improve_cardiovascular_plan_1_2.png');
    l.add('assets/images/training/training_day/improve_cardiovascular/improve_cardiovascular_plan_1_3.png');
    l.add('assets/images/training/training_day/improve_cardiovascular/improve_cardiovascular_plan_1_4.png');
    l.add('assets/images/training/training_day/improve_cardiovascular/improve_cardiovascular_plan_1_5.png');
    l.add(AppAssets.restDayIcon);
    l.add(AppAssets.restDayIcon);

    return l;
  }
  static List<String> getListImproveCardiovascularPlan3(){
    List<String> l = [];
    l.add('assets/images/training/training_day/improve_cardiovascular/improve_cardiovascular_plan_3_1.png');
    l.add('assets/images/training/training_day/improve_cardiovascular/improve_cardiovascular_plan_3_2.png');
    l.add('assets/images/training/training_day/improve_cardiovascular/improve_cardiovascular_plan_3_3.png');
    l.add('assets/images/training/training_day/improve_cardiovascular/improve_cardiovascular_plan_3_4.png');
    l.add('assets/images/training/training_day/improve_cardiovascular/improve_cardiovascular_plan_3_5.png');
    l.add('assets/images/training/training_day/improve_cardiovascular/improve_cardiovascular_plan_2_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }

  // Increase endurance
  static List<String> getListIncreaseEndurancePlan1(){
    List<String> l = [];
    l.add('assets/images/training/training_day/increase_endurance/increase_endurance_plan_2_1.png');
    l.add('assets/images/training/training_day/increase_endurance/increase_endurance_plan_2_2.png');
    l.add(AppAssets.restDayIcon);
    l.add('assets/images/training/training_day/increase_endurance/increase_endurance_plan_2_3.png');
    l.add('assets/images/training/training_day/increase_endurance/increase_endurance_plan_2_4.png');
    l.add('assets/images/training/training_day/increase_endurance/increase_endurance_plan_2_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }
  static List<String> getListIncreaseEndurancePlan2(){
    List<String> l = [];
    l.add('assets/images/training/training_day/increase_endurance/increase_endurance_plan_1_1.png');
    l.add('assets/images/training/training_day/increase_endurance/increase_endurance_plan_1_2.png');
    l.add('assets/images/training/training_day/increase_endurance/increase_endurance_plan_1_3.png');
    l.add('assets/images/training/training_day/increase_endurance/increase_endurance_plan_1_4.png');
    l.add('assets/images/training/training_day/increase_endurance/increase_endurance_plan_1_5.png');
    l.add('assets/images/training/training_day/increase_endurance/increase_endurance_plan_2_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }
  static List<String> getListIncreaseEndurancePlan3(){
    List<String> l = [];
    l.add('assets/images/training/training_day/increase_endurance/increase_endurance_plan_3_1.png');
    l.add('assets/images/training/training_day/increase_endurance/increase_endurance_plan_3_2.png');
    l.add('assets/images/training/training_day/increase_endurance/increase_endurance_plan_3_3.png');
    l.add(AppAssets.restDayIcon);
    l.add('assets/images/training/training_day/increase_endurance/increase_endurance_plan_3_4.png');
    l.add('assets/images/training/training_day/increase_endurance/increase_endurance_plan_3_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }

  // Increase height
  static List<String> getListIncreaseHeightPlan1(){
    List<String> l = [];
    l.add('assets/images/training/training_day/increase_height/increase_height_plan_1_1.png');
    l.add('assets/images/training/training_day/increase_height/increase_height_plan_1_2.png');
    l.add('assets/images/training/training_day/increase_height/increase_height_plan_1_3.png');
    l.add(AppAssets.restDayIcon);
    l.add('assets/images/training/training_day/increase_height/increase_height_plan_1_4.png');
    l.add('assets/images/training/training_day/increase_height/increase_height_plan_1_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }
  static List<String> getListIncreaseHeightPlan2(){
    List<String> l = [];
    l.add('assets/images/training/training_day/increase_height/increase_height_plan_2_1.png');
    l.add('assets/images/training/training_day/increase_height/increase_height_plan_2_2.png');
    l.add('assets/images/training/training_day/increase_height/increase_height_plan_2_3.png');
    l.add('assets/images/training/training_day/increase_height/increase_height_plan_2_4.png');
    l.add('assets/images/training/training_day/increase_height/increase_height_plan_2_5.png');
    l.add(AppAssets.restDayIcon);
    l.add(AppAssets.restDayIcon);

    return l;
  }
  static List<String> getListIncreaseHeightPlan3(){
    List<String> l = [];
    l.add('assets/images/training/training_day/increase_height/increase_height_plan_3_1.png');
    l.add('assets/images/training/training_day/increase_height/increase_height_plan_3_2.png');
    l.add('assets/images/training/training_day/increase_height/increase_height_plan_3_3.png');
    l.add('assets/images/training/training_day/increase_height/increase_height_plan_3_4.png');
    l.add('assets/images/training/training_day/increase_height/increase_height_plan_3_5.png');
    l.add('assets/images/training/training_day/increase_height/increase_height_plan_2_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }

  // Lose fat
  static List<String> getListLoseFatPlan1(){
    List<String> l = [];
    l.add('assets/images/training/training_day/lose_fat/lose_fat_plan_2_1.png');
    l.add('assets/images/training/training_day/lose_fat/lose_fat_plan_2_2.png');
    l.add(AppAssets.restDayIcon);
    l.add('assets/images/training/training_day/lose_fat/lose_fat_plan_2_3.png');
    l.add('assets/images/training/training_day/lose_fat/lose_fat_plan_2_4.png');
    l.add('assets/images/training/training_day/lose_fat/lose_fat_plan_2_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }
  static List<String> getListLoseFatPlan2(){
    List<String> l = [];
    l.add('assets/images/training/training_day/lose_fat/lose_fat_plan_3_1.png');
    l.add('assets/images/training/training_day/lose_fat/lose_fat_plan_3_2.png');
    l.add(AppAssets.restDayIcon);
    l.add('assets/images/training/training_day/lose_fat/lose_fat_plan_3_3.png');
    l.add('assets/images/training/training_day/lose_fat/lose_fat_plan_3_4.png');
    l.add('assets/images/training/training_day/lose_fat/lose_fat_plan_3_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }
  static List<String> getListLoseFatPlan3(){
    List<String> l = [];
    l.add('assets/images/training/training_day/lose_fat/lose_fat_plan_1_1.png');
    l.add('assets/images/training/training_day/lose_fat/lose_fat_plan_1_2.png');
    l.add('assets/images/training/training_day/lose_fat/lose_fat_plan_1_3.png');
    l.add('assets/images/training/training_day/lose_fat/lose_fat_plan_1_4.png');
    l.add('assets/images/training/training_day/lose_fat/lose_fat_plan_1_5.png');
    l.add('assets/images/training/training_day/lose_fat/lose_fat_plan_2_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }

  // Maintain body
  static List<String> getListMaintainBodyPlan1(){
    List<String> l = [];
    l.add('assets/images/training/training_day/maintain_body/maintain_body_plan_2_1.png');
    l.add('assets/images/training/training_day/maintain_body/maintain_body_plan_2_2.png');
    l.add('assets/images/training/training_day/maintain_body/maintain_body_plan_2_3.png');
    l.add(AppAssets.restDayIcon);
    l.add('assets/images/training/training_day/maintain_body/maintain_body_plan_2_4.png');
    l.add('assets/images/training/training_day/maintain_body/maintain_body_plan_2_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }
  static List<String> getListMaintainBodyPlan2(){
    List<String> l = [];
    l.add('assets/images/training/training_day/maintain_body/maintain_body_plan_1_1.png');
    l.add('assets/images/training/training_day/maintain_body/maintain_body_plan_1_2.png');
    l.add(AppAssets.restDayIcon);
    l.add('assets/images/training/training_day/maintain_body/maintain_body_plan_1_3.png');
    l.add('assets/images/training/training_day/maintain_body/maintain_body_plan_1_4.png');
    l.add('assets/images/training/training_day/maintain_body/maintain_body_plan_1_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }
  static List<String> getListMaintainBodyPlan3(){
    List<String> l = [];
    l.add('assets/images/training/training_day/maintain_body/maintain_body_plan_3_1.png');
    l.add('assets/images/training/training_day/maintain_body/maintain_body_plan_3_2.png');
    l.add('assets/images/training/training_day/maintain_body/maintain_body_plan_3_3.png');
    l.add('assets/images/training/training_day/maintain_body/maintain_body_plan_3_4.png');
    l.add('assets/images/training/training_day/maintain_body/maintain_body_plan_3_5.png');
    l.add('assets/images/training/training_day/maintain_body/maintain_body_plan_2_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }

  // Stress relief
  static List<String> getListStressReliefPlan1(){
    List<String> l = [];
    l.add('assets/images/training/training_day/stress_relief/stress_relief_plan_1_1.png');
    l.add('assets/images/training/training_day/stress_relief/stress_relief_plan_1_2.png');
    l.add('assets/images/training/training_day/stress_relief/stress_relief_plan_1_3.png');
    l.add('assets/images/training/training_day/stress_relief/stress_relief_plan_1_4.png');
    l.add('assets/images/training/training_day/stress_relief/stress_relief_plan_1_5.png');
    l.add('assets/images/training/training_day/stress_relief/stress_relief_plan_3_4.png');
    l.add('assets/images/training/training_day/stress_relief/stress_relief_plan_3_5.png');

    return l;
  }
  static List<String> getListStressReliefPlan2(){
    List<String> l = [];
    l.add('assets/images/training/training_day/stress_relief/stress_relief_plan_2_1.png');
    l.add('assets/images/training/training_day/stress_relief/stress_relief_plan_2_2.png');
    l.add('assets/images/training/training_day/stress_relief/stress_relief_plan_2_3.png');
    l.add('assets/images/training/training_day/stress_relief/stress_relief_plan_2_4.png');
    l.add('assets/images/training/training_day/stress_relief/stress_relief_plan_2_5.png');
    l.add('assets/images/training/training_day/stress_relief/stress_relief_plan_1_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }
  static List<String> getListStressReliefPlan3(){
    List<String> l = [];
    l.add('assets/images/training/training_day/stress_relief/stress_relief_plan_3_1.png');
    l.add('assets/images/training/training_day/stress_relief/stress_relief_plan_3_2.png');
    l.add('assets/images/training/training_day/stress_relief/stress_relief_plan_3_3.png');
    l.add('assets/images/training/training_day/stress_relief/stress_relief_plan_3_4.png');
    l.add('assets/images/training/training_day/stress_relief/stress_relief_plan_3_5.png');
    l.add('assets/images/training/training_day/stress_relief/stress_relief_plan_1_4.png');
    l.add('assets/images/training/training_day/stress_relief/stress_relief_plan_1_5.png');

    return l;
  }

  // TRAINING DAY SHAPE
  // Gain muscle
  static List<String> getListGainMuscleShapePlan1(){
    List<String> l = [];
    l.add('assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_3_1.png');
    l.add('assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_3_2.png');
    l.add('assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_3_3.png');
    l.add(AppAssets.restDayIcon);
    l.add('assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_3_4.png');
    l.add('assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_3_5.png');
    l.add(AppAssets.restDayIcon);
    return l;
  }
  static List<String> getListGainMuscleShapePlan2(){
    List<String> l = [];
    l.add('assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_1_1.png');
    l.add('assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_1_2.png');
    l.add('assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_1_3.png');
    l.add('assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_1_4.png');
    l.add('assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_1_5.png');
    l.add('assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_1_6.png');
    l.add(AppAssets.restDayIcon);
    return l;
  }
  static List<String> getListGainMuscleShapePlan3(){
    List<String> l = [];
    l.add('assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_2_1.png');
    l.add('assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_2_2.png');
    l.add(AppAssets.restDayIcon);
    l.add('assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_2_3.png');
    l.add(AppAssets.restDayIcon);
    l.add('assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_2_4.png');
    l.add(AppAssets.restDayIcon);
    return l;
  }

  // Gain weight
  static List<String> getListGainWeightShapePlan1(){
    List<String> l = [];
    l.add('assets/images/training/training_day_shape/gain_weight/gain_weight_plan_2_1.png');
    l.add('assets/images/training/training_day_shape/gain_weight/gain_weight_plan_2_2.png');
    l.add('assets/images/training/training_day_shape/gain_weight/gain_weight_plan_2_3.png');
    l.add(AppAssets.restDayIcon);
    l.add('assets/images/training/training_day_shape/gain_weight/gain_weight_plan_2_4.png');
    l.add('assets/images/training/training_day_shape/gain_weight/gain_weight_plan_2_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }
  static List<String> getListGainWeightShapePlan2(){
    List<String> l = [];
    l.add('assets/images/training/training_day_shape/gain_weight/gain_weight_plan_1_1.png');
    l.add('assets/images/training/training_day_shape/gain_weight/gain_weight_plan_1_2.png');
    l.add('assets/images/training/training_day_shape/gain_weight/gain_weight_plan_1_3.png');
    l.add('assets/images/training/training_day_shape/gain_weight/gain_weight_plan_1_4.png');
    l.add('assets/images/training/training_day_shape/gain_weight/gain_weight_plan_1_5.png');
    l.add('assets/images/training/training_day_shape/gain_weight/gain_weight_plan_2_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }

  // Improve cardiovascular
  static List<String> getListImproveCardiovascularShapePlan1(){
    List<String> l = [];
    l.add('assets/images/training/training_day_shape/improve_cardiovascular/improve_cardiovascular_plan_2_1.png');
    l.add('assets/images/training/training_day_shape/improve_cardiovascular/improve_cardiovascular_plan_2_2.png');
    l.add('assets/images/training/training_day_shape/improve_cardiovascular/improve_cardiovascular_plan_2_3.png');
    l.add(AppAssets.restDayIcon);
    l.add('assets/images/training/training_day_shape/improve_cardiovascular/improve_cardiovascular_plan_2_4.png');
    l.add('assets/images/training/training_day_shape/improve_cardiovascular/improve_cardiovascular_plan_2_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }
  static List<String> getListImproveCardiovascularShapePlan2(){
    List<String> l = [];
    l.add('assets/images/training/training_day_shape/improve_cardiovascular/improve_cardiovascular_plan_1_1.png');
    l.add('assets/images/training/training_day_shape/improve_cardiovascular/improve_cardiovascular_plan_1_2.png');
    l.add('assets/images/training/training_day_shape/improve_cardiovascular/improve_cardiovascular_plan_1_3.png');
    l.add('assets/images/training/training_day_shape/improve_cardiovascular/improve_cardiovascular_plan_1_4.png');
    l.add('assets/images/training/training_day_shape/improve_cardiovascular/improve_cardiovascular_plan_1_5.png');
    l.add(AppAssets.restDayIcon);
    l.add(AppAssets.restDayIcon);

    return l;
  }
  static List<String> getListImproveCardiovascularShapePlan3(){
    List<String> l = [];
    l.add('assets/images/training/training_day_shape/improve_cardiovascular/improve_cardiovascular_plan_3_1.png');
    l.add('assets/images/training/training_day_shape/improve_cardiovascular/improve_cardiovascular_plan_3_2.png');
    l.add('assets/images/training/training_day_shape/improve_cardiovascular/improve_cardiovascular_plan_3_3.png');
    l.add('assets/images/training/training_day_shape/improve_cardiovascular/improve_cardiovascular_plan_3_4.png');
    l.add('assets/images/training/training_day_shape/improve_cardiovascular/improve_cardiovascular_plan_3_5.png');
    l.add('assets/images/training/training_day_shape/improve_cardiovascular/improve_cardiovascular_plan_2_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }

  // Increase endurance
  static List<String> getListIncreaseEnduranceShapePlan1(){
    List<String> l = [];
    l.add('assets/images/training/training_day_shape/increase_endurance/increase_endurance_plan_2_1.png');
    l.add('assets/images/training/training_day_shape/increase_endurance/increase_endurance_plan_2_2.png');
    l.add(AppAssets.restDayIcon);
    l.add('assets/images/training/training_day_shape/increase_endurance/increase_endurance_plan_2_3.png');
    l.add('assets/images/training/training_day_shape/increase_endurance/increase_endurance_plan_2_4.png');
    l.add('assets/images/training/training_day_shape/increase_endurance/increase_endurance_plan_2_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }
  static List<String> getListIncreaseEnduranceShapePlan2(){
    List<String> l = [];
    l.add('assets/images/training/training_day_shape/increase_endurance/increase_endurance_plan_1_1.png');
    l.add('assets/images/training/training_day_shape/increase_endurance/increase_endurance_plan_1_2.png');
    l.add('assets/images/training/training_day_shape/increase_endurance/increase_endurance_plan_1_3.png');
    l.add('assets/images/training/training_day_shape/increase_endurance/increase_endurance_plan_1_4.png');
    l.add('assets/images/training/training_day_shape/increase_endurance/increase_endurance_plan_1_5.png');
    l.add('assets/images/training/training_day_shape/increase_endurance/increase_endurance_plan_2_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }
  static List<String> getListIncreaseEnduranceShapePlan3(){
    List<String> l = [];
    l.add('assets/images/training/training_day_shape/increase_endurance/increase_endurance_plan_3_1.png');
    l.add('assets/images/training/training_day_shape/increase_endurance/increase_endurance_plan_3_2.png');
    l.add('assets/images/training/training_day_shape/increase_endurance/increase_endurance_plan_3_3.png');
    l.add(AppAssets.restDayIcon);
    l.add('assets/images/training/training_day_shape/increase_endurance/increase_endurance_plan_3_4.png');
    l.add('assets/images/training/training_day_shape/increase_endurance/increase_endurance_plan_3_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }

  // Increase height
  static List<String> getListIncreaseHeightShapePlan1(){
    List<String> l = [];
    l.add('assets/images/training/training_day_shape/increase_height/increase_height_plan_1_1.png');
    l.add('assets/images/training/training_day_shape/increase_height/increase_height_plan_1_2.png');
    l.add('assets/images/training/training_day_shape/increase_height/increase_height_plan_1_3.png');
    l.add(AppAssets.restDayIcon);
    l.add('assets/images/training/training_day_shape/increase_height/increase_height_plan_1_4.png');
    l.add('assets/images/training/training_day_shape/increase_height/increase_height_plan_1_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }
  static List<String> getListIncreaseHeightShapePlan2(){
    List<String> l = [];
    l.add('assets/images/training/training_day_shape/increase_height/increase_height_plan_2_1.png');
    l.add('assets/images/training/training_day_shape/increase_height/increase_height_plan_2_2.png');
    l.add('assets/images/training/training_day_shape/increase_height/increase_height_plan_2_3.png');
    l.add('assets/images/training/training_day_shape/increase_height/increase_height_plan_2_4.png');
    l.add('assets/images/training/training_day_shape/increase_height/increase_height_plan_2_5.png');
    l.add(AppAssets.restDayIcon);
    l.add(AppAssets.restDayIcon);

    return l;
  }
  static List<String> getListIncreaseHeightShapePlan3(){
    List<String> l = [];
    l.add('assets/images/training/training_day_shape/increase_height/increase_height_plan_3_1.png');
    l.add('assets/images/training/training_day_shape/increase_height/increase_height_plan_3_2.png');
    l.add('assets/images/training/training_day_shape/increase_height/increase_height_plan_3_3.png');
    l.add('assets/images/training/training_day_shape/increase_height/increase_height_plan_3_4.png');
    l.add('assets/images/training/training_day_shape/increase_height/increase_height_plan_3_5.png');
    l.add('assets/images/training/training_day_shape/increase_height/increase_height_plan_2_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }

  // Lose fat
  static List<String> getListLoseFatShapePlan1(){
    List<String> l = [];
    l.add('assets/images/training/training_day_shape/lose_fat/lose_fat_plan_2_1.png');
    l.add('assets/images/training/training_day_shape/lose_fat/lose_fat_plan_2_2.png');
    l.add(AppAssets.restDayIcon);
    l.add('assets/images/training/training_day_shape/lose_fat/lose_fat_plan_2_3.png');
    l.add('assets/images/training/training_day_shape/lose_fat/lose_fat_plan_2_4.png');
    l.add('assets/images/training/training_day_shape/lose_fat/lose_fat_plan_2_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }
  static List<String> getListLoseFatShapePlan2(){
    List<String> l = [];
    l.add('assets/images/training/training_day_shape/lose_fat/lose_fat_plan_3_1.png');
    l.add('assets/images/training/training_day_shape/lose_fat/lose_fat_plan_3_2.png');
    l.add(AppAssets.restDayIcon);
    l.add('assets/images/training/training_day_shape/lose_fat/lose_fat_plan_3_3.png');
    l.add('assets/images/training/training_day_shape/lose_fat/lose_fat_plan_3_4.png');
    l.add('assets/images/training/training_day_shape/lose_fat/lose_fat_plan_3_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }
  static List<String> getListLoseFatShapePlan3(){
    List<String> l = [];
    l.add('assets/images/training/training_day_shape/lose_fat/lose_fat_plan_1_1.png');
    l.add('assets/images/training/training_day_shape/lose_fat/lose_fat_plan_1_2.png');
    l.add('assets/images/training/training_day_shape/lose_fat/lose_fat_plan_1_3.png');
    l.add('assets/images/training/training_day_shape/lose_fat/lose_fat_plan_1_4.png');
    l.add('assets/images/training/training_day_shape/lose_fat/lose_fat_plan_1_5.png');
    l.add('assets/images/training/training_day_shape/lose_fat/lose_fat_plan_2_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }

  // Maintain body
  static List<String> getListMaintainBodyShapePlan1(){
    List<String> l = [];
    l.add('assets/images/training/training_day_shape/maintain_body/maintain_body_plan_2_1.png');
    l.add('assets/images/training/training_day_shape/maintain_body/maintain_body_plan_2_2.png');
    l.add('assets/images/training/training_day_shape/maintain_body/maintain_body_plan_2_3.png');
    l.add(AppAssets.restDayIcon);
    l.add('assets/images/training/training_day_shape/maintain_body/maintain_body_plan_2_4.png');
    l.add('assets/images/training/training_day_shape/maintain_body/maintain_body_plan_2_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }
  static List<String> getListMaintainBodyShapePlan2(){
    List<String> l = [];
    l.add('assets/images/training/training_day_shape/maintain_body/maintain_body_plan_1_1.png');
    l.add('assets/images/training/training_day_shape/maintain_body/maintain_body_plan_1_2.png');
    l.add(AppAssets.restDayIcon);
    l.add('assets/images/training/training_day_shape/maintain_body/maintain_body_plan_1_3.png');
    l.add('assets/images/training/training_day_shape/maintain_body/maintain_body_plan_1_4.png');
    l.add('assets/images/training/training_day_shape/maintain_body/maintain_body_plan_1_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }
  static List<String> getListMaintainBodyShapePlan3(){
    List<String> l = [];
    l.add('assets/images/training/training_day_shape/maintain_body/maintain_body_plan_3_1.png');
    l.add('assets/images/training/training_day_shape/maintain_body/maintain_body_plan_3_2.png');
    l.add('assets/images/training/training_day_shape/maintain_body/maintain_body_plan_3_3.png');
    l.add('assets/images/training/training_day_shape/maintain_body/maintain_body_plan_3_4.png');
    l.add('assets/images/training/training_day_shape/maintain_body/maintain_body_plan_3_5.png');
    l.add('assets/images/training/training_day_shape/maintain_body/maintain_body_plan_2_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }

  // Stress relief
  static List<String> getListStressReliefShapePlan1(){
    List<String> l = [];
    l.add('assets/images/training/training_day_shape/stress_relief/stress_relief_plan_1_1.png');
    l.add('assets/images/training/training_day_shape/stress_relief/stress_relief_plan_1_2.png');
    l.add('assets/images/training/training_day_shape/stress_relief/stress_relief_plan_1_3.png');
    l.add('assets/images/training/training_day_shape/stress_relief/stress_relief_plan_1_4.png');
    l.add('assets/images/training/training_day_shape/stress_relief/stress_relief_plan_1_5.png');
    l.add('assets/images/training/training_day_shape/stress_relief/stress_relief_plan_3_4.png');
    l.add('assets/images/training/training_day_shape/stress_relief/stress_relief_plan_3_5.png');

    return l;
  }
  static List<String> getListStressReliefShapePlan2(){
    List<String> l = [];
    l.add('assets/images/training/training_day_shape/stress_relief/stress_relief_plan_2_1.png');
    l.add('assets/images/training/training_day_shape/stress_relief/stress_relief_plan_2_2.png');
    l.add('assets/images/training/training_day_shape/stress_relief/stress_relief_plan_2_3.png');
    l.add('assets/images/training/training_day_shape/stress_relief/stress_relief_plan_2_4.png');
    l.add('assets/images/training/training_day_shape/stress_relief/stress_relief_plan_2_5.png');
    l.add('assets/images/training/training_day_shape/stress_relief/stress_relief_plan_1_5.png');
    l.add(AppAssets.restDayIcon);

    return l;
  }
  static List<String> getListStressReliefShapePlan3(){
    List<String> l = [];
    l.add('assets/images/training/training_day_shape/stress_relief/stress_relief_plan_3_1.png');
    l.add('assets/images/training/training_day_shape/stress_relief/stress_relief_plan_3_2.png');
    l.add('assets/images/training/training_day_shape/stress_relief/stress_relief_plan_3_3.png');
    l.add('assets/images/training/training_day_shape/stress_relief/stress_relief_plan_3_4.png');
    l.add('assets/images/training/training_day_shape/stress_relief/stress_relief_plan_3_5.png');
    l.add('assets/images/training/training_day_shape/stress_relief/stress_relief_plan_1_4.png');
    l.add('assets/images/training/training_day_shape/stress_relief/stress_relief_plan_1_5.png');

    return l;
  }
}