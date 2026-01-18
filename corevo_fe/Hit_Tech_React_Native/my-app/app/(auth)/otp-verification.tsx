import React, { useState, useEffect, useRef } from 'react';
import { View, Text, StyleSheet, Alert, TextInput, TouchableOpacity } from 'react-native';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { AppConfig } from '@/constants/AppConfig';
import SafeAreaWrapper from '@/components/common/SafeAreaWrapper';
import CustomButton from '@/components/auth/CustomButton';
import * as authService from '@/services/authService';
import { useAuthStore } from '@/store/authStore';

/**
 * OTP Verification Screen
 * Verify OTP code sent to email
 */
export default function OtpVerificationScreen() {
    const router = useRouter();
    const params = useLocalSearchParams();
    const { setTokens } = useAuthStore();

    const email = params.email as string;
    const type = params.type as 'register' | 'reset-password' | 'recovery';

    const [otp, setOtp] = useState(['', '', '', '', '', '']);
    const [isLoading, setIsLoading] = useState(false);
    const [resendCountdown, setResendCountdown] = useState(0);

    const inputRefs = useRef<(TextInput | null)[]>([]);

    // Start countdown on mount
    useEffect(() => {
        startResendCountdown();
        // Auto focus first input
        setTimeout(() => inputRefs.current[0]?.focus(), 100);
    }, []);

    // Countdown timer
    useEffect(() => {
        if (resendCountdown > 0) {
            const timer = setTimeout(() => setResendCountdown(resendCountdown - 1), 1000);
            return () => clearTimeout(timer);
        }
    }, [resendCountdown]);

    const startResendCountdown = () => {
        setResendCountdown(AppConfig.otpResendDelay);
    };

    // Handle OTP input change
    const handleOtpChange = (index: number, value: string) => {
        if (value.length > 1) return; // Only allow single digit

        const newOtp = [...otp];
        newOtp[index] = value;
        setOtp(newOtp);

        // Auto focus next input
        if (value && index < 5) {
            inputRefs.current[index + 1]?.focus();
        }
    };

    // Handle backspace
    const handleKeyPress = (index: number, key: string) => {
        if (key === 'Backspace' && !otp[index] && index > 0) {
            inputRefs.current[index - 1]?.focus();
        }
    };

    // Verify OTP
    const handleVerifyOtp = async () => {
        const otpCode = otp.join('');

        if (otpCode.length !== AppConfig.otpLength) {
            Alert.alert('Lỗi', 'Vui lòng nhập đầy đủ mã OTP');
            return;
        }

        setIsLoading(true);

        try {
            let response;

            if (type === 'register') {
                response = await authService.verifyOtpToRegister({ email, otp: otpCode });
            } else if (type === 'reset-password') {
                response = await authService.verifyOtpToResetPassword({ email, otp: otpCode });
            } else {
                response = await authService.verifyOtpToRecover({ email, otp: otpCode });
            }

            if (response.status === 'SUCCESS') {
                if (type === 'register' || type === 'recovery') {
                    // Set tokens and navigate to main app
                    if (response.data.accessToken && response.data.refreshToken) {
                        setTokens(response.data.accessToken, response.data.refreshToken);
                    }

                    Alert.alert('Thành công!', 'Xác thực thành công!', [
                        {
                            text: 'OK',
                            onPress: () => router.replace('/welcome' as any),
                        },
                    ]);
                } else {
                    // Navigate to reset password screen
                    router.push({
                        pathname: '/(auth)/reset-password',
                        params: { email, otp: otpCode },
                    } as any);
                }
            } else {
                Alert.alert('Lỗi', response.message || 'Mã OTP không hợp lệ');
            }
        } catch (error: any) {
            Alert.alert('Lỗi', error.response?.data?.message || 'Xác thực thất bại. Vui lòng thử lại.');
        } finally {
            setIsLoading(false);
        }
    };

    // Resend OTP
    const handleResendOtp = async () => {
        if (resendCountdown > 0) return;

        try {
            // Resend based on type
            if (type === 'reset-password') {
                await authService.sendEmailToForgotPassword({ email });
            } else if (type === 'recovery') {
                await authService.sendEmailToRecoveryAccount(email);
            }

            Alert.alert('Thành công', 'Mã OTP mới đã được gửi đến email của bạn');
            setOtp(['', '', '', '', '', '']);
            startResendCountdown();
            inputRefs.current[0]?.focus();
        } catch (error) {
            Alert.alert('Lỗi', 'Không thể gửi lại mã OTP. Vui lòng thử lại.');
        }
    };

    return (
        <SafeAreaWrapper backgroundColor={Colors.wWhite}>
            <View style={styles.container}>
                {/* Header */}
                <View style={styles.header}>
                    <Text style={styles.title}>Xác Thực OTP</Text>
                    <Text style={styles.subtitle}>
                        Mã xác thực đã được gửi đến{'\n'}
                        <Text style={styles.email}>{email}</Text>
                    </Text>
                </View>

                {/* OTP Input */}
                <View style={styles.otpContainer}>
                    {otp.map((digit, index) => (
                        <TouchableOpacity
                            key={index}
                            style={styles.otpInputWrapper}
                            onPress={() => inputRefs.current[index]?.focus()}
                        >
                            <TextInput
                                ref={(ref) => (inputRefs.current[index] = ref)}
                                style={styles.otpInput}
                                value={digit}
                                onChangeText={(value) => handleOtpChange(index, value)}
                                onKeyPress={({ nativeEvent }) => handleKeyPress(index, nativeEvent.key)}
                                keyboardType="number-pad"
                                maxLength={1}
                                selectTextOnFocus
                                textAlign="center"
                            />
                        </TouchableOpacity>
                    ))}
                </View>

                {/* Verify Button */}
                <CustomButton
                    title="Xác nhận"
                    onPress={handleVerifyOtp}
                    loading={isLoading}
                    disabled={isLoading}
                    style={styles.verifyButton}
                />

                {/* Resend OTP */}
                <View style={styles.resendContainer}>
                    {resendCountdown > 0 ? (
                        <Text style={styles.resendText}>
                            Gửi lại mã sau {resendCountdown}s
                        </Text>
                    ) : (
                        <CustomButton
                            title="Gửi lại mã OTP"
                            onPress={handleResendOtp}
                            variant="outline"
                        />
                    )}
                </View>
            </View>
        </SafeAreaWrapper>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        padding: Dims.paddingL,
        paddingTop: Dims.spacingGiant,
    },
    header: {
        marginBottom: Dims.spacingXXL,
        alignItems: 'center',
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
    otpContainer: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        marginBottom: Dims.spacingXXL,
        paddingHorizontal: Dims.paddingM,
    },
    otpInputWrapper: {
        width: Dims.size48,
        height: Dims.size56,
        borderRadius: Dims.borderRadius,
        borderWidth: 2,
        borderColor: Colors.bNormal,
        backgroundColor: Colors.wWhite,
        alignItems: 'center',
        justifyContent: 'center',
    },
    otpInput: {
        fontSize: Dims.textSizeXXL,
        fontWeight: 'bold',
        color: Colors.dark,
        width: '100%',
        height: '100%',
        textAlign: 'center',
    },
    verifyButton: {
        marginBottom: Dims.spacingL,
    },
    resendContainer: {
        alignItems: 'center',
    },
    resendText: {
        fontSize: Dims.textSizeM,
        color: Colors.lighter,
    },
});
