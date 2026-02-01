import React from 'react';
import { TouchableOpacity, Text, StyleSheet, ViewStyle, TextStyle, ActivityIndicator } from 'react-native';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';

interface CustomButtonProps {
    title: string;
    onPress: () => void;
    variant?: 'primary' | 'secondary' | 'outline';
    disabled?: boolean;
    loading?: boolean;
    icon?: React.ReactNode;
    style?: ViewStyle;
    textStyle?: TextStyle;
}

/**
 * Custom Button Component
 * Reusable button with multiple variants
 */
export default function CustomButton({
    title,
    onPress,
    variant = 'primary',
    disabled = false,
    loading = false,
    icon,
    style,
    textStyle,
}: CustomButtonProps) {
    const getButtonStyle = () => {
        if (disabled) return styles.buttonDisabled;

        switch (variant) {
            case 'primary':
                return styles.buttonPrimary;
            case 'secondary':
                return styles.buttonSecondary;
            case 'outline':
                return styles.buttonOutline;
            default:
                return styles.buttonPrimary;
        }
    };

    const getTextStyle = () => {
        if (disabled) return styles.textDisabled;

        switch (variant) {
            case 'primary':
                return styles.textPrimary;
            case 'secondary':
                return styles.textSecondary;
            case 'outline':
                return styles.textOutline;
            default:
                return styles.textPrimary;
        }
    };

    return (
        <TouchableOpacity
            style={[styles.button, getButtonStyle(), style]}
            onPress={onPress}
            disabled={disabled || loading}
            activeOpacity={0.7}
        >
            {loading ? (
                <ActivityIndicator
                    color={variant === 'primary' ? Colors.wWhite : Colors.bNormal}
                    size="small"
                />
            ) : (
                <>
                    {icon && <>{icon}</>}
                    <Text style={[styles.text, getTextStyle(), textStyle]}>{title}</Text>
                </>
            )}
        </TouchableOpacity>
    );
}

const styles = StyleSheet.create({
    button: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        paddingVertical: Dims.paddingM,
        paddingHorizontal: Dims.paddingL,
        borderRadius: Dims.borderRadiusLarge,
        minHeight: Dims.heightButton,
        gap: Dims.spacingS,
    },
    buttonPrimary: {
        backgroundColor: Colors.bNormal,
    },
    buttonSecondary: {
        backgroundColor: Colors.wDark,
    },
    buttonOutline: {
        backgroundColor: 'transparent',
        borderWidth: 1.5,
        borderColor: Colors.bNormal,
    },
    buttonDisabled: {
        backgroundColor: Colors.wDark,
        opacity: 0.5,
    },
    text: {
        fontSize: Dims.textSizeM,
        fontWeight: '600',
    },
    textPrimary: {
        color: Colors.wWhite,
    },
    textSecondary: {
        color: Colors.dark,
    },
    textOutline: {
        color: Colors.bNormal,
    },
    textDisabled: {
        color: Colors.lighter,
    },
});
