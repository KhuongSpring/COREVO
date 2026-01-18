import { Stack } from 'expo-router';
import { Colors } from '@/constants/Colors';

/**
 * Training Setup Stack Layout
 * 7-step training plan configuration wizard
 */
export default function TrainingSetupLayout() {
    return (
        <Stack
            screenOptions={{
                headerShown: false,
                contentStyle: { backgroundColor: Colors.wWhite },
                animation: 'slide_from_right',
            }}
        >
            <Stack.Screen name="step-1-goal" />
            <Stack.Screen name="step-2-experience" />
            <Stack.Screen name="step-3-days" />
            <Stack.Screen name="step-4-duration" />
            <Stack.Screen name="step-5-equipment" />
            <Stack.Screen name="step-6-focus" />
            <Stack.Screen name="step-7-summary" />
        </Stack>
    );
}
