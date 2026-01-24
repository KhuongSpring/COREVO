import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';
import AsyncStorage from '@react-native-async-storage/async-storage';
import type { ThemeMode, CurrentTheme, ThemeColors } from '@/constants/ThemeColors';
import { getThemeColors } from '@/constants/ThemeColors';

/**
 * Theme Store
 * Manages theme state with light/dark modes only
 */

interface ThemeState {
    // State
    mode: ThemeMode;                    // User's theme preference: 'light' or 'dark'
    currentTheme: CurrentTheme;         // Active theme: 'light' or 'dark'
    colors: ThemeColors;                // Current theme colors

    // Actions
    setTheme: (mode: ThemeMode) => void;
    toggleTheme: () => void;            // Quick toggle between light and dark
    initTheme: () => void;
}

export const useThemeStore = create<ThemeState>()(
    persist(
        (set, get) => ({
            // Initial state (default to light)
            mode: 'light',
            currentTheme: 'light',
            colors: getThemeColors('light'),

            /**
             * Set theme mode (light or dark)
             */
            setTheme: (mode: ThemeMode) => {
                const colors = getThemeColors(mode);

                set({
                    mode,
                    currentTheme: mode,
                    colors,
                });
            },

            /**
             * Toggle between light and dark
             */
            toggleTheme: () => {
                const currentMode = get().mode;
                const newMode: ThemeMode = currentMode === 'light' ? 'dark' : 'light';
                const colors = getThemeColors(newMode);

                set({
                    mode: newMode,
                    currentTheme: newMode,
                    colors,
                });
            },

            /**
             * Initialize theme on app start
             */
            initTheme: () => {
                const { mode } = get();
                const colors = getThemeColors(mode);

                set({
                    currentTheme: mode,
                    colors,
                });
            },
        }),
        {
            name: 'theme-storage',
            storage: createJSONStorage(() => AsyncStorage),
            partialize: (state) => ({
                mode: state.mode, // Only persist the mode preference
            }),
        }
    )
);
