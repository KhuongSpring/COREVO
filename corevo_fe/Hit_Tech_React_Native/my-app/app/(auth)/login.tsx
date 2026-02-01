import React, { useState } from 'react';
import { View, Text, StyleSheet, ScrollView, KeyboardAvoidingView, Platform, Alert, ImageBackground, TouchableOpacity, Image } from 'react-native';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import CustomInput from '@/components/auth/CustomInput';
import CustomButton from '@/components/auth/CustomButton';
import { useAuthStore } from '@/store/authStore';
import { AppMessages } from '@/constants/AppMessages';
import { AppStrings } from '@/constants/AppStrings';
import { AppAssets } from '@/constants/AppAssets';
import { userService } from '@/services/api/userService';
import { authService } from '@/services/authService';

/**
 * Login Screen
 * User login with email/username and password
 */
export default function LoginScreen() {
    const router = useRouter();
    const { login, isLoading, error, clearError } = useAuthStore();

    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');
    const [errors, setErrors] = useState<{ username?: string; password?: string }>({});

    // Validate form
    const validateForm = (): boolean => {
        const newErrors: { username?: string; password?: string } = {};

        if (!username.trim()) {
            newErrors.username = AppMessages.validation.errUsernameOrEmailRequired;
        }

        if (!password) {
            newErrors.password = AppMessages.validation.errPasswordRequired;
        } else if (password.length < 6) {
            newErrors.password = AppMessages.validation.errInvalidPasswordLength;
        }

        setErrors(newErrors);
        return Object.keys(newErrors).length === 0;
    };

    // Handle login
    const handleLogin = async () => {
        if (!validateForm()) return;

        clearError();

        try {
            const loginCredentials = { username: username.trim(), password };
            const data = await login(loginCredentials);

            if (data) {
                // Check if account is deleted
                if (data.isDeleted) {
                    if (data.canRecovery) {
                        Alert.alert(
                            AppStrings.notification,
                            `Tài khoản của bạn đang trong trạng thái chờ xóa. Bạn còn ${data.dayRecoveryRemaining} ngày để khôi phục.`,
                            [
                                { text: AppStrings.cancel, style: 'cancel' },
                                {
                                    text: AppStrings.recovery,
                                    onPress: () => router.push({
                                        pathname: '/(auth)/otp-verification',
                                        params: { email: username.trim(), type: 'recovery' }
                                    } as any)
                                }
                            ]
                        );
                    } else {
                        Alert.alert(AppStrings.error, AppStrings.accountDeletedForever);
                    }
                    return;
                }

                // Fetch profile to decide where to go
                try {
                    const profileRes = await userService.getProfile();
                    const profile = profileRes.data;

                    if (!profile.userHealth) {
                        router.replace('/welcome' as any);
                    } else if (!profile.trainingPlans || profile.trainingPlans.length === 0) {
                        router.replace('/welcome-2' as any);
                    } else {
                        router.replace('/(tabs)' as any);
                    }
                } catch (err: any) {
                    // If profile fetch fails, fallback to welcome
                    console.error('Profile fetch error:', err);
                    router.replace('/welcome' as any);
                }
            }
        } catch (err: any) {
            const errorMessage = err.response?.data?.message || err.message || AppMessages.auth.errLoginFail;
            Alert.alert(AppStrings.error, errorMessage);
        }
    };

    // Handle Google Sign-In
    const handleGoogleSignIn = () => {
        // TODO: Implement Google Sign-In
        Alert.alert(AppStrings.notification, 'Google Sign-In sẽ được tích hợp sau');
    };

    // Handle Facebook Sign-In
    const handleFacebookSignIn = () => {
        // TODO: Implement Facebook Sign-In
        Alert.alert(AppStrings.notification, 'Facebook Sign-In sẽ được tích hợp sau');
    };

    // Navigate to register
    const handleNavigateToRegister = () => {
        router.push('/(auth)/register' as any);
    };

    // Navigate to forgot password
    const handleForgotPassword = () => {
        router.push('/(auth)/forgot-password' as any);
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
                        <Text style={styles.title}>{AppStrings.login}</Text>
                    </View>

                    {/* Login Form */}
                    <View style={styles.form}>
                        {/* Username Input */}
                        <CustomInput
                            placeholder={AppStrings.username}
                            value={username}
                            onChangeText={(text) => {
                                setUsername(text);
                                if (errors.username) setErrors({ ...errors, username: undefined });
                            }}
                            keyboardType="email-address"
                            icon={<Ionicons name="person-outline" size={20} color={Colors.lighter} />}
                            error={errors.username}
                        />

                        {/* Password Input */}
                        <CustomInput
                            placeholder={AppStrings.password}
                            value={password}
                            onChangeText={(text) => {
                                setPassword(text);
                                if (errors.password) setErrors({ ...errors, password: undefined });
                            }}
                            secureTextEntry
                            icon={<Ionicons name="lock-closed-outline" size={20} color={Colors.lighter} />}
                            error={errors.password}
                        />

                        {/* Forgot Password Link */}
                        <CustomButton
                            title={AppStrings.forgotPassword}
                            onPress={handleForgotPassword}
                            variant="outline"
                            style={styles.forgotButton}
                            textStyle={styles.forgotButtonText}
                        />

                        {/* Login Button */}
                        <CustomButton
                            title={AppStrings.login}
                            onPress={handleLogin}
                            loading={isLoading}
                            disabled={isLoading}
                            style={styles.loginButton}
                        />

                        {/* Divider */}
                        <View style={styles.divider}>
                            <View style={styles.dividerLine} />
                            <Text style={styles.dividerText}>{AppStrings.orLoginWith}</Text>
                            <View style={styles.dividerLine} />
                        </View>

                        {/* Google Sign-In Button */}
                        <CustomButton
                            title={AppStrings.googleSignIn}
                            onPress={handleGoogleSignIn}
                            variant="outline"
                            icon={<Image source={AppAssets.googleIcon} style={styles.socialButtonIcon} />}
                            style={styles.socialButton}
                        />

                        {/* Facebook Sign-In Button */}
                        <CustomButton
                            title={AppStrings.facebookSignIn}
                            onPress={handleFacebookSignIn}
                            variant="outline"
                            icon={<Image source={AppAssets.facebookIcon} style={styles.socialButtonIcon} />}
                            style={styles.socialButton}
                        />
                    </View>

                    {/* Bottom Text */}
                    <View style={styles.bottomTextContainer}>
                        <Text style={styles.bottomText}>{AppStrings.alreadyHaveAccount}</Text>
                        <TouchableOpacity onPress={handleNavigateToRegister}>
                            <Text style={styles.bottomTextLink}>{AppStrings.register}</Text>
                        </TouchableOpacity>
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
        paddingTop: Dims.spacingXL,
        justifyContent: 'center',
    },
    header: {
        alignItems: 'center',
        marginBottom: Dims.spacingGiant,
    },
    title: {
        fontSize: Dims.textSizeXXL,
        fontWeight: 'bold',
        color: Colors.dark,
        textAlign: 'center',
    },
    form: {
        marginBottom: 30,
    },
    forgotButton: {
        alignSelf: 'flex-end',
        marginBottom: Dims.spacingL,
        paddingVertical: 4,
        minHeight: 0,
        borderWidth: 0,
    },
    forgotButtonText: {
        fontSize: Dims.textSizeS,
        color: Colors.bNormal,
        fontWeight: '500',
    },
    loginButton: {
        backgroundColor: Colors.bNormal,
        borderRadius: Dims.borderRadiusLarge,
        marginBottom: Dims.spacingL,
    },
    divider: {
        flexDirection: 'row',
        alignItems: 'center',
        marginVertical: 24,
    },
    dividerLine: {
        flex: 1,
        height: 1,
        backgroundColor: Colors.bNormal,
    },
    dividerText: {
        fontSize: Dims.textSizeS,
        color: Colors.bNormal,
        marginHorizontal: Dims.spacingSM,
        fontWeight: '500',
    },
    socialButton: {
        backgroundColor: Colors.wWhite,
        borderRadius: Dims.borderRadiusLarge,
        marginBottom: Dims.spacingM,
        borderColor: '#E0E0E0',
    },
    socialButtonIcon: {
        width: Dims.size28,
        height: Dims.size28,
    },
    bottomTextContainer: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        marginTop: Dims.spacingM,
    },
    bottomText: {
        fontSize: Dims.textSizeS,
        color: Colors.lighter,
        marginRight: Dims.spacingXS
    },
    bottomTextLink: {
        fontSize: Dims.textSizeS,
        color: Colors.bNormal,
        fontWeight: '600',
    },
});
