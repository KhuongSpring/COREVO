import { useThemeStore } from '@/store/themeStore';
import type { ThemeColors, ThemeMode, CurrentTheme } from '@/constants/ThemeColors';

/**
 * Custom hook to access theme in components
 * 
 * @example
 * ```tsx
 * const { colors, mode, currentTheme, setTheme } = useTheme();
 * 
 * <View style={{ backgroundColor: colors.background.primary }}>
 *   <Text style={{ color: colors.text.primary }}>Hello</Text>
 * </View>
 * ```
 */

export interface UseThemeReturn {
    colors: ThemeColors;
    mode: ThemeMode;
    currentTheme: CurrentTheme;
    setTheme: (mode: ThemeMode) => void;
    isDark: boolean;
}

export function useTheme(): UseThemeReturn {
    const { colors, mode, currentTheme, setTheme } = useThemeStore();

    return {
        colors,
        mode,
        currentTheme,
        setTheme,
        isDark: currentTheme === 'dark',
    };
}
