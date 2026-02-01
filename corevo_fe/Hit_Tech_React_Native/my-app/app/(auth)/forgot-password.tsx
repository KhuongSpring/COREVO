import React, { useState } from 'react';
import { View, Text, StyleSheet, KeyboardAvoidingView, Platform, Alert, ImageBackground, ScrollView } from 'react-native';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import SafeAreaWrapper from '@/components/common/SafeAreaWrapper';
import CustomInput from '@/components/auth/CustomInput';
import CustomButton from '@/components/auth/CustomButton';
import { AppMessages } from '@/constants/AppMessages';
import { AppStrings } from '@/constants/AppStrings';
import { AppAssets } from '@/constants/AppAssets';
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
            setError(AppMessages.validation.errMailRequired);
            return;
        }

        if (!isValidEmail(email)) {
            setError(AppMessages.validation.errInvalidEmail);
            return;
        }

        setIsLoading(true);
        setError('');

        try {
            const response = await authService.sendEmailToForgotPassword({ email: email.trim() });

            if (response.status === 'SUCCESS') {
                Alert.alert(
                    AppStrings.success,
                    AppMessages.auth.sucSendOtp,
                    [
                        {
                            text: AppStrings.ok,
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
                Alert.alert(AppStrings.error, response.message || AppMessages.auth.errSendOtpFailed);
            }
        } catch (error: any) {
            Alert.alert(AppStrings.error, error.response?.data?.message || AppMessages.auth.errSendOtpFailed);
        } finally {
            setIsLoading(false);
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
                            <Ionicons name="key-outline" size={60} color={Colors.bNormal} />
                        </View>
                        <Text style={styles.title}>{AppStrings.forgotPassword}</Text>
                        <Text style={styles.subtitle}>
                            {AppStrings.fillEmailToResetPassword}
                        </Text>
                    </View>

                    {/* Email Input */}
                    <View style={styles.form}>
                        <CustomInput
                            placeholder={AppStrings.email}
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
                            title={AppStrings.sendOtp}
                            onPress={handleSendOtp}
                            loading={isLoading}
                            disabled={isLoading}
                            style={styles.sendButton}
                        />

                        {/* Back to Login */}
                        <CustomButton
                            title={AppStrings.backToLogin}
                            onPress={() => router.back()}
                            variant="outline"
                            style={styles.backButton}
                        />
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
        marginBottom: Dims.spacingM,
        textAlign: 'center',
    },
    subtitle: {
        fontSize: Dims.textSizeM,
        color: Colors.dark,
        textAlign: 'center',
        lineHeight: Dims.textSizeM * 1.5,
    },
    form: {
        marginBottom: Dims.spacingXL,
    },
    sendButton: {
        backgroundColor: Colors.bNormal,
        borderRadius: Dims.borderRadiusLarge,
        marginTop: Dims.spacingM,
        marginBottom: Dims.spacingM,
    },
    backButton: {
        borderColor: Colors.bNormal,
        borderRadius: Dims.borderRadiusLarge,
    },
});
