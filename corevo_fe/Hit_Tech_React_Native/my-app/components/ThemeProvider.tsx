import React, { useEffect } from 'react';
import { StatusBar } from 'react-native';
import { useThemeStore } from '@/store/themeStore';

/**
 * Theme Provider Component
 * Initializes theme on mount and provides theme context to children
 */

interface ThemeProviderProps {
    children: React.ReactNode;
}

export function ThemeProvider({ children }: ThemeProviderProps) {
    const { currentTheme, colors, initTheme } = useThemeStore();

    // Initialize theme on mount
    useEffect(() => {
        initTheme();
    }, []);

    // Update theme when app state changes
    useEffect(() => {
        // Listen for app state changes (foreground/background)
        // This ensures theme updates when user changes system theme while app is backgrounded
        // Note: You may want to add AppState listener here in production

        return () => {
            // Cleanup if needed
        };
    }, []);

    // Update StatusBar based on theme
    useEffect(() => {
        StatusBar.setBarStyle(colors.statusBar, true);
    }, [colors.statusBar]);

    return <>{children}</>;
}
