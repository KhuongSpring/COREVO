import React, { useState } from 'react';
import { View, Text, StyleSheet, ScrollView, KeyboardAvoidingView, Platform, Alert } from 'react-native';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import SafeAreaWrapper from '@/components/common/SafeAreaWrapper';
import CustomInput from '@/components/auth/CustomInput';
import CustomButton from '@/components/auth/CustomButton';
import AuthBottomText from '@/components/auth/AuthBottomText';
import { useAuthStore } from '@/store/authStore';

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
            newErrors.username = 'Vui lòng nhập email hoặc tên đăng nhập';
        }

        if (!password) {
            newErrors.password = 'Vui lòng nhập mật khẩu';
        } else if (password.length < 6) {
            newErrors.password = 'Mật khẩu phải có ít nhất 6 ký tự';
        }

        setErrors(newErrors);
        return Object.keys(newErrors).length === 0;
    };

    // Handle login
    const handleLogin = async () => {
        if (!validateForm()) return;

        clearError();

        try {
            await login({ username: username.trim(), password });

            // Login successful, navigate to main app
            Alert.alert('Thành công', 'Đăng nhập thành công!', [
                {
                    text: 'OK',
                    onPress: () => router.replace('/welcome' as any),
                },
            ]);
        } catch (error: any) {
            // Error is already set in store
            Alert.alert('Lỗi đăng nhập', error.message || 'Đăng nhập thất bại. Vui lòng thử lại.');
        }
    };

    // Handle Google Sign-In
    const handleGoogleSignIn = () => {
        // TODO: Implement Google Sign-In
        Alert.alert('Thông báo', 'Google Sign-In sẽ được tích hợp sau');
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
                        <Text style={styles.title}>Đăng Nhập</Text>
                        <Text style={styles.subtitle}>Chào mừng trở lại!</Text>
                    </View>

                    {/* Login Form */}
                    <View style={styles.form}>
                        <CustomInput
                            label="Email hoặc Tên đăng nhập"
                            placeholder="Nhập email hoặc tên đăng nhập"
                            value={username}
                            onChangeText={(text) => {
                                setUsername(text);
                                if (errors.username) setErrors({ ...errors, username: undefined });
                            }}
                            keyboardType="email-address"
                            icon={<Ionicons name="person-outline" size={20} color={Colors.lighter} />}
                            error={errors.username}
                        />

                        <CustomInput
                            label="Mật khẩu"
                            placeholder="Nhập mật khẩu"
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
                            title="Quên mật khẩu?"
                            onPress={handleForgotPassword}
                            variant="outline"
                            style={styles.forgotButton}
                            textStyle={styles.forgotButtonText}
                        />

                        {/* Login Button */}
                        <CustomButton
                            title="Đăng nhập"
                            onPress={handleLogin}
                            loading={isLoading}
                            disabled={isLoading}
                            style={styles.loginButton}
                        />

                        {/* Divider */}
                        <View style={styles.divider}>
                            <View style={styles.dividerLine} />
                            <Text style={styles.dividerText}>hoặc</Text>
                            <View style={styles.dividerLine} />
                        </View>

                        {/* Google Sign-In Button */}
                        <CustomButton
                            title="Đăng nhập với Google"
                            onPress={handleGoogleSignIn}
                            variant="outline"
                            icon={<Ionicons name="logo-google" size={20} color={Colors.bNormal} />}
                        />
                    </View>

                    {/* Bottom Text */}
                    <AuthBottomText
                        normalText="Chưa có tài khoản?"
                        linkText="Đăng ký"
                        onPress={handleNavigateToRegister}
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
        paddingTop: Dims.spacingGiant,
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
        fontSize: Dims.textSizeL,
        color: Colors.lighter,
    },
    form: {
        marginBottom: Dims.spacingXL,
    },
    forgotButton: {
        alignSelf: 'flex-end',
        marginBottom: Dims.spacingL,
        paddingVertical: Dims.paddingS,
        minHeight: 0,
    },
    forgotButtonText: {
        fontSize: Dims.textSizeS,
    },
    loginButton: {
        marginBottom: Dims.spacingL,
    },
    divider: {
        flexDirection: 'row',
        alignItems: 'center',
        marginVertical: Dims.spacingL,
    },
    dividerLine: {
        flex: 1,
        height: 1,
        backgroundColor: Colors.wDark,
    },
    dividerText: {
        fontSize: Dims.textSizeS,
        color: Colors.lighter,
        marginHorizontal: Dims.spacingM,
    },
});
