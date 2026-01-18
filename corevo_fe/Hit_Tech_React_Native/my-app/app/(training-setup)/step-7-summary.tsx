import React from 'react';
import { View, Text, StyleSheet, ScrollView, Alert } from 'react-native';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import SafeAreaWrapper from '@/components/common/SafeAreaWrapper';
import CustomButton from '@/components/auth/CustomButton';
import PageIndicator from '@/components/common/PageIndicator';

/**
 * Training Setup - Step 7: Summary & Confirmation
 */
export default function SummaryScreen() {
    const router = useRouter();

    // TODO: Get data from training setup store
    const setupData = {
        goal: 'Tăng cơ',
        experience: 'Trung bình',
        days: ['T2', 'T4', 'T6'],
        duration: '1 giờ',
        equipment: ['Tạ đơn', 'Tạ đòn'],
        focusAreas: ['Ngực', 'Lưng', 'Vai', 'Tay'],
    };

    const handleConfirm = async () => {
        // TODO: Call API to create training plan
        Alert.alert(
            'Hoàn thành!',
            'Kế hoạch tập luyện của bạn đã được tạo.',
            [
                {
                    text: 'OK',
                    onPress: () => {
                        // Navigate to main app
                        router.replace('/(tabs)' as any);
                    },
                },
            ]
        );
    };

    return (
        <SafeAreaWrapper backgroundColor={Colors.wWhite}>
            <ScrollView style={styles.container} showsVerticalScrollIndicator={false}>
                {/* Header */}
                <View style={styles.header}>
                    <Text style={styles.stepNumber}>Bước 7/7</Text>
                    <Text style={styles.title}>Tổng quan</Text>
                    <Text style={styles.subtitle}>Xem lại kế hoạch của bạn</Text>
                </View>

                {/* Summary Cards */}
                <View style={styles.content}>
                    {/* Goal */}
                    <View style={styles.summaryCard}>
                        <View style={styles.cardHeader}>
                            <Ionicons name="star" size={24} color={Colors.bNormal} />
                            <Text style={styles.cardTitle}>Mục tiêu</Text>
                        </View>
                        <Text style={styles.cardValue}>{setupData.goal}</Text>
                    </View>

                    {/* Experience */}
                    <View style={styles.summaryCard}>
                        <View style={styles.cardHeader}>
                            <Ionicons name="trophy" size={24} color={Colors.bNormal} />
                            <Text style={styles.cardTitle}>Trình độ</Text>
                        </View>
                        <Text style={styles.cardValue}>{setupData.experience}</Text>
                    </View>

                    {/* Days */}
                    <View style={styles.summaryCard}>
                        <View style={styles.cardHeader}>
                            <Ionicons name="calendar" size={24} color={Colors.bNormal} />
                            <Text style={styles.cardTitle}>Ngày tập</Text>
                        </View>
                        <Text style={styles.cardValue}>{setupData.days.join(', ')}</Text>
                        <Text style={styles.cardSubvalue}>{setupData.days.length} ngày/tuần</Text>
                    </View>

                    {/* Duration */}
                    <View style={styles.summaryCard}>
                        <View style={styles.cardHeader}>
                            <Ionicons name="time" size={24} color={Colors.bNormal} />
                            <Text style={styles.cardTitle}>Thời gian tập</Text>
                        </View>
                        <Text style={styles.cardValue}>{setupData.duration}/buổi</Text>
                    </View>

                    {/* Equipment */}
                    <View style={styles.summaryCard}>
                        <View style={styles.cardHeader}>
                            <Ionicons name="barbell" size={24} color={Colors.bNormal} />
                            <Text style={styles.cardTitle}>Thiết bị</Text>
                        </View>
                        <Text style={styles.cardValue}>{setupData.equipment.join(', ')}</Text>
                    </View>

                    {/* Focus Areas */}
                    <View style={styles.summaryCard}>
                        <View style={styles.cardHeader}>
                            <Ionicons name="body" size={24} color={Colors.bNormal} />
                            <Text style={styles.cardTitle}>Vùng tập trung</Text>
                        </View>
                        <Text style={styles.cardValue}>{setupData.focusAreas.join(', ')}</Text>
                    </View>
                </View>

                {/* Bottom Section */}
                <View style={styles.bottomContainer}>
                    <PageIndicator count={7} activeIndex={6} />

                    <View style={styles.buttonRow}>
                        <CustomButton
                            title="Quay lại"
                            onPress={() => router.back()}
                            variant="outline"
                            style={styles.backButton}
                        />
                        <CustomButton
                            title="Tạo kế hoạch"
                            onPress={handleConfirm}
                            style={styles.confirmButton}
                        />
                    </View>
                </View>
            </ScrollView>
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
        gap: Dims.spacingM,
        marginBottom: Dims.spacingXL,
    },
    summaryCard: {
        backgroundColor: Colors.wNormal,
        borderRadius: Dims.borderRadius,
        padding: Dims.paddingL,
    },
    cardHeader: {
        flexDirection: 'row',
        alignItems: 'center',
        marginBottom: Dims.spacingM,
        gap: Dims.spacingS,
    },
    cardTitle: {
        fontSize: Dims.textSizeM,
        fontWeight: '600',
        color: Colors.dark,
    },
    cardValue: {
        fontSize: Dims.textSizeL,
        fontWeight: 'bold',
        color: Colors.bNormal,
        marginBottom: Dims.spacingXS,
    },
    cardSubvalue: {
        fontSize: Dims.textSizeS,
        color: Colors.lighter,
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
    confirmButton: {
        flex: 2,
    },
});
