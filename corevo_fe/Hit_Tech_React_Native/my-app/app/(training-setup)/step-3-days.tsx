import React, { useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { useRouter } from 'expo-router';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import SafeAreaWrapper from '@/components/common/SafeAreaWrapper';
import CustomButton from '@/components/auth/CustomButton';
import PageIndicator from '@/components/common/PageIndicator';

/**
 * Training Setup - Step 3: Available Days
 */
export default function AvailableDaysScreen() {
    const router = useRouter();
    const [selectedDays, setSelectedDays] = useState<string[]>([]);

    const days = [
        { id: 'MON', label: 'T2' },
        { id: 'TUE', label: 'T3' },
        { id: 'WED', label: 'T4' },
        { id: 'THU', label: 'T5' },
        { id: 'FRI', label: 'T6' },
        { id: 'SAT', label: 'T7' },
        { id: 'SUN', label: 'CN' },
    ];

    const toggleDay = (dayId: string) => {
        if (selectedDays.includes(dayId)) {
            setSelectedDays(selectedDays.filter(d => d !== dayId));
        } else {
            setSelectedDays([...selectedDays, dayId]);
        }
    };

    const handleNext = () => {
        if (selectedDays.length === 0) return;
        router.push('/(training-setup)/step-4-duration' as any);
    };

    return (
        <SafeAreaWrapper backgroundColor={Colors.wWhite}>
            <View style={styles.container}>
                {/* Header */}
                <View style={styles.header}>
                    <Text style={styles.stepNumber}>Bước 3/7</Text>
                    <Text style={styles.title}>Ngày tập luyện</Text>
                    <Text style={styles.subtitle}>
                        Chọn những ngày bạn có thể tập{'\n'}
                        <Text style={styles.selectedCount}>
                            Đã chọn: {selectedDays.length} ngày
                        </Text>
                    </Text>
                </View>

                {/* Days Selection */}
                <View style={styles.content}>
                    <View style={styles.daysGrid}>
                        {days.map((day) => (
                            <TouchableOpacity
                                key={day.id}
                                style={[
                                    styles.dayButton,
                                    selectedDays.includes(day.id) && styles.dayButtonActive,
                                ]}
                                onPress={() => toggleDay(day.id)}
                            >
                                <Text style={[
                                    styles.dayLabel,
                                    selectedDays.includes(day.id) && styles.dayLabelActive,
                                ]}>
                                    {day.label}
                                </Text>
                            </TouchableOpacity>
                        ))}
                    </View>
                </View>

                {/* Bottom Section */}
                <View style={styles.bottomContainer}>
                    <PageIndicator count={7} activeIndex={2} />

                    <View style={styles.buttonRow}>
                        <CustomButton
                            title="Quay lại"
                            onPress={() => router.back()}
                            variant="outline"
                            style={styles.backButton}
                        />
                        <CustomButton
                            title="Tiếp theo"
                            onPress={handleNext}
                            disabled={selectedDays.length === 0}
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
    selectedCount: {
        color: Colors.bNormal,
        fontWeight: '600',
    },
    content: {
        flex: 1,
    },
    daysGrid: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        gap: Dims.spacingM,
    },
    dayButton: {
        width: (Dims.width - Dims.paddingL * 2 - Dims.spacingM * 2) / 3,
        aspectRatio: 1.5,
        backgroundColor: Colors.wNormal,
        borderRadius: Dims.borderRadius,
        borderWidth: 2,
        borderColor: 'transparent',
        alignItems: 'center',
        justifyContent: 'center',
    },
    dayButtonActive: {
        backgroundColor: Colors.bNormal,
        borderColor: Colors.bDark,
    },
    dayLabel: {
        fontSize: Dims.textSizeXL,
        fontWeight: 'bold',
        color: Colors.dark,
    },
    dayLabelActive: {
        color: Colors.wWhite,
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
