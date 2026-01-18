import React, { useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { useRouter } from 'expo-router';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import SafeAreaWrapper from '@/components/common/SafeAreaWrapper';
import CustomButton from '@/components/auth/CustomButton';
import PageIndicator from '@/components/common/PageIndicator';

/**
 * Training Setup - Step 4: Training Duration
 */
export default function TrainingDurationScreen() {
    const router = useRouter();
    const [selectedDuration, setSelectedDuration] = useState('');

    const durations = [
        { id: '30', label: '30 phút', description: 'Phù hợp người bận rộn' },
        { id: '45', label: '45 phút', description: 'Cân bằng thời gian' },
        { id: '60', label: '1 giờ', description: 'Tập luyện toàn diện' },
        { id: '90', label: '1.5 giờ', description: 'Tập luyện chuyên sâu' },
    ];

    const handleNext = () => {
        if (!selectedDuration) return;
        router.push('/(training-setup)/step-5-equipment' as any);
    };

    return (
        <SafeAreaWrapper backgroundColor={Colors.wWhite}>
            <View style={styles.container}>
                {/* Header */}
                <View style={styles.header}>
                    <Text style={styles.stepNumber}>Bước 4/7</Text>
                    <Text style={styles.title}>Thời gian tập</Text>
                    <Text style={styles.subtitle}>Mỗi buổi tập bạn dành bao lâu?</Text>
                </View>

                {/* Duration Options */}
                <View style={styles.content}>
                    {durations.map((duration) => (
                        <TouchableOpacity
                            key={duration.id}
                            style={[
                                styles.durationCard,
                                selectedDuration === duration.id && styles.durationCardActive,
                            ]}
                            onPress={() => setSelectedDuration(duration.id)}
                        >
                            <View style={styles.durationContent}>
                                <Text style={[
                                    styles.durationLabel,
                                    selectedDuration === duration.id && styles.durationLabelActive,
                                ]}>
                                    {duration.label}
                                </Text>
                                <Text style={[
                                    styles.durationDescription,
                                    selectedDuration === duration.id && styles.durationDescriptionActive,
                                ]}>
                                    {duration.description}
                                </Text>
                            </View>
                            <View style={[
                                styles.radio,
                                selectedDuration === duration.id && styles.radioActive,
                            ]}>
                                {selectedDuration === duration.id && <View style={styles.radioDot} />}
                            </View>
                        </TouchableOpacity>
                    ))}
                </View>

                {/* Bottom Section */}
                <View style={styles.bottomContainer}>
                    <PageIndicator count={7} activeIndex={3} />

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
                            disabled={!selectedDuration}
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
    durationCard: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        backgroundColor: Colors.wNormal,
        borderRadius: Dims.borderRadius,
        padding: Dims.paddingL,
        borderWidth: 2,
        borderColor: 'transparent',
    },
    durationCardActive: {
        backgroundColor: Colors.bLight,
        borderColor: Colors.bNormal,
    },
    durationContent: {
        flex: 1,
    },
    durationLabel: {
        fontSize: Dims.textSizeL,
        fontWeight: 'bold',
        color: Colors.dark,
        marginBottom: Dims.spacingS,
    },
    durationLabelActive: {
        color: Colors.bNormal,
    },
    durationDescription: {
        fontSize: Dims.textSizeS,
        color: Colors.lighter,
    },
    durationDescriptionActive: {
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
