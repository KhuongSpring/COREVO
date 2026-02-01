import React from 'react';
import { View, StyleSheet, ViewStyle } from 'react-native';
import { SafeAreaView, Edge } from 'react-native-safe-area-context';

interface SafeAreaWrapperProps {
    children: React.ReactNode;
    backgroundColor?: string;
    edges?: Edge[];
    style?: ViewStyle;
}

/**
 * Safe Area Wrapper Component
 * Wraps content with safe area insets
 */
export default function SafeAreaWrapper({
    children,
    backgroundColor = '#FFFFFF',
    edges = ['top', 'bottom', 'left', 'right'],
    style,
}: SafeAreaWrapperProps) {
    return (
        <SafeAreaView
            style={[styles.container, { backgroundColor }, style]}
            edges={edges}
        >
            {children}
        </SafeAreaView>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
});
