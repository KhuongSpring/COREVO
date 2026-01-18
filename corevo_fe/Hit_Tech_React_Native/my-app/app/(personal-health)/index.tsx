import React, { useState } from 'react';
import { View, Text, StyleSheet, ScrollView, KeyboardAvoidingView, Platform, Alert, TouchableOpacity } from 'react-native';
import { useRouter } from 'expo-router';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import SafeAreaWrapper from '@/components/common/SafeAreaWrapper';
import CustomInput from '@/components/auth/CustomInput';
import CustomButton from '@/components/auth/CustomButton';

/**
 * Personal Health Screen
 * Collect user health information
 */
export default function PersonalHealthScreen() {
    const router = useRouter();

    const [formData, setFormData] = useState({
        gender: '',
        age: '',
        height: '',
        weight: '',
        targetWeight: '',
        activityLevel: '',
    });

    const [errors, setErrors] = useState<{ [key: string]: string }>({});
    const [isLoading, setIsLoading] = useState(false);

    const genderOptions = [
        { label: 'Nam', value: 'MALE' },
        { label: 'Nữ', value: 'FEMALE' },
        { label: 'Khác', value: 'OTHER' },
    ];

    const activityLevels = [
        { label: 'Ít vận động', value: 'SEDENTARY', description: 'Làm việc văn phòng, ít hoạt động' },
        { label: 'Vận động nhẹ', value: 'LIGHTLY_ACTIVE', description: 'Tập 1-3 ngày/tuần' },
        { label: 'Vận động vừa', value: 'MODERATELY_ACTIVE', description: 'Tập 3-5 ngày/tuần' },
        { label: 'Vận động nhiều', value: 'VERY_ACTIVE', description: 'Tập 6-7 ngày/tuần' },
        { label: 'Vận động rất nhiều', value: 'EXTRA_ACTIVE', description: 'Tập nặng hàng ngày' },
    ];

    // Update field
    const updateField = (field: string, value: string) => {
        setFormData({ ...formData, [field]: value });
        if (errors[field]) {
            setErrors({ ...errors, [field]: '' });
        }
    };

    // Validate form
    const validateForm = (): boolean => {
        const newErrors: { [key: string]: string } = {};

        if (!formData.gender) {
            newErrors.gender = 'Vui lòng chọn giới tính';
        }

        if (!formData.age) {
            newErrors.age = 'Vui lòng nhập tuổi';
        } else if (parseInt(formData.age) < 10 || parseInt(formData.age) > 100) {
            newErrors.age = 'Tuổi phải từ 10 đến 100';
        }

        if (!formData.height) {
            newErrors.height = 'Vui lòng nhập chiều cao';
        } else if (parseInt(formData.height) < 100 || parseInt(formData.height) > 250) {
            newErrors.height = 'Chiều cao phải từ 100 đến 250 cm';
        }

        if (!formData.weight) {
            newErrors.weight = 'Vui lòng nhập cân nặng';
        } else if (parseInt(formData.weight) < 30 || parseInt(formData.weight) > 300) {
            newErrors.weight = 'Cân nặng phải từ 30 đến 300 kg';
        }

        if (!formData.activityLevel) {
            newErrors.activityLevel = 'Vui lòng chọn mức độ hoạt động';
        }

        setErrors(newErrors);
        return Object.keys(newErrors).length === 0;
    };

    // Handle submit
    const handleSubmit = async () => {
        if (!validateForm()) return;

        setIsLoading(true);

        try {
            // TODO: Call API to save health information
            // await userService.updateHealthProfile(formData);

            // For now, just show success and navigate
            Alert.alert('Thành công!', 'Thông tin sức khỏe đã được lưu.', [
                {
                    text: 'OK',
                    onPress: () => {
                        // Navigate to Training Flow or Main App
                        router.replace('/(tabs)' as any);
                    },
                },
            ]);
        } catch (error: any) {
            Alert.alert('Lỗi', 'Không thể lưu thông tin. Vui lòng thử lại.');
        } finally {
            setIsLoading(false);
        }
    };

    return (
        <SafeAreaWrapper backgroundColor={Colors.wWhite}>
            <KeyboardAvoidingView
                behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
                style={styles.container}
            >
                <ScrollView
                    contentContainerStyle={styles.scrollContent}
                    keyboardShouldPersistTaps="handled"
                    showsVerticalScrollIndicator={false}
                >
                    {/* Header */}
                    <View style={styles.header}>
                        <Text style={styles.title}>Thông Tin Sức Khỏe</Text>
                        <Text style={styles.subtitle}>
                            Cung cấp thông tin để tạo kế hoạch phù hợp
                        </Text>
                    </View>

                    {/* Gender Selection */}
                    <View style={styles.section}>
                        <Text style={styles.label}>Giới tính *</Text>
                        <View style={styles.genderContainer}>
                            {genderOptions.map((option) => (
                                <TouchableOpacity
                                    key={option.value}
                                    style={[
                                        styles.genderButton,
                                        formData.gender === option.value && styles.genderButtonActive,
                                    ]}
                                    onPress={() => updateField('gender', option.value)}
                                >
                                    <Text
                                        style={[
                                            styles.genderButtonText,
                                            formData.gender === option.value && styles.genderButtonTextActive,
                                        ]}
                                    >
                                        {option.label}
                                    </Text>
                                </TouchableOpacity>
                            ))}
                        </View>
                        {errors.gender && <Text style={styles.errorText}>{errors.gender}</Text>}
                    </View>

                    {/* Age, Height, Weight */}
                    <View style={styles.row}>
                        <View style={styles.rowItem}>
                            <CustomInput
                                label="Tuổi *"
                                placeholder="25"
                                value={formData.age}
                                onChangeText={(text) => updateField('age', text)}
                                keyboardType="numeric"
                                error={errors.age}
                            />
                        </View>
                        <View style={styles.rowItem}>
                            <CustomInput
                                label="Chiều cao (cm) *"
                                placeholder="170"
                                value={formData.height}
                                onChangeText={(text) => updateField('height', text)}
                                keyboardType="numeric"
                                error={errors.height}
                            />
                        </View>
                    </View>

                    <View style={styles.row}>
                        <View style={styles.rowItem}>
                            <CustomInput
                                label="Cân nặng (kg) *"
                                placeholder="70"
                                value={formData.weight}
                                onChangeText={(text) => updateField('weight', text)}
                                keyboardType="numeric"
                                error={errors.weight}
                            />
                        </View>
                        <View style={styles.rowItem}>
                            <CustomInput
                                label="Cân nặng mục tiêu (kg)"
                                placeholder="65"
                                value={formData.targetWeight}
                                onChangeText={(text) => updateField('targetWeight', text)}
                                keyboardType="numeric"
                            />
                        </View>
                    </View>

                    {/* Activity Level */}
                    <View style={styles.section}>
                        <Text style={styles.label}>Mức độ hoạt động *</Text>
                        {activityLevels.map((level) => (
                            <TouchableOpacity
                                key={level.value}
                                style={[
                                    styles.activityButton,
                                    formData.activityLevel === level.value && styles.activityButtonActive,
                                ]}
                                onPress={() => updateField('activityLevel', level.value)}
                            >
                                <View style={styles.activityContent}>
                                    <Text
                                        style={[
                                            styles.activityLabel,
                                            formData.activityLevel === level.value && styles.activityLabelActive,
                                        ]}
                                    >
                                        {level.label}
                                    </Text>
                                    <Text
                                        style={[
                                            styles.activityDescription,
                                            formData.activityLevel === level.value && styles.activityDescriptionActive,
                                        ]}
                                    >
                                        {level.description}
                                    </Text>
                                </View>
                                <View
                                    style={[
                                        styles.radio,
                                        formData.activityLevel === level.value && styles.radioActive,
                                    ]}
                                >
                                    {formData.activityLevel === level.value && <View style={styles.radioDot} />}
                                </View>
                            </TouchableOpacity>
                        ))}
                        {errors.activityLevel && <Text style={styles.errorText}>{errors.activityLevel}</Text>}
                    </View>

                    {/* Submit Button */}
                    <CustomButton
                        title="Tiếp tục"
                        onPress={handleSubmit}
                        loading={isLoading}
                        disabled={isLoading}
                        style={styles.submitButton}
                    />
                </ScrollView>
            </KeyboardAvoidingView>
        </SafeAreaWrapper>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    scrollContent: {
        flexGrow: 1,
        padding: Dims.paddingL,
        paddingTop: Dims.spacingXL,
    },
    header: {
        marginBottom: Dims.spacingXL,
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
    section: {
        marginBottom: Dims.spacingL,
    },
    label: {
        fontSize: Dims.textSizeM,
        fontWeight: '600',
        color: Colors.dark,
        marginBottom: Dims.spacingM,
    },
    genderContainer: {
        flexDirection: 'row',
        gap: Dims.spacingM,
    },
    genderButton: {
        flex: 1,
        paddingVertical: Dims.paddingM,
        borderRadius: Dims.borderRadius,
        borderWidth: 1.5,
        borderColor: Colors.wDark,
        backgroundColor: Colors.wWhite,
        alignItems: 'center',
    },
    genderButtonActive: {
        borderColor: Colors.bNormal,
        backgroundColor: Colors.bLight,
    },
    genderButtonText: {
        fontSize: Dims.textSizeM,
        fontWeight: '600',
        color: Colors.lighter,
    },
    genderButtonTextActive: {
        color: Colors.bNormal,
    },
    row: {
        flexDirection: 'row',
        gap: Dims.spacingM,
        marginBottom: Dims.spacingM,
    },
    rowItem: {
        flex: 1,
    },
    activityButton: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        padding: Dims.paddingM,
        borderRadius: Dims.borderRadius,
        borderWidth: 1.5,
        borderColor: Colors.wDark,
        backgroundColor: Colors.wWhite,
        marginBottom: Dims.spacingM,
    },
    activityButtonActive: {
        borderColor: Colors.bNormal,
        backgroundColor: Colors.bLight,
    },
    activityContent: {
        flex: 1,
    },
    activityLabel: {
        fontSize: Dims.textSizeM,
        fontWeight: '600',
        color: Colors.dark,
        marginBottom: Dims.spacingXS,
    },
    activityLabelActive: {
        color: Colors.bNormal,
    },
    activityDescription: {
        fontSize: Dims.textSizeS,
        color: Colors.lighter,
    },
    activityDescriptionActive: {
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
    errorText: {
        fontSize: Dims.textSizeXS,
        color: '#EF4444',
        marginTop: Dims.spacingS,
    },
    submitButton: {
        marginTop: Dims.spacingL,
        marginBottom: Dims.spacingXXL,
    },
});
