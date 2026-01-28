import { create } from 'zustand';
import type { UserProfile, UserHealth, UserProfileResponse } from '@/types/user';
import type { TrainingPlan } from '@/types/training';
import { userService } from '@/services/api/userService';

/**
 * User Store
 * Manages user profile data and settings
 */

interface UserState {
    // State
    user: UserProfile | null;
    healthProfile: UserHealth | null;
    trainingPlans: TrainingPlan[];
    currentTrainingPlan: TrainingPlan | null;
    isLoading: boolean;
    error: string | null;

    // Actions
    setUser: (user: UserProfile) => void;
    setHealthProfile: (health: UserHealth) => void;
    setUserProfile: (profile: UserProfileResponse) => void;
    setTrainingPlans: (plans: TrainingPlan[]) => void;
    fetchProfile: () => Promise<void>;
    clearUser: () => void;
    clearError: () => void;
}

export const useUserStore = create<UserState>((set) => ({
    // Initial state
    user: null,
    healthProfile: null,
    trainingPlans: [],
    currentTrainingPlan: null,
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
     * Clear user data (on logout)
     */
    clearUser: () => {
        set({
            user: null,
            healthProfile: null,
            trainingPlans: [],
            currentTrainingPlan: null,
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
