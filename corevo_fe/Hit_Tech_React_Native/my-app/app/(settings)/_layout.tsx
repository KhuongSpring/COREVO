import { Colors } from '@/constants/Colors';
import { Stack } from 'expo-router';

/**
 * Settings Stack Layout
 * Handles navigation for settings-related screens
 */
export default function SettingsLayout() {
    return (
        <Stack screenOptions={{
            headerShown: false,
            animation: 'fade',
            contentStyle: { backgroundColor: Colors.wWhite },
            animationDuration: 200,
        }}>
            <Stack.Screen name="personal-information" />
            <Stack.Screen name="health-information" />
            <Stack.Screen name="privacy-terms" />
        </Stack>
    );
}
