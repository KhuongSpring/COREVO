import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';

interface CategoryPillProps {
    label: string;
}

/**
 * Category Pill Component
 * Small pill badge for displaying categories like type, level, location, equipment
 */
export default function CategoryPill({ label }: CategoryPillProps) {
    return (
        <View style={styles.container}>
            <Text style={styles.text}>{label}</Text>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        paddingHorizontal: Dims.paddingS,
        paddingVertical: Dims.paddingS,
        backgroundColor: Colors.bgHealthInfor,
        borderRadius: Dims.borderRadiusSmall,
    },
    text: {
        fontSize: Dims.textSizeXS,
        fontWeight: '500',
        color: Colors.dark,
    },
});
