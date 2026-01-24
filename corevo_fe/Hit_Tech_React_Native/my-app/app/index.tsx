import React, { useEffect } from 'react';
import { View, Text, Image, StyleSheet } from 'react-native';
import { useRouter } from 'expo-router';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { AppConfig } from '@/constants/AppConfig';
import { useAuthStore } from '@/store/authStore';
import { getSeenOnboarding } from '@/services/storage';
import { AppAssets } from '@/constants/AppAssets';

/**
 * Splash Screen
 * Shows app logo and handles initial navigation logic
 */
export default function SplashScreen() {
    const router = useRouter();
    const { isAuthenticated, checkAuthStatus } = useAuthStore();

    useEffect(() => {
        initializeApp();
    }, []);

    const initializeApp = async () => {
        // Show splash for configured duration
        await new Promise(resolve => setTimeout(resolve, AppConfig.splashDuration));

        // Check auth status
        await checkAuthStatus();

        // Check onboarding status
        const seenOnboarding = await getSeenOnboarding();

        // Navigate based on app state
        if (!seenOnboarding) {
            // First time user → Onboarding
            router.replace('/(onboarding)/intro-1' as any);
        } else if (!isAuthenticated) {
            // Not logged in → Login
            // router.replace('/(auth)/login' as any);
            // router.replace('/theme-demo' as any);
            router.replace('/(tabs)' as any);
        } else {
            // Logged in → Main App
            router.replace('/(tabs)' as any);
            // router.replace('/theme-demo' as any);
        }
    };

    return (
        <View style={styles.container}>
            <View style={styles.logoContainer}>
                {/* COREVO Logo */}
                <Image
                    source={AppAssets.logoCorevo}
                    style={styles.logo}
                    resizeMode="contain"
                />
                <Text style={styles.text}>COREVO</Text>
            </View>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: Colors.wWhite,
        alignItems: 'center',
        justifyContent: 'center',
    },
    logoContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        gap: Dims.spacingM,
    },
    logo: {
        width: Dims.size56,
        height: Dims.size56,
    },
    text: {
        fontSize: Dims.size40,
        fontWeight: 'bold',
        color: Colors.dark,
    }
});