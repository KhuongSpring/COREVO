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
                // headerShown: false,
                // contentStyle: { backgroundColor: Colors.wWhite },
                // animation: 'slide_from_right',
                headerShown: false,
                animation: 'fade',
                contentStyle: { backgroundColor: Colors.wWhite },
                animationDuration: 200,
            }}
        >
            <Stack.Screen name="step-1-goal" />
            <Stack.Screen name="step-2-level" />
            <Stack.Screen name="step-3-duration" />
            <Stack.Screen name="step-4-type" />
            <Stack.Screen name="step-5-frequency" />
            <Stack.Screen name="step-6-location" />
            <Stack.Screen name="step-7-equipment" />
        </Stack>
    );
}
