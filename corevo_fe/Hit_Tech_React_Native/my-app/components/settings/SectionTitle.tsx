import React from 'react';
import { Text, StyleSheet } from 'react-native';
import { Dims } from '@/constants/Dimensions';
import { useTheme } from '@/hooks/useTheme';

interface SectionTitleProps {
    title: string;
}

/**
 * Section Title Component
 * Displays a section header in settings screens
 */
export default function SectionTitle({ title }: SectionTitleProps) {
    const { colors } = useTheme();
    return <Text style={[styles.title,
    { color: colors.interactive.active, }
    ]}>{title}</Text>;
}

const styles = StyleSheet.create({
    title: {
        fontWeight: 'bold',
        fontSize: Dims.textSizeS,
        paddingVertical: Dims.paddingS,
    },
});
