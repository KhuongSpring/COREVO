import React from 'react';
import { View } from 'react-native';
import Svg, { Circle } from 'react-native-svg';

interface CircularProgressProps {
    size: number;
    strokeWidth: number;
    progress: number; // 0-100
    progressColor: string;
    backgroundColor: string;
    children?: React.ReactNode;
}

/**
 * Circular Progress Indicator
 * Displays a circular progress bar with percentage fill
 */
export default function CircularProgress({
    size,
    strokeWidth,
    progress,
    progressColor,
    backgroundColor,
    children,
}: CircularProgressProps) {
    const radius = (size - strokeWidth) / 2;
    const circumference = 2 * Math.PI * radius;
    const progressOffset = circumference - (progress / 100) * circumference;

    return (
        <View style={{ width: size, height: size, position: 'relative' }}>
            <Svg width={size} height={size}>
                {/* Background Circle */}
                <Circle
                    cx={size / 2}
                    cy={size / 2}
                    r={radius}
                    stroke={backgroundColor}
                    strokeWidth={strokeWidth}
                    fill="transparent"
                />

                {/* Progress Circle */}
                <Circle
                    cx={size / 2}
                    cy={size / 2}
                    r={radius}
                    stroke={progressColor}
                    strokeWidth={strokeWidth}
                    fill="transparent"
                    strokeDasharray={circumference}
                    strokeDashoffset={progressOffset}
                    strokeLinecap="round"
                    rotation="-90"
                    origin={`${size / 2}, ${size / 2}`}
                />
            </Svg>

            {/* Center Content */}
            {children && (
                <View
                    style={{
                        position: 'absolute',
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        justifyContent: 'center',
                        alignItems: 'center',
                    }}
                >
                    {children}
                </View>
            )}
        </View>
    );
}
