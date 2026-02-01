import React, { useState } from 'react';
import { View, TextInput, Text, StyleSheet, TouchableOpacity, KeyboardTypeOptions } from 'react-native';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { Ionicons } from '@expo/vector-icons';

interface CustomInputProps {
    label?: string;
    placeholder: string;
    value: string;
    onChangeText: (text: string) => void;
    secureTextEntry?: boolean;
    keyboardType?: KeyboardTypeOptions;
    error?: string;
    icon?: React.ReactNode;
    maxLength?: number;
    editable?: boolean;
    multiline?: boolean;
}

/**
 * Custom Input Component
 * Reusable input field with validation and icons
 */
export default function CustomInput({
    label,
    placeholder,
    value,
    onChangeText,
    secureTextEntry = false,
    keyboardType = 'default',
    error,
    icon,
    maxLength,
    editable = true,
    multiline = false,
}: CustomInputProps) {
    const [isPasswordVisible, setIsPasswordVisible] = useState(false);
    const [isFocused, setIsFocused] = useState(false);

    const togglePasswordVisibility = () => {
        setIsPasswordVisible(!isPasswordVisible);
    };

    return (
        <View style={styles.container}>
            {label && <Text style={styles.label}>{label}</Text>}

            <View style={[
                styles.inputContainer,
                isFocused && styles.inputContainerFocused,
                error && styles.inputContainerError,
                !editable && styles.inputContainerDisabled,
            ]}>
                {icon && <View style={styles.iconLeft}>{icon}</View>}

                <TextInput
                    style={[styles.input, icon ? styles.inputWithIcon : undefined]}
                    placeholder={placeholder}
                    placeholderTextColor={Colors.lighter}
                    value={value}
                    onChangeText={onChangeText}
                    secureTextEntry={secureTextEntry && !isPasswordVisible}
                    keyboardType={keyboardType}
                    maxLength={maxLength}
                    editable={editable}
                    multiline={multiline}
                    onFocus={() => setIsFocused(true)}
                    onBlur={() => setIsFocused(false)}
                />

                {secureTextEntry && (
                    <TouchableOpacity
                        style={styles.iconRight}
                        onPress={togglePasswordVisibility}
                    >
                        <Ionicons
                            name={isPasswordVisible ? 'eye-off-outline' : 'eye-outline'}
                            size={Dims.iconSizeL}
                            color={Colors.lighter}
                        />
                    </TouchableOpacity>
                )}
            </View>

            {error && (
                <Text style={styles.errorText}>{error}</Text>
            )}
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        marginBottom: Dims.spacingM,
    },
    label: {
        fontSize: Dims.textSizeS,
        fontWeight: '600',
        color: Colors.dark,
        marginBottom: Dims.spacingS,
    },
    inputContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        backgroundColor: Colors.wNormal,
        borderRadius: Dims.borderRadius,
        borderWidth: 1.5,
        borderColor: Colors.wDark,
        paddingHorizontal: Dims.paddingM,
    },
    inputContainerFocused: {
        borderColor: Colors.bNormal,
        backgroundColor: Colors.wWhite,
    },
    inputContainerError: {
        borderColor: '#EF4444',
    },
    inputContainerDisabled: {
        backgroundColor: Colors.wDark,
        opacity: 0.6,
    },
    input: {
        flex: 1,
        paddingVertical: Dims.paddingM,
        fontSize: Dims.textSizeM,
        color: Colors.dark,
    },
    inputWithIcon: {
        paddingLeft: Dims.spacingS,
    },
    iconLeft: {
        marginRight: Dims.spacingS,
    },
    iconRight: {
        marginLeft: Dims.spacingS,
        padding: Dims.paddingXS,
    },
    errorText: {
        fontSize: Dims.textSizeXS,
        color: '#EF4444',
        marginTop: Dims.spacingS,
        marginLeft: Dims.paddingXS,
    },
});
