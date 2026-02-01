import React from 'react';
import { View, StyleSheet } from 'react-native';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';

interface PageIndicatorProps {
    count: number;
    activeIndex: number;
    activeColor?: string;
    inactiveColor?: string;
}

/**
 * Page Indicator Component
 * Shows dots for carousel/onboarding pages
 */
export default function PageIndicator({
    count,
    activeIndex,
    activeColor = Colors.bNormal,
    inactiveColor = Colors.wDark,
}: PageIndicatorProps) {
    return (
        <View style={styles.container}>
            {Array.from({ length: count }).map((_, index) => (
                <View
                    key={index}
                    style={[
                        styles.dot,
                        {
                            backgroundColor: index === activeIndex ? activeColor : inactiveColor,
                            width: index === activeIndex ? Dims.size24 : Dims.size8,
                        },
                    ]}
                />
            ))}
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        gap: Dims.spacingS,
    },
    dot: {
        height: Dims.size8,
        borderRadius: Dims.size4,
    },
});
