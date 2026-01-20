import { Colors } from '@/constants/Colors';
import { Stack } from 'expo-router';

export default function Layout() {
    return (
        <Stack
            screenOptions={{
                headerShown: false,
                animation: 'fade',
                contentStyle: { backgroundColor: Colors.wWhite },
                animationDuration: 200,
            }}
        >
            <Stack.Screen name="index" />
            <Stack.Screen name="welcome-1" />
            <Stack.Screen name="welcome-2" />
        </Stack>
    );
}