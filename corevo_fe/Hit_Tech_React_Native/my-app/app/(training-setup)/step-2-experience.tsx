import React, { useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { useRouter } from 'expo-router';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import SafeAreaWrapper from '@/components/common/SafeAreaWrapper';
import CustomButton from '@/components/auth/CustomButton';
import PageIndicator from '@/components/common/PageIndicator';

/**
 * Training Setup - Step 2: Experience Level
 */
export default function ExperienceLevelScreen() {
    const router = useRouter();
    const [selectedLevel, setSelectedLevel] = useState('');

    const levels = [
        { id: 'BEGINNER', label: 'Người mới', description: 'Chưa có kinh nghiệm tập luyện' },
        { id: 'INTERMEDIATE', label: 'Trung bình', description: 'Đã tập 3-6 tháng' },
        { id: 'ADVANCED', label: 'Nâng cao', description: 'Đã tập hơn 1 năm' },
    ];

    const handleNext = () => {
        if (!selectedLevel) return;
        router.push('/(training-setup)/step-3-days' as any);
    };

    const handleBack = () => {
        router.back();
    };

    return (
        <SafeAreaWrapper backgroundColor={Colors.wWhite}>
            <View style={styles.container}>
                {/* Header */}
                <View style={styles.header}>
                    <Text style={styles.stepNumber}>Bước 2/7</Text>
                    <Text style={styles.title}>Trình độ của bạn</Text>
                    <Text style={styles.subtitle}>Bạn có kinh nghiệm tập luyện như thế nào?</Text>
                </View>

                {/* Level Options */}
                <View style={styles.content}>
                    {levels.map((level) => (
                        <TouchableOpacity
                            key={level.id}
                            style={[
                                styles.levelCard,
                                selectedLevel === level.id && styles.levelCardActive,
                            ]}
                            onPress={() => setSelectedLevel(level.id)}
                        >
                            <View style={styles.levelContent}>
                                <Text style={[
                                    styles.levelLabel,
                                    selectedLevel === level.id && styles.levelLabelActive,
                                ]}>
                                    {level.label}
                                </Text>
                                <Text style={[
                                    styles.levelDescription,
                                    selectedLevel === level.id && styles.levelDescriptionActive,
                                ]}>
                                    {level.description}
                                </Text>
                            </View>
                            <View style={[
                                styles.radio,
                                selectedLevel === level.id && styles.radioActive,
                            ]}>
                                {selectedLevel === level.id && <View style={styles.radioDot} />}
                            </View>
                        </TouchableOpacity>
                    ))}
                </View>

                {/* Bottom Section */}
                <View style={styles.bottomContainer}>
                    <PageIndicator count={7} activeIndex={1} />

                    <View style={styles.buttonRow}>
                        <CustomButton
                            title="Quay lại"
                            onPress={handleBack}
                            variant="outline"
                            style={styles.backButton}
                        />
                        <CustomButton
                            title="Tiếp theo"
                            onPress={handleNext}
                            disabled={!selectedLevel}
                            style={styles.nextButton}
                        />
                    </View>
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
    levelCard: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        backgroundColor: Colors.wNormal,
        borderRadius: Dims.borderRadius,
        padding: Dims.paddingL,
        borderWidth: 2,
        borderColor: 'transparent',
    },
    levelCardActive: {
        backgroundColor: Colors.bLight,
        borderColor: Colors.bNormal,
    },
    levelContent: {
        flex: 1,
    },
    levelLabel: {
        fontSize: Dims.textSizeL,
        fontWeight: 'bold',
        color: Colors.dark,
        marginBottom: Dims.spacingS,
    },
    levelLabelActive: {
        color: Colors.bNormal,
    },
    levelDescription: {
        fontSize: Dims.textSizeS,
        color: Colors.lighter,
    },
    levelDescriptionActive: {
        color: Colors.bNormalHover,
    },
    radio: {
        width: 24,
        height: 24,
        borderRadius: 12,
        borderWidth: 2,
        borderColor: Colors.wDark,
        alignItems: 'center',
        justifyContent: 'center',
    },
    radioActive: {
        borderColor: Colors.bNormal,
    },
    radioDot: {
        width: 12,
        height: 12,
        borderRadius: 6,
        backgroundColor: Colors.bNormal,
    },
    bottomContainer: {
        paddingBottom: Dims.spacingXXL,
        gap: Dims.spacingXL,
    },
    buttonRow: {
        flexDirection: 'row',
        gap: Dims.spacingM,
        marginTop: Dims.spacingM,
    },
    backButton: {
        flex: 1,
    },
    nextButton: {
        flex: 2,
    },
});
