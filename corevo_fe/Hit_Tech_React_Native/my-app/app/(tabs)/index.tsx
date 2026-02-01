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
  ActivityIndicator,
} from 'react-native';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { AppAssets } from '@/constants/AppAssets';
import { AppStrings } from '@/constants/AppStrings';
import { TrainingSchedule, TrainingProgressStatistic } from '@/types/training';
import CircularProgress from '@/components/common/CircularProgress';
import HomeCalendar from '@/components/home/HomeCalendar';
import { useUserStore } from '@/store/userStore';
import { trainingService } from '@/services/api/trainingService';
import { useTheme } from '@/hooks/useTheme';

/**
 * Home Screen - Main Dashboard
 * Displays user's training progress and schedule with real API data
 */
export default function HomeScreen() {
  const router = useRouter();
  const {
    user,
    currentTrainingPlan,
    trainingSchedules,
    dailyProgress,
    progressStatistic,
    fetchProfile,
    fetchTrainingData
  } = useUserStore();
  const { colors } = useTheme();

  // State
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Main data fetching effect
  useEffect(() => {
    const initData = async () => {
      try {
        setIsLoading(true);
        setError(null);

        // 1. Fetch profile first (wait for it)
        await fetchProfile();

        // After fetchProfile, the store's currentTrainingPlan might be updated
      } catch (err: any) {
        console.error('Error initializing home data:', err);
        setError(err.message || 'Không thể tải dữ liệu');
        setIsLoading(false);
      }
    };

    initData();
  }, []);

  // Fetch training data when profile/plan changes
  useEffect(() => {
    const loadTrainingData = async () => {
      if (!currentTrainingPlan) {
        // Only stop loading if we've already tried to fetch the profile
        if (!useUserStore.getState().isLoading) {
          setIsLoading(false);
        }
        return;
      }

      try {
        setIsLoading(true);
        await fetchTrainingData();
      } catch (err: any) {
        console.error('Error fetching training data:', err);
        setError(err.message || 'Không thể tải dữ liệu');
      } finally {
        setIsLoading(false);
      }
    };

    loadTrainingData();
  }, [currentTrainingPlan]);

  const fullName = user ? `${user.firstName || ''} ${user.lastName || ''}`.trim() : 'User';
  const avatarUrl = user?.linkAvatar || AppAssets.defaultImage;

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

  // Get scheduled weekdays check
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

    return trainingSchedules
      .filter(schedule => {
        const hasExercises = (schedule.exerciseGroups?.exercises?.length || 0) > 0;
        return hasExercises;
      })
      .map(schedule => weekdayMap[schedule.dayOfWeek])
      .filter(day => day !== undefined);
  };

  // Get current schedule and exercise count
  const currentSchedule = trainingSchedules[weekDay];
  const exerciseCount = currentSchedule?.exerciseGroups?.exercises?.length || 0;

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

  // Error state
  if (error && !currentTrainingPlan) {
    return (
      <View style={styles.loadingContainer}>
        <Ionicons name="cloud-offline-outline" size={Dims.size64} color={colors.text.secondary} />
        <Text style={[styles.errorText, { color: colors.semantic.error }]}>{error}</Text>
        <TouchableOpacity
          style={styles.retryButton}
          onPress={() => fetchProfile()}
        >
          <Text style={styles.retryButtonText}>Thử lại</Text>
        </TouchableOpacity>
      </View>
    );
  }

  // No training plan
  if (!isLoading && (!currentTrainingPlan || trainingSchedules.length === 0)) {
    return (
      <View style={styles.loadingContainer}>
        <Ionicons name="fitness-outline" size={Dims.size64} color={colors.text.secondary} />
        <Text style={styles.noDataText}>Bạn chưa có kế hoạch luyện tập</Text>
        <Text style={[styles.noDataSubText, { color: colors.text.secondary }]}>Hãy bắt đầu bằng cách chọn một kế hoạch phù hợp!</Text>
        <TouchableOpacity
          style={styles.exploreButton}
          onPress={() => router.push('/(tabs)/training' as any)}
        >
          <Text style={styles.exploreButtonText}>Khám phá ngay</Text>
        </TouchableOpacity>
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
                    avatarUrl
                      ? { uri: avatarUrl }
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
                  {currentSchedule?.name || 'Không có lịch tập'}
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
                  progress={dailyProgress}
                  progressColor={Colors.wWhite}
                  backgroundColor="rgba(255, 255, 255, 0.25)"
                >
                  <Text style={styles.progressText}>{Math.round(dailyProgress)}%</Text>
                </CircularProgress>
              </View>
            </View>

            <Text style={styles.trainingDescription}>
              {currentSchedule?.description || AppStrings.trainingRestDay}
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
            completedDays={
              progressStatistic?.currentMonthCompletions
                .map((completed, index) => completed ? index + 1 : null)
                .filter((day): day is number => day !== null) || []
            }
            scheduledWeekdays={getScheduledWeekdays()}
          />

          {/* Bottom Row: Streak + Next Training */}
          <View style={styles.bottomRow}>
            {/* Streak Card */}
            <View style={styles.streakCard}>
              <View style={styles.streakInfo}>
                <Text style={styles.streakTitle}>
                  {AppStrings.homeStreakDays} {progressStatistic?.currentStreak || 0}{' '}
                  {AppStrings.homeStreakDaysUnit}
                </Text>
                <Text style={styles.streakSubtitle}>
                  {AppStrings.homeLongestStreak} {progressStatistic?.longestStreak || 0}
                </Text>
              </View>
              <Image
                source={
                  (progressStatistic?.currentStreak || 0) === 0
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
  loadingText: {
    marginTop: Dims.spacingM,
    fontSize: Dims.textSizeM,
    color: Colors.dark,
  },
  noDataText: {
    fontSize: Dims.textSizeL,
    fontWeight: 'bold',
    color: Colors.dark,
    textAlign: 'center',
    marginTop: Dims.spacingM,
  },
  noDataSubText: {
    fontSize: Dims.textSizeS,
    textAlign: 'center',
    marginTop: Dims.spacingS,
    marginBottom: Dims.spacingXL,
  },
  errorText: {
    fontSize: Dims.textSizeM,
    textAlign: 'center',
    marginTop: Dims.spacingM,
    marginBottom: Dims.spacingL,
  },
  retryButton: {
    backgroundColor: Colors.bNormal,
    paddingHorizontal: Dims.paddingXL,
    paddingVertical: Dims.paddingM,
    borderRadius: Dims.borderRadius,
  },
  retryButtonText: {
    color: Colors.wWhite,
    fontWeight: '600',
  },
  exploreButton: {
    backgroundColor: Colors.bNormal,
    paddingHorizontal: Dims.paddingXL,
    paddingVertical: Dims.paddingM,
    borderRadius: Dims.borderRadius,
  },
  exploreButtonText: {
    color: Colors.wWhite,
    fontWeight: '600',
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
    borderRadius: Dims.borderRadiusL,
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
