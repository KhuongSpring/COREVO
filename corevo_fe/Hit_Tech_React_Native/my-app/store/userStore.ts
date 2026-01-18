import { create } from 'zustand';
import type { User, UserHealth, UserProfileResponse } from '@/types/user';

/**
 * User Store
 * Manages user profile data and settings
 */

interface UserState {
    // State
    user: User | null;
    healthProfile: UserHealth | null;
    isLoading: boolean;
    error: string | null;

    // Actions
    setUser: (user: User) => void;
    setHealthProfile: (health: UserHealth) => void;
    setUserProfile: (profile: UserProfileResponse) => void;
    clearUser: () => void;
    clearError: () => void;
}

export const useUserStore = create<UserState>((set) => ({
    // Initial state
    user: null,
    healthProfile: null,
    isLoading: false,
    error: null,

    // ===== Actions =====

    /**
     * Set user data
     */
    setUser: (user: User) => {
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
            user: profile.user,
            healthProfile: profile.userHealth || null,
        });
    },

    /**
     * Clear user data (on logout)
     */
    clearUser: () => {
        set({
            user: null,
            healthProfile: null,
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
