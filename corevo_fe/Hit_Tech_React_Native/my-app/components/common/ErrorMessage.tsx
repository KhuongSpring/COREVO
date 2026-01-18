import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';

interface ErrorMessageProps {
    message: string;
    onRetry?: () => void;
    dismissible?: boolean;
    onDismiss?: () => void;
}

/**
 * Error Message Component
 * Displays error message with optional retry button
 */
export default function ErrorMessage({
    message,
    onRetry,
    dismissible = false,
    onDismiss,
}: ErrorMessageProps) {
    return (
        <View style={styles.container}>
            <Text style={styles.errorIcon}>⚠️</Text>
            <Text style={styles.message}>{message}</Text>

            <View style={styles.buttonContainer}>
                {onRetry && (
                    <TouchableOpacity style={styles.retryButton} onPress={onRetry}>
                        <Text style={styles.retryText}>Thử lại</Text>
                    </TouchableOpacity>
                )}

                {dismissible && onDismiss && (
                    <TouchableOpacity style={styles.dismissButton} onPress={onDismiss}>
                        <Text style={styles.dismissText}>Đóng</Text>
                    </TouchableOpacity>
                )}
            </View>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        backgroundColor: '#FEE2E2',
        borderRadius: Dims.borderRadius,
        padding: Dims.paddingM,
        margin: Dims.spacingM,
        alignItems: 'center',
    },
    errorIcon: {
        fontSize: Dims.textSizeXXL,
        marginBottom: Dims.spacingSM,
    },
    message: {
        fontSize: Dims.textSizeM,
        color: '#991B1B',
        textAlign: 'center',
        marginBottom: Dims.spacingM,
    },
    buttonContainer: {
        flexDirection: 'row',
        gap: Dims.spacingM,
    },
    retryButton: {
        backgroundColor: Colors.bNormal,
        paddingHorizontal: Dims.paddingL,
        paddingVertical: Dims.paddingS,
        borderRadius: Dims.borderRadiusSmall,
    },
    retryText: {
        color: Colors.wWhite,
        fontSize: Dims.textSizeS,
        fontWeight: '600',
    },
    dismissButton: {
        backgroundColor: Colors.lighter,
        paddingHorizontal: Dims.paddingL,
        paddingVertical: Dims.paddingS,
        borderRadius: Dims.borderRadiusSmall,
    },
    dismissText: {
        color: Colors.wWhite,
        fontSize: Dims.textSizeS,
        fontWeight: '600',
    },
});
