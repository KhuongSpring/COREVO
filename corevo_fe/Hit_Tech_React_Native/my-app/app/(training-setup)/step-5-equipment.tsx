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
 * Training Setup - Step 5: Equipment Selection
 */
export default function EquipmentSelectionScreen() {
    const router = useRouter();
    const [selectedEquipment, setSelectedEquipment] = useState<string[]>([]);

    const equipment = [
        { id: 'NONE', label: 'Không thiết bị', icon: 'hand-left' },
        { id: 'DUMBBELL', label: 'Tạ đơn', icon: 'fitness' },
        { id: 'BARBELL', label: 'Tạ đòn', icon: 'barbell' },
        { id: 'CABLE', label: 'Máy cáp', icon: 'git-pull-request' },
        { id: 'MACHINE', label: 'Máy tập', icon: 'hardware-chip' },
        { id: 'FULL_GYM', label: 'Phòng gym đầy đủ', icon: 'business' },
    ];

    const toggleEquipment = (id: string) => {
        if (selectedEquipment.includes(id)) {
            setSelectedEquipment(selectedEquipment.filter(e => e !== id));
        } else {
            // If "No equipment" is selected, clear others
            if (id === 'NONE') {
                setSelectedEquipment(['NONE']);
            } else {
                // If selecting others, remove "No equipment"
                const newSelection = selectedEquipment.filter(e => e !== 'NONE');
                setSelectedEquipment([...newSelection, id]);
            }
        }
    };

    const handleNext = () => {
        if (selectedEquipment.length === 0) return;
        router.push('/(training-setup)/step-6-focus' as any);
    };

    return (
        <SafeAreaWrapper backgroundColor={Colors.wWhite}>
            <View style={styles.container}>
                {/* Header */}
                <View style={styles.header}>
                    <Text style={styles.stepNumber}>Bước 5/7</Text>
                    <Text style={styles.title}>Thiết bị</Text>
                    <Text style={styles.subtitle}>
                        Bạn có thiết bị gì?{'\n'}
                        <Text style={styles.selectedCount}>
                            Đã chọn: {selectedEquipment.length}
                        </Text>
                    </Text>
                </View>

                {/* Equipment Grid */}
                <View style={styles.content}>
                    <View style={styles.equipmentGrid}>
                        {equipment.map((item) => (
                            <TouchableOpacity
                                key={item.id}
                                style={[
                                    styles.equipmentCard,
                                    selectedEquipment.includes(item.id) && styles.equipmentCardActive,
                                ]}
                                onPress={() => toggleEquipment(item.id)}
                            >
                                <View style={[
                                    styles.iconContainer,
                                    selectedEquipment.includes(item.id) && styles.iconContainerActive,
                                ]}>
                                    <Ionicons
                                        name={item.icon as any}
                                        size={28}
                                        color={selectedEquipment.includes(item.id) ? Colors.wWhite : Colors.bNormal}
                                    />
                                </View>
                                <Text style={[
                                    styles.equipmentLabel,
                                    selectedEquipment.includes(item.id) && styles.equipmentLabelActive,
                                ]}>
                                    {item.label}
                                </Text>
                            </TouchableOpacity>
                        ))}
                    </View>
                </View>

                {/* Bottom Section */}
                <View style={styles.bottomContainer}>
                    <PageIndicator count={7} activeIndex={4} />

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
                            disabled={selectedEquipment.length === 0}
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
    equipmentGrid: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        gap: Dims.spacingM,
    },
    equipmentCard: {
        width: (Dims.width - Dims.paddingL * 2 - Dims.spacingM) / 2,
        backgroundColor: Colors.wNormal,
        borderRadius: Dims.borderRadius,
        padding: Dims.paddingL,
        borderWidth: 2,
        borderColor: 'transparent',
        alignItems: 'center',
    },
    equipmentCardActive: {
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
    equipmentLabel: {
        fontSize: Dims.textSizeM,
        fontWeight: '600',
        color: Colors.dark,
        textAlign: 'center',
    },
    equipmentLabelActive: {
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
