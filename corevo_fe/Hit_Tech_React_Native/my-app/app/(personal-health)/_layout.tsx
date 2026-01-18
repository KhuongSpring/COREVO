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
                headerShown: false,
                contentStyle: { backgroundColor: Colors.wWhite },
                animation: 'slide_from_right',
            }}
        >
            <Stack.Screen name="index" />
        </Stack>
    );
}
