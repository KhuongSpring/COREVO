/**
 * Theme Color System
 * Defines semantic color tokens for Light and Dark themes
 * Use these colors in components via useTheme() hook
 */

export interface ThemeColors {
    // Background colors
    background: {
        primary: string;      // Main screen background
        secondary: string;    // Card/container background
        tertiary: string;     // Input/elevated background
    };

    // Surface colors (for cards, modals, etc.)
    surface: {
        primary: string;
        secondary: string;
        elevated: string;     // Higher elevation surfaces
        inverse: string;
    };

    // Text colors
    text: {
        primary: string;      // Main text
        secondary: string;    // Secondary/subtitle text
        tertiary: string;     // Disabled/hint text
        inverse: string;      // Text on colored backgrounds
        link: string;         // Hyperlinks
    };

    // Brand colors (maintains app identity)
    brand: {
        primary: string;      // Main brand color
        primaryHover: string;
        primaryActive: string;
        secondary: string;
        light: string;
        lighter: string;
        dark: string;
        darker: string;
    };

    // Interactive elements
    interactive: {
        normal: string;
        hover: string;
        active: string;
        disabled: string;
        darkHover: string;
    };

    // Borders and dividers
    border: {
        primary: string;
        secondary: string;
        focus: string;
    };

    divider: string;

    // Semantic/status colors
    semantic: {
        error: string;
        errorLight: string;
        success: string;
        successLight: string;
        warning: string;
        warningLight: string;
        info: string;
        infoLight: string;
    };

    // Special UI elements
    overlay: string;        // Modal/dialog overlay
    shadow: string;         // Shadow color
    ripple: string;         // Touch ripple effect

    // Status bar configuration
    statusBar: 'light-content' | 'dark-content';
}

// ============================================
// LIGHT THEME COLORS
// ============================================
export const lightTheme: ThemeColors = {
    background: {
        primary: '#FFFFFF',      // Main screen background - was Colors.wWhite
        secondary: '#F9FAFB',    // Card/container background - was Colors.wNormal
        tertiary: '#F5F7F9',     // Input/elevated background - was Colors.wLightActive
    },

    surface: {
        primary: '#FFFFFF',      // Card surface - was Colors.wWhite
        secondary: '#FCFDFD',    // Secondary surface - was Colors.wLight
        elevated: '#FFFFFF',     // Modal/dialog background - was Colors.wWhite
        inverse: '#121212',         // Dark surface - was Colors.dark
    },

    text: {
        primary: '#000000',      // Main text color - was Colors.normal
        secondary: '#757575',    // Secondary/subtitle text - was Colors.lighter
        tertiary: '#B6B6B6',     // Disabled/hint text - was Colors.moreLighter
        inverse: '#FFFFFF',      // Text on colored backgrounds - was Colors.wWhite
        link: '#148ce2',         // Hyperlinks - was Colors.bNormal
    },

    brand: {
        primary: '#148ce2',      // Main brand color - was Colors.bNormal
        primaryHover: '#127ecb', // Hover state - was Colors.bNormalHover
        primaryActive: '#1070b5',// Active/pressed state - was Colors.bNormalActive
        secondary: '#53B4FE',    // Secondary brand - was Colors.bLightActive2
        light: '#b6dbf6',        // Light brand - was Colors.bLightActive
        lighter: '#e8f4fc',      // Lighter brand - was Colors.bLight
        dark: '#0f69aa',         // Dark brand - was Colors.bDark
        darker: '#07314f',       // Darker brand - was Colors.bDarker
    },

    interactive: {
        normal: '#148ce2',       // Interactive elements - was Colors.bNormal
        hover: '#127ecb',        // Hover state - was Colors.bNormalHover
        active: '#1070b5',       // Active state - was Colors.bNormalActive
        disabled: '#D2DDE6',     // Disabled state - was Colors.wNormalNonActive
        darkHover: '#0c5488',    // Dark brand - was Colors.bDarkHover
    },

    border: {
        primary: '#E0E0E0',      // Main borders - standard grey
        secondary: '#EBEEF2',    // Secondary borders - was Colors.wNormalActive
        focus: '#148ce2',        // Focus ring - was Colors.bNormal
    },

    divider: '#EBEEF2',        // Dividers - was Colors.wNormalActive

    semantic: {
        error: '#D32F2F',        // Error messages - Material Design Red 700
        errorLight: '#FFEBEE',   // Error backgrounds - Material Design Red 50
        success: '#388E3C',      // Success messages - Material Design Green 700
        successLight: '#E8F5E9', // Success backgrounds - Material Design Green 50
        warning: '#F57C00',      // Warning messages - Material Design Orange 700
        warningLight: '#FFF3E0', // Warning backgrounds - Material Design Orange 50
        info: '#1976D2',         // Info messages - Material Design Blue 700
        infoLight: '#E3F2FD',    // Info backgrounds - was Colors.bgGenderSelection
    },

    overlay: 'rgba(0, 0, 0, 0.5)',  // Modal overlay backdrop
    shadow: 'rgba(0, 0, 0, 0.1)',   // Shadow color for elevation
    ripple: 'rgba(20, 140, 226, 0.2)', // Touch ripple effect

    statusBar: 'dark-content',       // StatusBar text should be dark on light bg
};

// ============================================
// DARK THEME COLORS
// ============================================
export const darkTheme: ThemeColors = {
    background: {
        primary: '#121212',      // Pure dark background - Material Design dark surface
        secondary: '#1E1E1E',    // Slightly elevated dark surface
        tertiary: '#2C2C2C',     // Input backgrounds, more elevated
    },

    surface: {
        primary: '#1E1E1E',      // Card surface in dark mode
        secondary: '#2C2C2C',    // Secondary surface
        elevated: '#383838',     // Modals, dialogs - highest elevation
        inverse: '#FFFFFF',      // Counter surface - was Colors.wWhite
    },

    text: {
        primary: '#FFFFFF',      // Main text on dark - high contrast
        secondary: '#B3B3B3',    // Secondary text - reduced contrast
        tertiary: '#757575',     // Disabled text - same as light mode secondary
        inverse: '#000000',      // Text on light/colored backgrounds
        link: '#53B4FE',         // Links - lighter blue for better contrast on dark
    },

    brand: {
        primary: '#53B4FE',      // Lighter blue for dark backgrounds (was bLightActive2 in light)
        primaryHover: '#6EC0FF', // Hover - even lighter
        primaryActive: '#3DA8F5',// Active - slightly darker than primary
        secondary: '#73C5FF',    // Secondary brand in dark mode
        light: '#9DC4E0',        // Light brand - was Colors.bLightNotActive
        lighter: '#B6DBEF',      // Lighter brand 
        dark: '#148ce2',         // Dark brand - original brand color
        darker: '#0f69aa',       // Darker brand - was Colors.bDark
    },

    interactive: {
        normal: '#53B4FE',       // Interactive elements - lighter for dark mode
        hover: '#6EC0FF',        // Hover state
        active: '#3DA8F5',       // Active state
        disabled: '#3A3A3A',     // Disabled state - dark grey
        darkHover: '#0c5488',    // Dark brand - was Colors.bDarkHover
    },

    border: {
        primary: '#3A3A3A',      // Main borders in dark mode
        secondary: '#2C2C2C',    // Secondary borders
        focus: '#53B4FE',        // Focus ring - lighter blue
    },

    divider: '#2C2C2C',        // Dividers in dark mode

    semantic: {
        error: '#EF5350',        // Error - lighter red for dark mode (Material Red 400)
        errorLight: '#4A2626',   // Error background - dark red tint
        success: '#66BB6A',      // Success - lighter green (Material Green 400)
        successLight: '#263626', // Success background - dark green tint
        warning: '#FFA726',      // Warning - lighter orange (Material Orange 400)
        warningLight: '#4A3826', // Warning background - dark orange tint
        info: '#42A5F5',         // Info - lighter blue (Material Blue 400)
        infoLight: '#263A4A',    // Info background - dark blue tint
    },

    overlay: 'rgba(0, 0, 0, 0.7)',  // Darker overlay for dark mode
    shadow: 'rgba(0, 0, 0, 0.5)',   // Stronger shadow for depth
    ripple: 'rgba(83, 180, 254, 0.3)', // Lighter ripple for visibility

    statusBar: 'light-content',     // StatusBar text should be light on dark bg
};

// ============================================
// THEME TYPE DEFINITIONS
// ============================================
export type ThemeMode = 'light' | 'dark';
export type CurrentTheme = 'light' | 'dark';

// ============================================
// HELPER FUNCTIONS
// ============================================

/**
 * Get theme colors based on theme name
 */
export const getThemeColors = (theme: CurrentTheme): ThemeColors => {
    return theme === 'light' ? lightTheme : darkTheme;
};

/**
 * Check if a theme mode is valid
 */
export const isValidThemeMode = (mode: string): mode is ThemeMode => {
    return ['light', 'dark'].includes(mode);
};
