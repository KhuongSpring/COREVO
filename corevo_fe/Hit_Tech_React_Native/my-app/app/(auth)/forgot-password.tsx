import React, { useState } from 'react';
import { View, Text, StyleSheet, KeyboardAvoidingView, Platform, Alert } from 'react-native';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import SafeAreaWrapper from '@/components/common/SafeAreaWrapper';
import CustomInput from '@/components/auth/CustomInput';
import CustomButton from '@/components/auth/CustomButton';
import * as authService from '@/services/authService';

/**
 * Forgot Password Screen
 * Send OTP to email for password reset
 */
export default function ForgotPasswordScreen() {
    const router = useRouter();

    const [email, setEmail] = useState('');
    const [error, setError] = useState('');
    const [isLoading, setIsLoading] = useState(false);

    // Validate email
    const isValidEmail = (email: string): boolean => {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    };

    // Handle send OTP
    const handleSendOtp = async () => {
        if (!email.trim()) {
            setError('Vui lòng nhập email');
            return;
        }

        if (!isValidEmail(email)) {
            setError('Email không hợp lệ');
            return;
        }

        setIsLoading(true);
        setError('');

        try {
            const response = await authService.sendEmailToForgotPassword({ email: email.trim() });

            if (response.status === 'SUCCESS') {
                Alert.alert(
                    'Thành công!',
                    'Mã OTP đã được gửi đến email của bạn.',
                    [
                        {
                            text: 'OK',
                            onPress: () => {
                                router.push({
                                    pathname: '/(auth)/otp-verification',
                                    params: { email: email.trim(), type: 'reset-password' },
                                } as any);
                            },
                        },
                    ]
                );
            } else {
                Alert.alert('Lỗi', response.message || 'Không thể gửi mã OTP');
            }
        } catch (error: any) {
            Alert.alert('Lỗi', error.response?.data?.message || 'Không thể gửi mã OTP. Vui lòng thử lại.');
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
                            <Ionicons name="key-outline" size={60} color={Colors.bNormal} />
                        </View>
                        <Text style={styles.title}>Quên Mật Khẩu?</Text>
                        <Text style={styles.subtitle}>
                            Nhập email của bạn để nhận mã OTP{'\n'}
                            khôi phục mật khẩu
                        </Text>
                    </View>

                    {/* Email Input */}
                    <View style={styles.form}>
                        <CustomInput
                            label="Email"
                            placeholder="Nhập email của bạn"
                            value={email}
                            onChangeText={(text) => {
                                setEmail(text);
                                if (error) setError('');
                            }}
                            keyboardType="email-address"
                            icon={<Ionicons name="mail-outline" size={20} color={Colors.lighter} />}
                            error={error}
                        />

                        {/* Send OTP Button */}
                        <CustomButton
                            title="Gửi mã OTP"
                            onPress={handleSendOtp}
                            loading={isLoading}
                            disabled={isLoading}
                            style={styles.sendButton}
                        />

                        {/* Back to Login */}
                        <CustomButton
                            title="Quay lại Đăng nhập"
                            onPress={() => router.back()}
                            variant="outline"
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
    form: {
        marginBottom: Dims.spacingXL,
    },
    sendButton: {
        marginBottom: Dims.spacingM,
    },
});
