import { Colors } from '@/constants/Colors';
import { Stack } from 'expo-router';
import { ThemeProvider } from '@/components/ThemeProvider';

export default function Layout() {
    return (
        <ThemeProvider>
            <Stack
                screenOptions={{
                    headerShown: false,
                    animation: 'fade',
                    animationDuration: 200,
                }}
            >
                <Stack.Screen name="index" />
                <Stack.Screen name="welcome-1" />
                <Stack.Screen name="welcome-2" />
            </Stack>
        </ThemeProvider>
    );
}