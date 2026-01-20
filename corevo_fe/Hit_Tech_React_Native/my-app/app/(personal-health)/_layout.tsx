import { Stack } from 'expo-router';
import { Colors } from '@/constants/Colors';

/**
 * Personal Health Stack Layout  
 * Stack navigator for personal health flow
 */
export default function PersonalHealthLayout() {
    return (
        <Stack
            screenOptions={{
                // headerShown: false,
                // contentStyle: { backgroundColor: Colors.wWhite },
                // animation: 'slide_from_right',
                headerShown: false,
                animation: 'fade',
                contentStyle: { backgroundColor: Colors.wWhite },
                animationDuration: 200,
            }}
        >
            <Stack.Screen name="gender-selection" />
            <Stack.Screen name="age-selection" />
            <Stack.Screen name="height-selection" />
            <Stack.Screen name="weight-selection" />
            <Stack.Screen name="activity-level-selection" />
            <Stack.Screen name="index" />
        </Stack>
    );
}
