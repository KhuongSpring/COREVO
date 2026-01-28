import React from 'react';
import { View, TouchableOpacity, StyleSheet, Animated } from 'react-native';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';

// ====================================================================
// COMPONENT PROPS
// ====================================================================

interface WeeklyTimelineProps {
    selectedIndex: number;
    onChanged: (index: number) => void;
}

// ====================================================================
// MAIN COMPONENT
// ====================================================================

/**
 * Weekly Timeline Component
 * Vertical dot timeline for training schedule
 * Matches Flutter weekly_time_line.dart design exactly
 */
export default function WeeklyTimeline({ selectedIndex, onChanged }: WeeklyTimelineProps) {
    // Generate 7 dots with a line ABOVE each dot (total 7 * 2 = 14 elements)
    // Starting with a line allows the first dot to move down and center itself
    const elements = Array.from({ length: 7 * 2 - 1 }, (_, index) => {
        if (index % 2 === 0) {
            // Odd index = Dot (1, 3, 5, 7, 9, 11, 13)
            const dotIndex = Math.floor(index / 2);
            const isSelected = dotIndex === selectedIndex;

            return (
                <TouchableOpacity
                    key={`dot-${dotIndex}`}
                    onPress={() => onChanged(dotIndex)}
                    activeOpacity={0.7}
                >
                    <Animated.View
                        style={[
                            styles.dot,
                            isSelected ? styles.dotSelected : styles.dotNormal,
                            isSelected && styles.dotShadow,
                        ]}
                    />
                </TouchableOpacity>
            );
        } else {
            const aboveDot = Math.floor(index / 2);
            const isAboveSelected = aboveDot === selectedIndex;

            return (
                <Animated.View
                    key={`line-${index}`}
                    style={[
                        styles.line,
                        isAboveSelected ? styles.lineExpanded : styles.lineNormal
                    ]}
                />
            );
        }
    });

    return <View style={styles.container}>{elements}</View>;
}

// ====================================================================
// STYLES
// ====================================================================

const styles = StyleSheet.create({
    container: {
        alignItems: 'center',
    },

    // Dot styles
    dot: {
        width: Dims.size16,
        borderRadius: Dims.size16 / 2, // Perfect circle
    },
    dotNormal: {
        height: Dims.size16,
        backgroundColor: Colors.lighter,
    },
    dotSelected: {
        height: Dims.size24,
        width: Dims.size24,
        borderRadius: Dims.size24 / 2,
        backgroundColor: Colors.bNormal,
    },
    dotShadow: {
        shadowColor: Colors.bNormal,
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.3,
        shadowRadius: 8,
        elevation: 4,
    },

    // Line styles
    line: {
        width: 2,
        backgroundColor: Colors.lighter,
    },
    lineNormal: {
        height: Dims.size104, // 104px when not selected
    },
    lineExpanded: {
        height: Dims.size264, // 264px when above dot is selected
    },
});
