import React, { useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import SafeAreaWrapper from '@/components/common/SafeAreaWrapper';
import CustomButton from '@/components/auth/CustomButton';
import PageIndicator from '@/components/common/PageIndicator';

/**
 * Training Setup - Step 1: Goal Selection
 */
export default function GoalSelectionScreen() {
    const router = useRouter();
    const [selectedGoal, setSelectedGoal] = useState('');

    const goals = [
        { id: 'BUILD_MUSCLE', label: 'Tăng cơ', icon: 'barbell', description: 'Phát triển khối lượng cơ bắp' },
        { id: 'LOSE_WEIGHT', label: 'Giảm cân', icon: 'fitness', description: 'Đốt cháy mỡ thừa' },
        { id: 'STAY_FIT', label: 'Giữ dáng', icon: 'heart', description: 'Duy trì vóc dáng hiện tại' },
        { id: 'INCREASE_STRENGTH', label: 'Tăng sức mạnh', icon: 'flash', description: 'Cải thiện sức mạnh tổng thể' },
    ];

    const handleNext = () => {
        if (!selectedGoal) return;
        // TODO: Save selection to store
        router.push('/(training-setup)/step-2-experience' as any);
    };

    return (
        <SafeAreaWrapper backgroundColor={Colors.wWhite}>
            <View style={styles.container}>
                {/* Header */}
                <View style={styles.header}>
                    <Text style={styles.stepNumber}>Bước 1/7</Text>
                    <Text style={styles.title}>Mục tiêu tập luyện</Text>
                    <Text style={styles.subtitle}>Bạn muốn đạt được điều gì?</Text>
                </View>

                {/* Goal Options */}
                <View style={styles.content}>
                    {goals.map((goal) => (
                        <TouchableOpacity
                            key={goal.id}
                            style={[
                                styles.goalCard,
                                selectedGoal === goal.id && styles.goalCardActive,
                            ]}
                            onPress={() => setSelectedGoal(goal.id)}
                        >
                            <View style={[
                                styles.iconContainer,
                                selectedGoal === goal.id && styles.iconContainerActive,
                            ]}>
                                <Ionicons
                                    name={goal.icon as any}
                                    size={32}
                                    color={selectedGoal === goal.id ? Colors.wWhite : Colors.bNormal}
                                />
                            </View>
                            <Text style={[
                                styles.goalLabel,
                                selectedGoal === goal.id && styles.goalLabelActive,
                            ]}>
                                {goal.label}
                            </Text>
                            <Text style={[
                                styles.goalDescription,
                                selectedGoal === goal.id && styles.goalDescriptionActive,
                            ]}>
                                {goal.description}
                            </Text>
                        </TouchableOpacity>
                    ))}
                </View>

                {/* Bottom Section */}
                <View style={styles.bottomContainer}>
                    <PageIndicator count={7} activeIndex={0} />

                    <CustomButton
                        title="Tiếp theo"
                        onPress={handleNext}
                        disabled={!selectedGoal}
                        style={styles.nextButton}
                    />
                </View>
            </View>
        </SafeAreaWrapper>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        paddingHorizontal: Dims.paddingL,
    },
    header: {
        paddingTop: Dims.spacingL,
        marginBottom: Dims.spacingXL,
    },
    stepNumber: {
        fontSize: Dims.textSizeS,
        color: Colors.bNormal,
        fontWeight: '600',
        marginBottom: Dims.spacingS,
    },
    title: {
        fontSize: Dims.textSizeXXXL,
        fontWeight: 'bold',
        color: Colors.dark,
        marginBottom: Dims.spacingS,
    },
    subtitle: {
        fontSize: Dims.textSizeM,
        color: Colors.lighter,
    },
    content: {
        flex: 1,
        gap: Dims.spacingM,
    },
    goalCard: {
        backgroundColor: Colors.wNormal,
        borderRadius: Dims.borderRadius,
        padding: Dims.paddingL,
        borderWidth: 2,
        borderColor: 'transparent',
    },
    goalCardActive: {
        backgroundColor: Colors.bLight,
        borderColor: Colors.bNormal,
    },
    iconContainer: {
        width: Dims.size56,
        height: Dims.size56,
        borderRadius: Dims.size28,
        backgroundColor: Colors.bLight,
        alignItems: 'center',
        justifyContent: 'center',
        marginBottom: Dims.spacingM,
    },
    iconContainerActive: {
        backgroundColor: Colors.bNormal,
    },
    goalLabel: {
        fontSize: Dims.textSizeL,
        fontWeight: 'bold',
        color: Colors.dark,
        marginBottom: Dims.spacingS,
    },
    goalLabelActive: {
        color: Colors.bNormal,
    },
    goalDescription: {
        fontSize: Dims.textSizeM,
        color: Colors.lighter,
    },
    goalDescriptionActive: {
        color: Colors.bNormalHover,
    },
    bottomContainer: {
        paddingBottom: Dims.spacingXXL,
        gap: Dims.spacingXL,
    },
    nextButton: {
        marginTop: Dims.spacingM,
    },
});
