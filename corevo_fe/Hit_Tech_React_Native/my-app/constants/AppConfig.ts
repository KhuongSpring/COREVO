/**
 * App Configuration
 * Global app settings and constants
 */

export const AppConfig = {
    // App Info
    appName: 'Corevo',
    appVersion: '1.0.0',

    // Design Size (for responsive scaling)
    designWidth: 412,
    designHeight: 917,

    // Timeouts (milliseconds)
    apiTimeout: 10000,
    splashDuration: 3000,

    // Storage Keys
    storageKeys: {
        accessToken: 'accessToken',
        refreshToken: 'refreshToken',
        seenOnboarding: 'seenOnboarding',
        userId: 'userId',
    },

    // Pagination
    defaultPageSize: 20,

    // OTP
    otpLength: 6,
    otpResendDelay: 30, // seconds

    // Image Upload
    maxImageSize: 5 * 1024 * 1024, // 5MB
    allowedImageTypes: ['image/jpeg', 'image/png', 'image/jpg'],

    // App Links
    termsUrl: 'https://corevo.com/terms',
    privacyUrl: 'https://corevo.com/privacy',
    supportEmail: 'support@corevo.com',

    // Feature Flags
    features: {
        googleSignIn: true,
        facebookSignIn: false,
        socialFeeds: true,
    },
} as const;

export type AppConfigType = typeof AppConfig;
