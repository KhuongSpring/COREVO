import React, { useState } from 'react';
import { View, Text, StyleSheet, KeyboardAvoidingView, Platform, Alert } from 'react-native';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import SafeAreaWrapper from '@/components/common/SafeAreaWrapper';
import CustomInput from '@/components/auth/CustomInput';
import CustomButton from '@/components/auth/CustomButton';
import * as authService from '@/services/authService';

/**
 * Reset Password Screen
 * Reset password after OTP verification
 */
export default function ResetPasswordScreen() {
    const router = useRouter();
    const params = useLocalSearchParams();

    const email = params.email as string;
    const otp = params.otp as string;

    const [newPassword, setNewPassword] = useState('');
    const [confirmPassword, setConfirmPassword] = useState('');
    const [errors, setErrors] = useState<{ newPassword?: string; confirmPassword?: string }>({});
    const [isLoading, setIsLoading] = useState(false);

    // Validate form
    const validateForm = (): boolean => {
        const newErrors: { newPassword?: string; confirmPassword?: string } = {};

        if (!newPassword) {
            newErrors.newPassword = 'Vui lòng nhập mật khẩu mới';
        } else if (newPassword.length < 6) {
            newErrors.newPassword = 'Mật khẩu phải có ít nhất 6 ký tự';
        }

        if (!confirmPassword) {
            newErrors.confirmPassword = 'Vui lòng xác nhận mật khẩu';
        } else if (newPassword !== confirmPassword) {
            newErrors.confirmPassword = 'Mật khẩu không khớp';
        }

        setErrors(newErrors);
        return Object.keys(newErrors).length === 0;
    };

    // Handle reset password
    const handleResetPassword = async () => {
        if (!validateForm()) return;

        setIsLoading(true);

        try {
            const response = await authService.resetPassword({
                email,
                otp,
                newPassword,
                confirmPassword,
            });

            if (response.status === 'SUCCESS') {
                Alert.alert(
                    'Thành công!',
                    'Mật khẩu đã được đặt lại thành công.',
                    [
                        {
                            text: 'OK',
                            onPress: () => {
                                // Navigate to login
                                router.replace('/(auth)/login' as any);
                            },
                        },
                    ]
                );
            } else {
                Alert.alert('Lỗi', response.message || 'Đặt lại mật khẩu thất bại');
            }
        } catch (error: any) {
            Alert.alert('Lỗi', error.response?.data?.message || 'Đặt lại mật khẩu thất bại. Vui lòng thử lại.');
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
                <View style={styles.content}>
                    {/* Header */}
                    <View style={styles.header}>
                        <View style={styles.iconContainer}>
                            <Ionicons name="lock-closed-outline" size={60} color={Colors.bNormal} />
                        </View>
                        <Text style={styles.title}>Đặt Lại Mật Khẩu</Text>
                        <Text style={styles.subtitle}>
                            Nhập mật khẩu mới cho tài khoản{'\n'}
                            <Text style={styles.email}>{email}</Text>
                        </Text>
                    </View>

                    {/* Password Form */}
                    <View style={styles.form}>
                        <CustomInput
                            label="Mật khẩu mới"
                            placeholder="Nhập mật khẩu mới"
                            value={newPassword}
                            onChangeText={(text) => {
                                setNewPassword(text);
                                if (errors.newPassword) setErrors({ ...errors, newPassword: undefined });
                            }}
                            secureTextEntry
                            icon={<Ionicons name="lock-closed-outline" size={20} color={Colors.lighter} />}
                            error={errors.newPassword}
                        />

                        <CustomInput
                            label="Xác nhận mật khẩu"
                            placeholder="Nhập lại mật khẩu mới"
                            value={confirmPassword}
                            onChangeText={(text) => {
                                setConfirmPassword(text);
                                if (errors.confirmPassword) setErrors({ ...errors, confirmPassword: undefined });
                            }}
                            secureTextEntry
                            icon={<Ionicons name="lock-closed-outline" size={20} color={Colors.lighter} />}
                            error={errors.confirmPassword}
                        />

                        {/* Reset Password Button */}
                        <CustomButton
                            title="Đặt lại mật khẩu"
                            onPress={handleResetPassword}
                            loading={isLoading}
                            disabled={isLoading}
                            style={styles.resetButton}
                        />
                    </View>
                </View>
            </KeyboardAvoidingView>
        </SafeAreaWrapper>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    content: {
        flex: 1,
        padding: Dims.paddingL,
        paddingTop: Dims.spacingGiant,
    },
    header: {
        alignItems: 'center',
        marginBottom: Dims.spacingXXL,
    },
    iconContainer: {
        width: Dims.size96,
        height: Dims.size96,
        borderRadius: Dims.size96 / 2,
        backgroundColor: Colors.bLight,
        alignItems: 'center',
        justifyContent: 'center',
        marginBottom: Dims.spacingL,
    },
    title: {
        fontSize: Dims.textSizeXXXL,
        fontWeight: 'bold',
        color: Colors.dark,
        marginBottom: Dims.spacingM,
    },
    subtitle: {
        fontSize: Dims.textSizeM,
        color: Colors.lighter,
        textAlign: 'center',
        lineHeight: Dims.textSizeM * 1.5,
    },
    email: {
        color: Colors.bNormal,
        fontWeight: '600',
    },
    form: {
        marginBottom: Dims.spacingXL,
    },
    resetButton: {
        marginTop: Dims.spacingM,
    },
});
