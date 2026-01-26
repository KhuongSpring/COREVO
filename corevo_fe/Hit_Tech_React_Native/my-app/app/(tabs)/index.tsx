import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  ImageBackground,
  Image,
  Alert,
} from 'react-native';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { AppAssets } from '@/constants/AppAssets';
import { AppStrings } from '@/constants/AppStrings';
import { TrainingSchedule, TrainingProgressStatistic } from '@/types/training';
import CircularProgress from '@/components/common/CircularProgress';
import { UserProfile } from '@/types/user';
import HomeCalendar from '@/components/home/HomeCalendar';

// Mock data - matching Flutter types
const MOCK_USER: UserProfile = {
  firstName: 'Nguyễn',
  lastName: 'Văn A',
  linkAvatar: AppAssets.defaultImage,
  trainingPlans: [
    {
      id: 1,
      name: 'Giảm cân / Giảm mỡ',
      goals: 'LOSE_WEIGHT',
      description: 'Kế hoạch giảm cân hiệu quả',
      aim: 'Giảm 5kg trong 8 tuần',
      type: 'CARDIO',
      duration: '45',
      frequency: '5',
      levelIds: [1],
      locationIds: [1],
      equipmentIds: [1],
    },
  ],
};

const MOCK_SCHEDULES: TrainingSchedule[] = [
  {
    dayOfWeek: 'MONDAY',
    name: 'Thứ Hai - Cardio',
    description: 'Tập cardio cường độ cao để đốt cháy mỡ thừa',
    exerciseGroups: {
      warmup: [{ name: 'Khởi động', duration: 5 }],
      mainExercises: [
        { name: 'Chạy bộ', duration: 20 },
        { name: 'Burpees', sets: 3, reps: 15 },
      ],
      cooldown: [{ name: 'Thư giãn', duration: 5 }],
    },
  },
  {
    dayOfWeek: 'TUESDAY',
    name: 'Thứ Ba - Toàn thân',
    description: 'Tập luyện toàn thân với động tác phức hợp',
    exerciseGroups: {
      warmup: [{ name: 'Khởi động', duration: 5 }],
      mainExercises: [
        { name: 'Push-ups', sets: 3, reps: 12 },
        { name: 'Squats', sets: 3, reps: 15 },
      ],
      cooldown: [{ name: 'Giãn cơ', duration: 5 }],
    },
  },
  {
    dayOfWeek: 'WEDNESDAY',
    name: 'Thứ Tư - Core',
    description: 'Tập trung vào cơ bụng và lưng',
    exerciseGroups: {
      warmup: [{ name: 'Khởi động', duration: 5 }],
      mainExercises: [
        { name: 'Plank', duration: 60 },
        { name: 'Crunches', sets: 3, reps: 20 },
      ],
      cooldown: [{ name: 'Thư giãn', duration: 5 }],
    },
  },
  {
    dayOfWeek: 'THURSDAY',
    name: 'Thứ Năm - HIIT',
    description: 'Tập HIIT để tăng cường đốt cháy calo',
    exerciseGroups: {
      warmup: [{ name: 'Khởi động', duration: 5 }],
      mainExercises: [
        { name: 'Jump squats', sets: 4, reps: 12 },
        { name: 'Mountain climbers', sets: 4, reps: 20 },
      ],
      cooldown: [{ name: 'Giãn cơ', duration: 5 }],
    },
  },
  {
    dayOfWeek: 'FRIDAY',
    name: 'Thứ Sáu - Cardio',
    description: 'Kết thúc tuần với cardio nhẹ nhàng',
    exerciseGroups: {
      warmup: [{ name: 'Khởi động', duration: 5 }],
      mainExercises: [
        { name: 'Đi bộ nhanh', duration: 30 },
        { name: 'Jumping jacks', sets: 3, reps: 30 },
      ],
      cooldown: [{ name: 'Thư giãn', duration: 5 }],
    },
  },
  {
    dayOfWeek: 'SATURDAY',
    name: 'Thứ Bảy - Nghỉ ngơi',
    description: 'Ngày nghỉ để cơ thể phục hồi',
    exerciseGroups: {
      warmup: [],
      mainExercises: [],
      cooldown: [],
    },
  },
  {
    dayOfWeek: 'SUNDAY',
    name: 'Chủ Nhật - Yoga',
    description: 'Yoga nhẹ nhàng để thư giãn',
    exerciseGroups: {
      warmup: [{ name: 'Khởi động', duration: 5 }],
      mainExercises: [
        { name: 'Yoga flow', duration: 20 },
        { name: 'Meditation', duration: 10 },
      ],
      cooldown: [{ name: 'Thư giãn', duration: 5 }],
    },
  },
];

const MOCK_PROGRESS: TrainingProgressStatistic = {
  totalWorkouts: 24,
  totalDuration: 960,
  totalCaloriesBurned: 4800,
  currentStreak: 5,
  longestStreak: 12,
  averageWorkoutDuration: 40,
  mostActiveDay: 'MONDAY',
  completionRate: 85,
  currentMonthCompletions: [1, 2, 5, 8, 10, 12, 15, 18, 20, 22],
};

/**
 * Home Screen - Main Dashboard
 * Converted from Flutter home_screen.dart
 */
export default function HomeScreen() {
  const router = useRouter();
  const [percentage, setPercentage] = useState(65); // Mock daily progress
  const [isLoading, setIsLoading] = useState(false);

  const profile = MOCK_USER;
  const schedules = MOCK_SCHEDULES;
  const progressStatistic = MOCK_PROGRESS;

  const fullName = `${profile.firstName} ${profile.lastName}`;
  const trainingPlan = profile.trainingPlans?.[0];

  // Get current weekday (0 = Sunday, 1 = Monday, ..., 6 = Saturday)
  const currentDayIndex = new Date().getDay();
  // Convert to Monday-first index (0 = Monday, ..., 6 = Sunday)
  const weekDay = currentDayIndex === 0 ? 6 : currentDayIndex - 1;

  const getVietnameseWeekday = (index: number): string => {
    const weekdays = [
      AppStrings.weekdayMonday,
      AppStrings.weekdayTuesday,
      AppStrings.weekdayWednesday,
      AppStrings.weekdayThursday,
      AppStrings.weekdayFriday,
      AppStrings.weekdaySaturday,
      AppStrings.weekdaySunday,
    ];
    return weekdays[index] || '';
  };

  const getGoalText = (goal: string): string => {
    const goalMap: Record<string, string> = {
      BUILD_MUSCLE: 'Tăng cơ',
      LOSE_WEIGHT: 'Giảm cân / Giảm mỡ',
      STAY_FIT: 'Duy trì vóc dáng',
      INCREASE_STRENGTH: 'Tăng sức mạnh',
      IMPROVE_ENDURANCE: 'Tăng sức bền',
      FLEXIBILITY: 'Tăng tính linh hoạt',
    };
    return goalMap[goal] || goal;
  };

  // Get weekdays that have scheduled training (for calendar red dots)
  const getScheduledWeekdays = (): number[] => {
    const weekdayMap: Record<string, number> = {
      MONDAY: 1,
      TUESDAY: 2,
      WEDNESDAY: 3,
      THURSDAY: 4,
      FRIDAY: 5,
      SATURDAY: 6,
      SUNDAY: 0,
    };

    return schedules
      .filter(schedule => {
        const hasExercises =
          (schedule.exerciseGroups?.warmup?.length || 0) +
          (schedule.exerciseGroups?.mainExercises?.length || 0) +
          (schedule.exerciseGroups?.cooldown?.length || 0) > 0;
        return hasExercises;
      })
      .map(schedule => weekdayMap[schedule.dayOfWeek])
      .filter(day => day !== undefined);
  };

  const currentSchedule = schedules[weekDay];
  const exerciseCount =
    (currentSchedule.exerciseGroups?.warmup?.length || 0) +
    (currentSchedule.exerciseGroups?.mainExercises?.length || 0) +
    (currentSchedule.exerciseGroups?.cooldown?.length || 0);

  const handleNavigateToSettings = () => {
    router.push('/(tabs)/settings' as any);
  };

  const handleNavigateToTraining = () => {
    router.push('/(tabs)/training' as any);
  };

  const handleNotification = () => {
    Alert.alert('Thông báo', 'Tính năng đang phát triển');
  };

  const handleCreateReminder = () => {
    Alert.alert('Nhắc nhở luyện tập', 'Tính năng đang phát triển');
  };

  if (isLoading) {
    return (
      <View style={styles.loadingContainer}>
        <Text>Đang tải...</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <ImageBackground
        source={AppAssets.mainBackground}
        style={styles.backgroundImage}
        resizeMode="cover"
      >
        <ScrollView
          style={styles.scrollView}
          contentContainerStyle={styles.scrollContent}
          showsVerticalScrollIndicator={false}
        >
          {/* Header: Avatar + Name + Notification */}
          <View style={styles.header}>
            <TouchableOpacity
              style={styles.avatarSection}
              onPress={handleNavigateToSettings}
              activeOpacity={0.7}
            >
              <View style={styles.avatarContainer}>
                <Image
                  source={
                    profile.linkAvatar
                      ? { uri: profile.linkAvatar }
                      : AppAssets.googleIcon
                  }
                  style={styles.avatar}
                />
              </View>
              <View style={styles.nameSection}>
                <Text style={styles.greeting}>{AppStrings.homeGreeting}</Text>
                <Text style={styles.fullName}>{fullName}</Text>
              </View>
            </TouchableOpacity>

            <TouchableOpacity
              style={styles.notificationButton}
              onPress={handleNotification}
              activeOpacity={0.7}
            >
              <Image
                source={AppAssets.notificationIconNonActive}
                style={styles.notificationIcon}
              />
            </TouchableOpacity>
          </View>

          {/* Training Card */}
          <TouchableOpacity
            style={styles.trainingCard}
            onPress={handleNavigateToTraining}
            activeOpacity={0.8}
          >
            <View style={styles.trainingCardContent}>
              <View style={styles.trainingInfo}>
                <Text style={styles.trainingGoal}>
                  {getGoalText(trainingPlan?.goals || '')}
                </Text>
                <Text style={styles.trainingDetails}>
                  {getVietnameseWeekday(weekDay)} • {exerciseCount}{' '}
                  {AppStrings.homeExercises}
                </Text>
              </View>

              {/* Circular Progress Indicator */}
              <View style={styles.progressContainer}>
                <CircularProgress
                  size={Dims.size48}
                  strokeWidth={5}
                  progress={percentage}
                  progressColor={Colors.wWhite}
                  backgroundColor="rgba(255, 255, 255, 0.25)"
                >
                  <Text style={styles.progressText}>{percentage}%</Text>
                </CircularProgress>
              </View>
            </View>

            <Text style={styles.trainingDescription}>
              {currentSchedule.description}
            </Text>

            <TouchableOpacity
              style={styles.trainingButton}
              onPress={handleNavigateToTraining}
              activeOpacity={0.9}
            >
              <Text style={styles.trainingButtonText}>
                {AppStrings.homeTrainingButton}
              </Text>
            </TouchableOpacity>
          </TouchableOpacity>

          {/* Calendar */}
          <HomeCalendar
            completedDays={progressStatistic.currentMonthCompletions}
            scheduledWeekdays={getScheduledWeekdays()}
          />

          {/* Bottom Row: Streak + Next Training */}
          <View style={styles.bottomRow}>
            {/* Streak Card */}
            <View style={styles.streakCard}>
              <View style={styles.streakInfo}>
                <Text style={styles.streakTitle}>
                  {AppStrings.homeStreakDays} {progressStatistic.currentStreak}{' '}
                  {AppStrings.homeStreakDaysUnit}
                </Text>
                <Text style={styles.streakSubtitle}>
                  {AppStrings.homeLongestStreak} {progressStatistic.longestStreak}
                </Text>
              </View>
              <Image
                source={
                  progressStatistic.currentStreak === 0
                    ? AppAssets.fireNonIcon
                    : AppAssets.fireIcon
                }
                style={styles.fireIcon}
                resizeMode='contain'
              />
            </View>

            {/* Reminder Card */}
            <TouchableOpacity
              style={styles.reminderCard}
              onPress={handleCreateReminder}
              activeOpacity={0.7}
            >
              <Ionicons
                name="alarm"
                size={Dims.iconSizeXXXL}
                color={Colors.wWhite}
              />
              <Text style={styles.reminderText}>
                {AppStrings.homeCreateReminder}
              </Text>
            </TouchableOpacity>
          </View>
        </ScrollView>
      </ImageBackground>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.wWhite,
  },
  backgroundImage: {
    flex: 1,
    width: '100%',
    height: '100%',
  },
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: Colors.wWhite,
  },
  scrollView: {
    flex: 1,
  },
  scrollContent: {
    paddingHorizontal: Dims.paddingL,
    paddingVertical: Dims.paddingM,
    paddingTop: Dims.spacingGiant,
  },

  // Header
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: Dims.spacingL,
  },
  avatarSection: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  avatarContainer: {
    borderWidth: 2,
    borderColor: Colors.bNormal,
    borderRadius: Dims.borderRadiusLarge,
    padding: 2,
  },
  avatar: {
    width: Dims.size48,
    height: Dims.size48,
    borderRadius: Dims.borderRadiusLarge,
  },
  nameSection: {
    marginLeft: Dims.spacingSM,
  },
  greeting: {
    fontSize: Dims.textSizeS,
    color: Colors.dark,
  },
  fullName: {
    fontSize: Dims.textSizeM,
    fontWeight: '500',
    color: Colors.dark,
  },
  notificationButton: {
    width: Dims.size48,
    height: Dims.size48,
    backgroundColor: Colors.wWhite,
    borderRadius: Dims.borderRadiusLarge,
    justifyContent: 'center',
    alignItems: 'center',
  },
  notificationIcon: {
    width: Dims.size32,
    height: Dims.size32,
  },

  // Training Card
  trainingCard: {
    backgroundColor: Colors.bNormal,
    borderRadius: Dims.borderRadiusLarge,
    padding: Dims.paddingM,
    marginBottom: Dims.spacingSM,
  },
  trainingCardContent: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    marginBottom: Dims.spacingSM,
  },
  trainingInfo: {
    flex: 1,
  },
  trainingGoal: {
    color: Colors.wWhite,
    fontSize: Dims.textSizeL,
    fontWeight: 'bold',
    marginBottom: Dims.size4,
  },
  trainingDetails: {
    color: Colors.wWhite,
    fontSize: Dims.textSizeXS,
  },
  progressContainer: {
    justifyContent: 'center',
    alignItems: 'center',
  },
  progressCircle: {
    width: Dims.size48,
    height: Dims.size48,
    borderRadius: Dims.size48 / 2,
    borderWidth: 5,
    borderColor: Colors.wWhite,
    backgroundColor: 'rgba(255, 255, 255, 0.15)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  progressText: {
    color: Colors.wWhite,
    fontSize: Dims.textSizeXS,
    fontWeight: 'bold',
  },
  trainingDescription: {
    color: Colors.wWhite,
    fontSize: Dims.textSizeS,
    marginBottom: Dims.spacingML,
  },
  trainingButton: {
    backgroundColor: Colors.wWhite,
    borderRadius: Dims.borderRadiusSmall,
    paddingVertical: Dims.spacingSM,
    alignItems: 'center',
  },
  trainingButtonText: {
    color: Colors.bNormal,
    fontSize: Dims.textSizeS,
    fontWeight: '600',
  },

  // Calendar Placeholder
  calendarPlaceholder: {
    backgroundColor: Colors.wWhite,
    borderRadius: Dims.borderRadiusSmall,
    padding: Dims.paddingL,
    marginBottom: Dims.spacingSM,
    alignItems: 'center',
    minHeight: Dims.size200,
    justifyContent: 'center',
  },
  calendarText: {
    fontSize: Dims.textSizeM,
    fontWeight: '600',
    color: Colors.dark,
    marginBottom: Dims.spacingS,
  },
  calendarSubtext: {
    fontSize: Dims.textSizeS,
    color: Colors.lighter,
  },

  // Bottom Row
  bottomRow: {
    flexDirection: 'row',
    marginBottom: Dims.size104,
  },
  streakCard: {
    flex: 1,
    backgroundColor: Colors.bNormal,
    borderRadius: Dims.borderRadiusSmall,
    padding: Dims.paddingM,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginRight: Dims.spacingML,
  },
  streakInfo: {
    flex: 1,
  },
  streakTitle: {
    color: Colors.wWhite,
    fontWeight: 'bold',
    fontSize: Dims.textSizeM,
    marginBottom: Dims.size4,
  },
  streakSubtitle: {
    color: 'rgba(255, 255, 255, 0.7)',
    fontSize: Dims.textSizeXS,
  },
  fireIcon: {
    width: Dims.size32,
    height: Dims.size32,
  },
  reminderCard: {
    backgroundColor: Colors.bNormal,
    borderRadius: Dims.borderRadiusSmall,
    padding: Dims.paddingS,
    width: Dims.size104,
    alignItems: 'center',
    justifyContent: 'center',
  },
  reminderText: {
    color: Colors.wWhite,
    fontSize: Dims.textSizeXS,
    fontWeight: 'bold',
    marginTop: Dims.spacingS,
    textAlign: 'center',
  },
});
