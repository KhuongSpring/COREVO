import React, { useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, ScrollView } from 'react-native';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import SafeAreaWrapper from '@/components/common/SafeAreaWrapper';
import CustomButton from '@/components/auth/CustomButton';
import PageIndicator from '@/components/common/PageIndicator';

/**
 * Training Setup - Step 6: Focus Areas
 */
export default function FocusAreasScreen() {
    const router = useRouter();
    const [selectedAreas, setSelectedAreas] = useState<string[]>([]);

    const areas = [
        { id: 'CHEST', label: 'Ngực', icon: 'body' },
        { id: 'BACK', label: 'Lưng', icon: 'hand-right' },
        { id: 'SHOULDERS', label: 'Vai', icon: 'stop-circle' },
        { id: 'ARMS', label: 'Tay', icon: 'arrow-down-circle' },
        { id: 'ABS', label: 'Bụng', icon: 'square' },
        { id: 'LEGS', label: 'Chân', icon: 'walk' },
        { id: 'CARDIO', label: 'Tim mạch', icon: 'heart' },
        { id: 'FULL_BODY', label: 'Toàn thân', icon: 'person' },
    ];

    const toggleArea = (id: string) => {
        if (selectedAreas.includes(id)) {
            setSelectedAreas(selectedAreas.filter(a => a !== id));
        } else {
            setSelectedAreas([...selectedAreas, id]);
        }
    };

    const handleNext = () => {
        if (selectedAreas.length === 0) return;
        router.push('/(training-setup)/step-7-summary' as any);
    };

    return (
        <SafeAreaWrapper backgroundColor={Colors.wWhite}>
            <View style={styles.container}>
                {/* Header */}
                <View style={styles.header}>
                    <Text style={styles.stepNumber}>Bước 6/7</Text>
                    <Text style={styles.title}>Vùng tập trung</Text>
                    <Text style={styles.subtitle}>
                        Bạn muốn tập trung vào phần nào?{'\n'}
                        <Text style={styles.selectedCount}>
                            Đã chọn: {selectedAreas.length}
                        </Text>
                    </Text>
                </View>

                {/* Focus Areas Grid */}
                <ScrollView style={styles.content} showsVerticalScrollIndicator={false}>
                    <View style={styles.areasGrid}>
                        {areas.map((area) => (
                            <TouchableOpacity
                                key={area.id}
                                style={[
                                    styles.areaCard,
                                    selectedAreas.includes(area.id) && styles.areaCardActive,
                                ]}
                                onPress={() => toggleArea(area.id)}
                            >
                                <View style={[
                                    styles.iconContainer,
                                    selectedAreas.includes(area.id) && styles.iconContainerActive,
                                ]}>
                                    <Ionicons
                                        name={area.icon as any}
                                        size={28}
                                        color={selectedAreas.includes(area.id) ? Colors.wWhite : Colors.bNormal}
                                    />
                                </View>
                                <Text style={[
                                    styles.areaLabel,
                                    selectedAreas.includes(area.id) && styles.areaLabelActive,
                                ]}>
                                    {area.label}
                                </Text>
                            </TouchableOpacity>
                        ))}
                    </View>
                </ScrollView>

                {/* Bottom Section */}
                <View style={styles.bottomContainer}>
                    <PageIndicator count={7} activeIndex={5} />

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
                            disabled={selectedAreas.length === 0}
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
    areasGrid: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        gap: Dims.spacingM,
    },
    areaCard: {
        width: (Dims.width - Dims.paddingL * 2 - Dims.spacingM) / 2,
        backgroundColor: Colors.wNormal,
        borderRadius: Dims.borderRadius,
        padding: Dims.paddingL,
        borderWidth: 2,
        borderColor: 'transparent',
        alignItems: 'center',
    },
    areaCardActive: {
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
    areaLabel: {
        fontSize: Dims.textSizeM,
        fontWeight: '600',
        color: Colors.dark,
        textAlign: 'center',
    },
    areaLabelActive: {
        color: Colors.bNormal,
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
