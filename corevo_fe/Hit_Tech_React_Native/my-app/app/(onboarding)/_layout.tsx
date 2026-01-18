import { Stack } from 'expo-router';
import { Colors } from '@/constants/Colors';

/**
 * Onboarding Stack Layout
 * Stack navigator for onboarding screens
 */
export default function OnboardingLayout() {
    return (
        <Stack
            screenOptions={{
                headerShown: false,
                contentStyle: { backgroundColor: Colors.wWhite },
                animation: 'fade',
            }}
        >
            <Stack.Screen name="intro-1" />
            <Stack.Screen name="intro-2" />
            <Stack.Screen name="intro-3" />
        </Stack>
    );
}
