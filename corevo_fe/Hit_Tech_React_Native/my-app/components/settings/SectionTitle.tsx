import React from 'react';
import { Text, StyleSheet } from 'react-native';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';

interface SectionTitleProps {
    title: string;
}

/**
 * Section Title Component
 * Displays a section header in settings screens
 */
export default function SectionTitle({ title }: SectionTitleProps) {
    return <Text style={styles.title}>{title}</Text>;
}

const styles = StyleSheet.create({
    title: {
        fontWeight: 'bold',
        color: Colors.bDarkHover,
        fontSize: Dims.textSizeS,
        paddingVertical: Dims.paddingS,
    },
});
