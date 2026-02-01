import React, { useState, useEffect, useRef } from 'react';
import { View, Text, StyleSheet, Alert, TextInput, TouchableOpacity, ImageBackground, ScrollView, KeyboardAvoidingView, Platform } from 'react-native';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { AppConfig } from '@/constants/AppConfig';
import SafeAreaWrapper from '@/components/common/SafeAreaWrapper';
import CustomButton from '@/components/auth/CustomButton';
import { AppMessages } from '@/constants/AppMessages';
import { AppStrings } from '@/constants/AppStrings';
import { AppAssets } from '@/constants/AppAssets';
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

    // 1. Thêm state lưu lỗi
    const [error, setError] = useState<string | null>(null);

    const inputRefs = useRef<(TextInput | null)[]>([]);

    useEffect(() => {
        startResendCountdown();
        setTimeout(() => inputRefs.current[0]?.focus(), 100);
    }, []);

    useEffect(() => {
        if (resendCountdown > 0) {
            const timer = setTimeout(() => setResendCountdown(resendCountdown - 1), 1000);
            return () => clearTimeout(timer);
        }
    }, [resendCountdown]);

    const startResendCountdown = () => {
        setResendCountdown(AppConfig.otpResendDelay);
    };

    const handleOtpChange = (index: number, value: string) => {
        // 2. Xóa lỗi khi người dùng bắt đầu nhập lại
        if (error) setError(null);

        if (value.length > 1) {
            value = value.charAt(value.length - 1);
        }

        const newOtp = [...otp];
        newOtp[index] = value;
        setOtp(newOtp);

        if (value && index < 5) {
            setTimeout(() => {
                inputRefs.current[index + 1]?.focus();
            }, 0);
        }
    };

    const handleKeyPress = (index: number, key: string) => {
        if (key === 'Backspace') {
            if (error) setError(null); // Xóa lỗi khi xóa ký tự

            setTimeout(() => {
                inputRefs.current[index - 1]?.focus();
            }, 0);
            const newOtp = [...otp];
            newOtp[index] = '';
            setOtp(newOtp);
        }
    };

    const handleVerifyOtp = async () => {
        const otpCode = otp.join('');

        if (otpCode.length !== AppConfig.otpLength) {
            // 3. Thay Alert bằng setError
            setError(AppMessages.auth.errOtpInvalid);
            return;
        }

        setIsLoading(true);
        setError(null); // Reset lỗi trước khi gọi API

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
                    // Check if data exists before accessing its properties
                    if (response.data && response.data.accessToken && response.data.refreshToken) {
                        setTokens(response.data.accessToken, response.data.refreshToken);
                    }

                    Alert.alert(AppStrings.success, AppMessages.auth.sucVerifyOtp, [
                        {
                            text: AppStrings.ok,
                            onPress: () => router.replace('/welcome' as any),
                        },
                    ]);
                } else {
                    router.push({
                        pathname: '/(auth)/reset-password',
                        params: { email, otp: otpCode },
                    } as any);
                }
            } else {
                // Hiển thị lỗi từ API lên màn hình
                setError(response.message || AppMessages.auth.errOtpInvalid);
            }
        } catch (error: any) {
            // Hiển thị lỗi network/server lên màn hình
            setError(error.response?.data?.message || AppMessages.auth.errOtpInvalid);
        } finally {
            setIsLoading(false);
        }
    };

    const handleResendOtp = async () => {
        if (resendCountdown > 0) return;
        setError(null); // Reset lỗi khi gửi lại

        try {
            if (type === 'reset-password') {
                await authService.sendEmailToForgotPassword({ email });
            } else if (type === 'recovery') {
                await authService.sendEmailToRecoveryAccount(email);
            }

            Alert.alert(AppStrings.success, AppMessages.auth.sucSendOtp);
            setOtp(['', '', '', '', '', '']);
            startResendCountdown();
            inputRefs.current[0]?.focus();
        } catch (error) {
            Alert.alert(AppStrings.error, AppMessages.auth.errSendOtpFailed);
        }
    };

    return (
        <ImageBackground
            source={AppAssets.authBackground}
            style={styles.backgroundImage}
            resizeMode="cover"
        >
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
                        <View style={styles.iconContainer}>
                            <Ionicons name="mail-outline" size={60} color={Colors.bNormal} />
                        </View>
                        <Text style={styles.title}>{AppStrings.otpVerification}</Text>
                        <Text style={styles.subtitle}>
                            {AppStrings.fillOtp}{'\n'}
                            <Text style={styles.email}>{email}</Text>
                        </Text>
                    </View>

                    {/* OTP Input */}
                    <View style={styles.otpSection}>
                        <View style={styles.otpContainer}>
                            {otp.map((digit, index) => (
                                <TouchableOpacity
                                    key={index}
                                    activeOpacity={1}
                                    onPress={() => inputRefs.current[index]?.focus()}
                                >
                                    <View style={[
                                        styles.otpInputWrapper,
                                        digit && styles.otpInputWrapperFilled,
                                        error && styles.otpInputWrapperError
                                    ]}>
                                        <TextInput
                                            ref={(ref) => (inputRefs.current[index] = ref)}
                                            style={styles.otpInput}
                                            value={digit}
                                            onChangeText={(value) => handleOtpChange(index, value)}
                                            onKeyPress={({ nativeEvent }) => handleKeyPress(index, nativeEvent.key)}
                                            keyboardType="number-pad"
                                            maxLength={1}
                                            textAlign="center"
                                            caretHidden={true}
                                            contextMenuHidden={true}
                                        />
                                    </View>
                                </TouchableOpacity>
                            ))}
                        </View>

                        {error && <Text style={styles.errorText}>{error}</Text>}
                    </View>

                    {/* Verify Button */}
                    <CustomButton
                        title={AppStrings.verify}
                        onPress={handleVerifyOtp}
                        loading={isLoading}
                        disabled={isLoading}
                        style={styles.verifyButton}
                    />

                    {/* Resend OTP */}
                    <View style={styles.resendContainer}>
                        {resendCountdown > 0 ? (
                            <Text style={styles.resendText}>
                                {AppStrings.resendOtpAfter} {resendCountdown}s
                            </Text>
                        ) : (
                            <CustomButton
                                title={AppStrings.resendOtp}
                                onPress={handleResendOtp}
                                variant="outline"
                                style={styles.resendButton}
                            />
                        )}
                    </View>
                </ScrollView>
            </KeyboardAvoidingView>
        </ImageBackground>
    );
}

const styles = StyleSheet.create({
    backgroundImage: {
        flex: 1,
        width: '100%',
        height: '100%',
    },
    container: {
        flex: 1,
    },
    scrollContent: {
        flexGrow: 1,
        padding: Dims.spacingL,
        paddingTop: Dims.size104,
    },
    header: {
        marginBottom: Dims.spacingXL,
        alignItems: 'center',
    },
    iconContainer: {
        width: Dims.size96,
        height: Dims.size96,
        borderRadius: Dims.size96 / 2,
        backgroundColor: Colors.bLight,
        alignItems: 'center',
        justifyContent: 'center',
        marginBottom: Dims.spacingXXXL,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.1,
        shadowRadius: 4,
        elevation: 3,
    },
    title: {
        fontSize: Dims.textSizeXXL,
        fontWeight: 'bold',
        color: Colors.dark,
        marginBottom: Dims.spacingML,
        textAlign: 'center',
    },
    subtitle: {
        fontSize: Dims.textSizeM,
        color: Colors.dark,
        textAlign: 'center',
        lineHeight: Dims.textSizeL,
    },
    email: {
        color: Colors.bNormal,
        fontWeight: '600',
    },
    // Wrap OTP container and error text together
    otpSection: {
        marginBottom: Dims.spacingXXL,
    },
    otpContainer: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        paddingHorizontal: Dims.paddingS,
        gap: Dims.spacingS,
    },
    otpInputWrapper: {
        width: Dims.size48,
        height: Dims.size48,
        borderRadius: Dims.borderRadius,
        borderWidth: 2,
        borderColor: Colors.lighter,
        backgroundColor: Colors.wWhite,
        alignItems: 'center',
        justifyContent: 'center',
    },
    otpInputWrapperFilled: {
        borderColor: Colors.bNormal,
        backgroundColor: Colors.bLight,
    },
    otpInputWrapperError: {
        borderColor: '#EF4444',
        backgroundColor: '#FEF2F2',
    },
    otpInput: {
        fontSize: Dims.textSizeXXL,
        fontWeight: 'bold',
        color: Colors.dark,
        width: '100%',
        height: '100%',
        padding: 0,
    },
    errorText: {
        fontSize: Dims.textSizeS,
        color: '#EF4444',
        textAlign: 'center',
        marginTop: Dims.spacingM,
        fontWeight: '500',
    },
    verifyButton: {
        backgroundColor: Colors.bNormal,
        borderRadius: Dims.borderRadiusLarge,
        marginBottom: Dims.spacingL,
    },
    resendContainer: {
        alignItems: 'center',
    },
    resendText: {
        fontSize: Dims.textSizeM,
        color: Colors.dark,
        textAlign: 'center',
    },
    resendButton: {
        borderColor: Colors.bNormal,
        borderRadius: Dims.borderRadiusLarge,
    },
});