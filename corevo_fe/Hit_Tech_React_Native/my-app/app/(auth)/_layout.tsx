import { Stack } from 'expo-router';
import { Colors } from '@/constants/Colors';

/**
 * Auth Stack Layout
 * Stack navigator for authentication screens
 */
export default function AuthLayout() {
    return (
        <Stack
            screenOptions={{
                headerShown: false,
                contentStyle: { backgroundColor: Colors.wWhite },
                animation: 'slide_from_right',
            }}
        >
            <Stack.Screen name="login" />
            <Stack.Screen name="register" />
            <Stack.Screen name="forgot-password" />
        </Stack>
    );
}
