import React, { useState } from 'react';
import { View, Text, StyleSheet, ScrollView, KeyboardAvoidingView, Platform, Alert, ImageBackground, TouchableOpacity, Image } from 'react-native';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import SafeAreaWrapper from '@/components/common/SafeAreaWrapper';
import CustomInput from '@/components/auth/CustomInput';
import CustomButton from '@/components/auth/CustomButton';
import AuthBottomText from '@/components/auth/AuthBottomText';
import { AppMessages } from '@/constants/AppMessages';
import { AppStrings } from '@/constants/AppStrings';
import { AppAssets } from '@/constants/AppAssets';
import * as authService from '@/services/authService';

/**
 * Register Screen
 * User registration with full form validation
 */
export default function RegisterScreen() {
    const router = useRouter();

    const [formData, setFormData] = useState({
        firstName: '',
        lastName: '',
        username: '',
        email: '',
        password: '',
    });

    const [agreedToTerms, setAgreedToTerms] = useState(false);
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

        if (!formData.firstName.trim()) {
            newErrors.firstName = AppMessages.validation.errFirstNameRequired;
        }

        if (!formData.lastName.trim()) {
            newErrors.lastName = AppMessages.validation.errLastNameRequired;
        }

        if (!formData.username.trim()) {
            newErrors.username = AppMessages.validation.errUsernameOrEmailRequired;
        } else if (formData.username.length < 3) {
            newErrors.username = AppMessages.validation.errUsernameTooShort;
        }

        if (!formData.email.trim()) {
            newErrors.email = AppMessages.validation.errInvalidEmail;
        } else if (!isValidEmail(formData.email)) {
            newErrors.email = AppMessages.validation.errInvalidEmail;
        }

        if (!formData.password) {
            newErrors.password = AppMessages.validation.errPasswordRequired;
        } else if (formData.password.length < 6) {
            newErrors.password = AppMessages.validation.errInvalidPasswordLength;
        }

        if (!agreedToTerms) {
            newErrors.terms = AppMessages.validation.errPolicyRequired;
        }

        setErrors(newErrors);
        return Object.keys(newErrors).length === 0;
    };

    // Handle register
    const handleRegister = async () => {
        if (!validateForm()) return;

        setIsLoading(true);

        try {
            const fullName = `${formData.firstName.trim()} ${formData.lastName.trim()}`;
            const response = await authService.register({
                username: formData.username.trim(),
                email: formData.email.trim(),
                password: formData.password,
                confirmPassword: formData.password, // Same as password
                fullName: fullName,
                phoneNumber: '', // Empty for now
                countryCode: '+84',
            });

            if (response.status === 'SUCCESS') {
                Alert.alert(
                    AppStrings.success,
                    AppMessages.auth.sucSendOtp,
                    [
                        {
                            text: AppStrings.ok,
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
                Alert.alert(AppStrings.error, response.message || AppMessages.auth.errRegisterFail);
            }
        } catch (error: any) {
            Alert.alert(AppStrings.error, error.response?.data?.message || AppMessages.auth.errRegisterFail);
        } finally {
            setIsLoading(false);
        }
    };

    // Handle Google Sign-In
    const handleGoogleSignIn = () => {
        Alert.alert(AppStrings.notification, 'Google Sign-In sẽ được tích hợp sau');
    };

    // Handle Facebook Sign-In
    const handleFacebookSignIn = () => {
        Alert.alert(AppStrings.notification, 'Facebook Sign-In sẽ được tích hợp sau');
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
                    <View style={styles.headerContainer}>
                        <Text style={styles.title}>{AppStrings.register}</Text>
                    </View>

                    {/* Registration Form */}
                    <View style={styles.form}>
                        {/* Email Input */}
                        <CustomInput
                            placeholder={AppStrings.email}
                            value={formData.email}
                            onChangeText={(text) => updateField('email', text)}
                            keyboardType="email-address"
                            error={errors.email}
                        />

                        {/* Username Input */}
                        <CustomInput
                            placeholder={AppStrings.username}
                            value={formData.username}
                            onChangeText={(text) => updateField('username', text)}
                            error={errors.username}
                        />

                        {/* First Name & Last Name in Row */}
                        <View style={styles.nameRow}>
                            <View style={styles.nameField}>
                                <CustomInput
                                    placeholder={AppStrings.firstName}
                                    value={formData.firstName}
                                    onChangeText={(text) => updateField('firstName', text)}
                                    error={errors.firstName}
                                />
                            </View>
                            <View style={styles.nameField}>
                                <CustomInput
                                    placeholder={AppStrings.lastName}
                                    value={formData.lastName}
                                    onChangeText={(text) => updateField('lastName', text)}
                                    error={errors.lastName}
                                />
                            </View>
                        </View>

                        {/* Password Input */}
                        <CustomInput
                            placeholder={AppStrings.password}
                            value={formData.password}
                            onChangeText={(text) => updateField('password', text)}
                            secureTextEntry
                            error={errors.password}
                        />

                        {/* Terms Checkbox */}
                        <TouchableOpacity
                            style={styles.checkboxContainer}
                            onPress={() => setAgreedToTerms(!agreedToTerms)}
                            activeOpacity={0.7}
                        >
                            <View style={[styles.checkbox, agreedToTerms && styles.checkboxChecked]}>
                                {agreedToTerms && (
                                    <Ionicons name="checkmark" size={16} color={Colors.bNormal} />
                                )}
                            </View>
                            <Text style={styles.checkboxText}>
                                {AppStrings.agreeTerms}
                            </Text>
                        </TouchableOpacity>
                        {errors.terms && <Text style={styles.errorText}>{errors.terms}</Text>}

                        {/* Register Button */}
                        <CustomButton
                            title={AppStrings.register}
                            onPress={handleRegister}
                            loading={isLoading}
                            disabled={isLoading}
                            style={styles.registerButton}
                        />

                        {/* Divider */}
                        <View style={styles.divider}>
                            <View style={styles.dividerLine} />
                            <Text style={styles.dividerText}>{AppStrings.orRegisterWith}</Text>
                            <View style={styles.dividerLine} />
                        </View>

                        {/* Social Login Buttons */}
                        <View style={styles.socialButtonsRow}>
                            <CustomButton
                                title="Google"
                                onPress={handleGoogleSignIn}
                                variant="outline"
                                icon={<Image source={AppAssets.googleIcon} style={styles.socialButtonIcon} />}
                                style={styles.socialButton}
                            />

                            <CustomButton
                                title="Facebook"
                                onPress={handleFacebookSignIn}
                                variant="outline"
                                icon={<Image source={AppAssets.facebookIcon} style={styles.socialButtonIcon} />}
                                style={styles.socialButton}
                            />
                        </View>
                    </View>

                    {/* Bottom Text */}
                    <View style={styles.bottomTextContainer}>
                        <Text style={styles.bottomText}>{AppStrings.alreadyHaveAccount} </Text>
                        <TouchableOpacity onPress={() => router.back()}>
                            <Text style={styles.bottomTextLink}>{AppStrings.login}</Text>
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
    headerContainer: {
        alignItems: 'center',
        marginBottom: Dims.spacingXXXL,
    },
    title: {
        fontSize: Dims.textSizeXXL,
        fontWeight: 'bold',
        color: Colors.dark,
        textAlign: 'center',
    },
    form: {
        marginBottom: Dims.spacingL,
    },
    nameRow: {
        flexDirection: 'row',
        gap: Dims.spacingM,
    },
    nameField: {
        flex: 1,
    },
    checkboxContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        marginBottom: Dims.spacingM,
        marginTop: Dims.spacingS,
    },
    checkbox: {
        width: 20,
        height: 20,
        borderRadius: 4,
        borderWidth: 2,
        borderColor: Colors.bNormal,
        marginRight: Dims.spacingS,
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: Colors.wWhite,
    },
    checkboxChecked: {
        backgroundColor: Colors.wWhite,
    },
    checkboxText: {
        fontSize: Dims.textSizeS,
        color: Colors.dark,
        flex: 1,
    },
    errorText: {
        fontSize: Dims.textSizeXS,
        color: '#EF4444',
        marginTop: -Dims.spacingS,
        marginBottom: Dims.spacingS,
        marginLeft: Dims.paddingXS,
    },
    registerButton: {
        backgroundColor: Colors.bNormal,
        borderRadius: Dims.borderRadiusLarge,
        marginTop: Dims.spacingM,
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
        backgroundColor: Colors.bNormal,
    },
    dividerText: {
        fontSize: Dims.textSizeS,
        color: Colors.bNormal,
        marginHorizontal: Dims.spacingSM,
        fontWeight: '500',
    },
    socialButtonsRow: {
        flexDirection: 'row',
        gap: Dims.spacingM,
        marginBottom: Dims.spacingL,
    },
    socialButton: {
        flex: 1,
        backgroundColor: Colors.wWhite,
        borderRadius: Dims.borderRadiusLarge,
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
    },
    bottomTextLink: {
        fontSize: Dims.textSizeS,
        color: Colors.bNormal,
        fontWeight: '600',
    },
});
