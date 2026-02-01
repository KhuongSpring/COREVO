import { create } from 'zustand';
import type { UserProfile, UserHealth, UserProfileResponse } from '@/types/user';
import type { TrainingPlan, TrainingSchedule, TrainingProgressStatistic } from '@/types/training';
import { userService } from '@/services/api/userService';
import { trainingService } from '@/services/api/trainingService';

/**
 * User Store
 * Manages user profile data, training schedules, and statistics
 */

interface UserState {
    // State
    user: UserProfile | null;
    healthProfile: UserHealth | null;
    trainingPlans: TrainingPlan[];
    currentTrainingPlan: TrainingPlan | null;

    // Training data (cached from API)
    trainingSchedules: TrainingSchedule[];
    dailyProgress: number;
    progressStatistic: TrainingProgressStatistic | null;

    isLoading: boolean;
    error: string | null;

    // Actions
    setUser: (user: UserProfile) => void;
    setHealthProfile: (health: UserHealth) => void;
    setUserProfile: (profile: UserProfileResponse) => void;
    setTrainingPlans: (plans: TrainingPlan[]) => void;
    setTrainingData: (schedules: TrainingSchedule[], dailyProgress: number, statistic: TrainingProgressStatistic) => void;
    fetchProfile: () => Promise<void>;
    fetchTrainingData: () => Promise<void>;
    clearUser: () => void;
    clearError: () => void;
}

export const useUserStore = create<UserState>((set, get) => ({
    // Initial state
    user: null,
    healthProfile: null,
    trainingPlans: [],
    currentTrainingPlan: null,

    // Training data
    trainingSchedules: [],
    dailyProgress: 0,
    progressStatistic: null,

    isLoading: false,
    error: null,

    // ===== Actions =====

    /**
     * Set user data
     */
    setUser: (user: UserProfile) => {
        set({ user });
    },

    /**
     * Set health profile
     */
    setHealthProfile: (health: UserHealth) => {
        set({ healthProfile: health });
    },

    /**
     * Set complete user profile (from API response)
     */
    setUserProfile: (profile: UserProfileResponse) => {
        set({
            user: profile.data,
            healthProfile: profile.data?.userHealth || null,
            trainingPlans: profile.data?.trainingPlans || [],
            currentTrainingPlan: profile.data?.trainingPlans?.[0] || null,
        });
    },

    /**
     * Set training plans
     */
    setTrainingPlans: (plans: TrainingPlan[]) => {
        set({
            trainingPlans: plans,
            currentTrainingPlan: plans[0] || null,
        });
    },

    /**
     * Set training data (schedules, progress, statistics)
     */
    setTrainingData: (schedules: TrainingSchedule[], dailyProgress: number, statistic: TrainingProgressStatistic) => {
        set({
            trainingSchedules: schedules,
            dailyProgress: dailyProgress,
            progressStatistic: statistic,
        });
    },

    /**
     * Fetch user profile from API
     */
    fetchProfile: async () => {
        set({ isLoading: true, error: null });
        try {
            const response = await userService.getProfile();
            if (response.status === 'SUCCESS') {
                set({
                    user: response.data,
                    healthProfile: response.data?.userHealth || null,
                    trainingPlans: response.data?.trainingPlans || [],
                    currentTrainingPlan: response.data?.trainingPlans?.[0] || null,
                    isLoading: false,
                    error: null,
                });
            } else {
                set({
                    error: 'Failed to fetch profile',
                    isLoading: false,
                });
            }
        } catch (error: any) {
            set({
                error: error.message || 'Failed to fetch profile',
                isLoading: false,
            });
        }
    },

    /**
     * Fetch training data (schedules, progress, statistics)
     */
    fetchTrainingData: async () => {
        const { currentTrainingPlan } = get();
        if (!currentTrainingPlan) {
            console.warn('No training plan available');
            return;
        }

        set({ isLoading: true, error: null });
        try {
            // Fetch all training data in parallel
            const [schedulesRes, progressRes, statsRes] = await Promise.all([
                trainingService.getTrainingScheduleById(currentTrainingPlan.id),
                trainingService.getDailyProgress(),
                trainingService.getStatistic(new Date().getFullYear(), new Date().getMonth() + 1),
            ]);

            set({
                trainingSchedules: schedulesRes.data.days,
                dailyProgress: progressRes.data.percentage,
                progressStatistic: statsRes.data,
                isLoading: false,
            });
        } catch (error: any) {
            console.error('Error fetching training data:', error);
            set({
                error: error.message || 'Failed to fetch training data',
                isLoading: false,
            });
        }
    },

    /**
     * Clear user data (on logout)
     */
    clearUser: () => {
        set({
            user: null,
            healthProfile: null,
            trainingPlans: [],
            currentTrainingPlan: null,
            trainingSchedules: [],
            dailyProgress: 0,
            progressStatistic: null,
            error: null,
        });
    },

    /**
     * Clear error
     */
    clearError: () => {
        set({ error: null });
    },
}));
