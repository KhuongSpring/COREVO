import React, { useState } from 'react';
import { View, Text, StyleSheet, KeyboardAvoidingView, Platform, Alert, ImageBackground, ScrollView } from 'react-native';
import { useRouter, useLocalSearchParams } from 'expo-router';
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
            newErrors.newPassword = AppMessages.validation.errPasswordRequired;
        } else if (newPassword.length < 6) {
            newErrors.newPassword = AppMessages.validation.errInvalidPasswordLength;
        }

        if (!confirmPassword) {
            newErrors.confirmPassword = AppMessages.validation.errPasswordRequired;
        } else if (newPassword !== confirmPassword) {
            newErrors.confirmPassword = AppMessages.validation.errPasswordMismatch;
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
                    AppStrings.success,
                    AppMessages.auth.sucResetPassword,
                    [
                        {
                            text: AppStrings.ok,
                            onPress: () => {
                                // Navigate to login
                                router.replace('/(auth)/login' as any);
                            },
                        },
                    ]
                );
            } else {
                Alert.alert(AppStrings.error, response.message || AppMessages.auth.errResetPasswordFail);
            }
        } catch (error: any) {
            Alert.alert(AppStrings.error, error.response?.data?.message || AppMessages.auth.errResetPasswordFail);
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
                            <Ionicons name="lock-closed-outline" size={60} color={Colors.bNormal} />
                        </View>
                        <Text style={styles.title}>{AppStrings.resetPassword}</Text>
                        <Text style={styles.subtitle}>
                            {AppStrings.resetYourPassword}{'\n'}
                            <Text style={styles.email}>{email}</Text>
                        </Text>
                    </View>

                    {/* Password Form */}
                    <View style={styles.form}>
                        <CustomInput
                            placeholder={AppStrings.newPassword}
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
                            placeholder={AppStrings.confirmPassword}
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
                            title={AppStrings.resetPassword}
                            onPress={handleResetPassword}
                            loading={isLoading}
                            disabled={isLoading}
                            style={styles.resetButton}
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
        marginBottom: Dims.spacingXL,
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
    form: {
        marginBottom: Dims.spacingXL,
    },
    resetButton: {
        backgroundColor: Colors.bNormal,
        borderRadius: Dims.borderRadiusLarge,
        marginTop: Dims.spacingM,
    },
});
