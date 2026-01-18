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
import * as authService from '@/services/authService';

/**
 * Register Screen
 * User registration with full form validation
 */
export default function RegisterScreen() {
    const router = useRouter();

    const [formData, setFormData] = useState({
        fullName: '',
        username: '',
        email: '',
        phoneNumber: '',
        countryCode: '+84',
        password: '',
        confirmPassword: '',
    });

    const [errors, setErrors] = useState<{ [key: string]: string }>({});
    const [isLoading, setIsLoading] = useState(false);

    // Update form field
    const updateField = (field: string, value: string) => {
        setFormData({ ...formData, [field]: value });
        if (errors[field]) {
            setErrors({ ...errors, [field]: '' });
        }
    };

    // Validate email
    const isValidEmail = (email: string): boolean => {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    };

    // Validate form
    const validateForm = (): boolean => {
        const newErrors: { [key: string]: string } = {};

        if (!formData.fullName.trim()) {
            newErrors.fullName = 'Vui lòng nhập họ và tên';
        }

        if (!formData.username.trim()) {
            newErrors.username = 'Vui lòng nhập tên đăng nhập';
        } else if (formData.username.length < 3) {
            newErrors.username = 'Tên đăng nhập phải có ít nhất 3 ký tự';
        }

        if (!formData.email.trim()) {
            newErrors.email = 'Vui lòng nhập email';
        } else if (!isValidEmail(formData.email)) {
            newErrors.email = 'Email không hợp lệ';
        }

        if (!formData.password) {
            newErrors.password = 'Vui lòng nhập mật khẩu';
        } else if (formData.password.length < 6) {
            newErrors.password = 'Mật khẩu phải có ít nhất 6 ký tự';
        }

        if (!formData.confirmPassword) {
            newErrors.confirmPassword = 'Vui lòng xác nhận mật khẩu';
        } else if (formData.password !== formData.confirmPassword) {
            newErrors.confirmPassword = 'Mật khẩu không khớp';
        }

        setErrors(newErrors);
        return Object.keys(newErrors).length === 0;
    };

    // Handle register
    const handleRegister = async () => {
        if (!validateForm()) return;

        setIsLoading(true);

        try {
            const response = await authService.register({
                username: formData.username.trim(),
                email: formData.email.trim(),
                password: formData.password,
                confirmPassword: formData.confirmPassword,
                fullName: formData.fullName.trim(),
                phoneNumber: formData.phoneNumber.trim(),
                countryCode: formData.countryCode,
            });

            if (response.status === 'SUCCESS') {
                Alert.alert(
                    'Đăng ký thành công!',
                    'Vui lòng kiểm tra email để xác thực tài khoản.',
                    [
                        {
                            text: 'OK',
                            onPress: () => {
                                // Navigate to OTP verification
                                router.push({
                                    pathname: '/(auth)/otp-verification',
                                    params: { email: formData.email, type: 'register' },
                                } as any);
                            },
                        },
                    ]
                );
            } else {
                Alert.alert('Lỗi', response.message || 'Đăng ký thất bại');
            }
        } catch (error: any) {
            Alert.alert('Lỗi', error.response?.data?.message || 'Đăng ký thất bại. Vui lòng thử lại.');
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
                        <Text style={styles.title}>Đăng Ký</Text>
                        <Text style={styles.subtitle}>Tạo tài khoản mới</Text>
                    </View>

                    {/* Registration Form */}
                    <View style={styles.form}>
                        <CustomInput
                            label="Họ và tên"
                            placeholder="Nhập họ và tên"
                            value={formData.fullName}
                            onChangeText={(text) => updateField('fullName', text)}
                            icon={<Ionicons name="person-outline" size={20} color={Colors.lighter} />}
                            error={errors.fullName}
                        />

                        <CustomInput
                            label="Tên đăng nhập"
                            placeholder="Nhập tên đăng nhập"
                            value={formData.username}
                            onChangeText={(text) => updateField('username', text)}
                            icon={<Ionicons name="at-outline" size={20} color={Colors.lighter} />}
                            error={errors.username}
                        />

                        <CustomInput
                            label="Email"
                            placeholder="Nhập email"
                            value={formData.email}
                            onChangeText={(text) => updateField('email', text)}
                            keyboardType="email-address"
                            icon={<Ionicons name="mail-outline" size={20} color={Colors.lighter} />}
                            error={errors.email}
                        />

                        <CustomInput
                            label="Số điện thoại (tùy chọn)"
                            placeholder="Nhập số điện thoại"
                            value={formData.phoneNumber}
                            onChangeText={(text) => updateField('phoneNumber', text)}
                            keyboardType="phone-pad"
                            icon={<Ionicons name="call-outline" size={20} color={Colors.lighter} />}
                        />

                        <CustomInput
                            label="Mật khẩu"
                            placeholder="Nhập mật khẩu"
                            value={formData.password}
                            onChangeText={(text) => updateField('password', text)}
                            secureTextEntry
                            icon={<Ionicons name="lock-closed-outline" size={20} color={Colors.lighter} />}
                            error={errors.password}
                        />

                        <CustomInput
                            label="Xác nhận mật khẩu"
                            placeholder="Nhập lại mật khẩu"
                            value={formData.confirmPassword}
                            onChangeText={(text) => updateField('confirmPassword', text)}
                            secureTextEntry
                            icon={<Ionicons name="lock-closed-outline" size={20} color={Colors.lighter} />}
                            error={errors.confirmPassword}
                        />

                        {/* Register Button */}
                        <CustomButton
                            title="Đăng ký"
                            onPress={handleRegister}
                            loading={isLoading}
                            disabled={isLoading}
                            style={styles.registerButton}
                        />
                    </View>

                    {/* Bottom Text */}
                    <AuthBottomText
                        normalText="Đã có tài khoản?"
                        linkText="Đăng nhập"
                        onPress={() => router.back()}
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
        fontSize: Dims.textSizeL,
        color: Colors.lighter,
    },
    form: {
        marginBottom: Dims.spacingXL,
    },
    registerButton: {
        marginTop: Dims.spacingM,
    },
});
