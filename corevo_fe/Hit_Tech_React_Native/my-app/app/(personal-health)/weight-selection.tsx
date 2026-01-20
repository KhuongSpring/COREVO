import React, { useState, useRef, useEffect } from 'react';
import { View, Text, StyleSheet, ImageBackground, TouchableOpacity, ScrollView } from 'react-native';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { AppStrings } from '@/constants/AppStrings';

const BACKGROUND_IMAGE = require('@/assets/images/main_background_image.png');

const ITEM_WIDTH = 16;
const MIN_WEIGHT = 40;
const MAX_WEIGHT = 120;

type BMICategory = {
    name: string;
    color: string;
};

/**
 * Weight Selection Screen
 * Fourth step in personal health information collection
 * Uses a horizontal ruler to select weight and displays BMI
 */
export default function WeightSelectionScreen() {
    const router = useRouter();
    const params = useLocalSearchParams();
    const scrollViewRef = useRef<ScrollView>(null);

    const [weight, setWeight] = useState<number>(70.0);

    // Scroll to initial weight on mount
    useEffect(() => {
        const initialScrollOffset = (70.0 - MIN_WEIGHT) / 0.1 * ITEM_WIDTH;
        setTimeout(() => {
            scrollViewRef.current?.scrollTo({ x: initialScrollOffset, animated: false });
        }, 100);
    }, []);

    const handleScroll = (event: any) => {
        const offsetX = event.nativeEvent.contentOffset.x;
        const total = (MAX_WEIGHT - MIN_WEIGHT) / 0.1 * ITEM_WIDTH;
        const newWeight = MIN_WEIGHT + (offsetX / total) * (MAX_WEIGHT - MIN_WEIGHT);
        const clampedWeight = Math.max(MIN_WEIGHT, Math.min(MAX_WEIGHT, newWeight));
        setWeight(clampedWeight);
    };

    const calculateBMI = (weight: number, height: number): number => {
        const h = height / 100.0;
        return weight / (h * h);
    };

    const getBMICategory = (bmi: number): BMICategory => {
        if (bmi < 18.5) return { name: 'Thiếu cân', color: '#64B5F6' };
        if (bmi < 25) return { name: 'Bình thường', color: '#66BB6A' };
        if (bmi < 30) return { name: 'Thừa cân', color: '#FFA726' };
        return { name: 'Béo phì', color: '#EF5350' };
    };

    const getBMIColor = (bmi: number): string => {
        if (bmi < 18.5) return '#64B5F6';
        if (bmi < 25) return '#66BB6A';
        if (bmi < 30) return '#FFA726';
        return '#EF5350';
    };

    const getBMIPosition = (bmi: number): number => {
        const clamped = Math.max(15.0, Math.min(35.0, bmi));
        return (clamped - 15.0) / 20.0;
    };

    const handleContinue = () => {
        router.push({
            pathname: '/(personal-health)/activity-level-selection' as any,
            params: {
                gender: params.gender,
                age: params.age,
                height: params.height,
                weight: weight.toFixed(1)
            }
        });
    };

    const renderWeightMark = (w: number) => {
        const isMain = Math.round(w * 10) % 10 === 0;
        const isNear = Math.abs(w - weight) <= 0.5;

        return (
            <View key={w.toFixed(1)} style={styles.weightMarkContainer}>
                <View
                    style={[
                        styles.weightMark,
                        isMain ? styles.weightMarkMain : styles.weightMarkMinor,
                        isNear && styles.weightMarkActive
                    ]}
                />
                {isMain && (
                    <>
                        <View style={styles.weightMarkSpacer} />
                        <Text
                            style={[
                                styles.weightMarkText,
                                isNear && styles.weightMarkTextActive
                            ]}
                        >
                            {w.toFixed(0)}
                        </Text>
                    </>
                )}
            </View>
        );
    };

    const height = parseInt(params.height as string) || 170;
    const bmi = calculateBMI(weight, height);
    const bmiCategory = getBMICategory(bmi);
    const bmiColor = getBMIColor(bmi);
    const bmiPosition = getBMIPosition(bmi);

    return (
        <ImageBackground
            source={BACKGROUND_IMAGE}
            style={styles.backgroundImage}
            resizeMode="cover"
        >
            <View style={styles.container}>
                {/* Header with Back Button and Progress */}
                <View style={styles.header}>
                    <TouchableOpacity style={styles.backButton} onPress={() => router.back()}>
                        <Ionicons name="chevron-back" size={28} color={Colors.bNormal} />
                    </TouchableOpacity>
                    <View style={styles.progressContainer}>
                        <View style={styles.progressBar}>
                            <View style={[styles.progressFill, { width: '80%' }]} />
                        </View>
                    </View>
                </View>

                {/* Info Box */}
                <View style={styles.infoBox}>
                    <Text style={styles.infoTitle}>{AppStrings.weightSelectionTitle}</Text>
                    <Text style={styles.infoDescription}>
                        {AppStrings.weightSelectionDescription}
                    </Text>
                </View>

                {/* BMI Indicator */}
                <View style={styles.bmiContainer}>
                    <Text style={styles.bmiText}>
                        Chỉ số BMI của bạn là {bmi.toFixed(1)} - {bmiCategory.name}
                    </Text>
                    <View style={styles.bmiBarContainer}>
                        <View style={styles.bmiBar}>
                            <View style={[styles.bmiSegment, { backgroundColor: '#64B5F6', flex: 3.5 }]} />
                            <View style={[styles.bmiSegment, { backgroundColor: '#66BB6A', flex: 6.5 }]} />
                            <View style={[styles.bmiSegment, { backgroundColor: '#FFA726', flex: 5 }]} />
                            <View style={[styles.bmiSegment, { backgroundColor: '#EF5350', flex: 5 }]} />
                        </View>
                        <View
                            style={[
                                styles.bmiIndicator,
                                { left: `${bmiPosition * 100}%`, backgroundColor: bmiColor }
                            ]}
                        >
                            <Ionicons name="person" size={12} color={Colors.wWhite} />
                        </View>
                    </View>
                </View>

                {/* Weight Display and Selector */}
                <View style={styles.weightContainer}>
                    <View style={styles.weightDisplay}>
                        <Text style={styles.weightValue}>{weight.toFixed(1)}</Text>
                        <Text style={styles.weightUnit}>kg</Text>
                    </View>

                    <View style={styles.rulerContainer}>
                        <View style={styles.centerIndicator} />
                        <ScrollView
                            ref={scrollViewRef}
                            horizontal
                            showsHorizontalScrollIndicator={false}
                            onScroll={handleScroll}
                            scrollEventThrottle={16}
                            bounces={true}
                            contentContainerStyle={{
                                paddingHorizontal: Dims.size152
                            }}
                        >
                            {Array.from({ length: ((MAX_WEIGHT - MIN_WEIGHT) / 0.1) + 1 }, (_, i) => MIN_WEIGHT + i * 0.1).map(w =>
                                renderWeightMark(w)
                            )}
                        </ScrollView>
                    </View>
                </View>

                {/* Continue Button */}
                <View style={styles.bottomContainer}>
                    <TouchableOpacity
                        style={styles.continueButton}
                        onPress={handleContinue}
                    >
                        <Text style={styles.continueButtonText}>
                            {AppStrings.selectionContinue}
                        </Text>
                    </TouchableOpacity>
                </View>
            </View>
        </ImageBackground>
    );
}

const styles = StyleSheet.create({
    backgroundImage: {
        flex: 1,
        width: '100%',
        height: '100%',
    },
    container: {
        flex: 1,
        paddingHorizontal: Dims.paddingL,
    },

    // Header
    header: {
        flexDirection: 'row',
        alignItems: 'center',
        paddingTop: Dims.spacingGiant,
        marginBottom: Dims.spacingXL,
        paddingRight: Dims.paddingXL,
        gap: Dims.spacingM,
    },
    backButton: {
        width: Dims.size40,
        height: Dims.size40,
        justifyContent: 'center',
        alignItems: 'center',
    },
    progressContainer: {
        flex: 1,
    },
    progressBar: {
        height: Dims.size8,
        backgroundColor: Colors.buttonBGBottomGender,
        borderRadius: Dims.borderRadius,
        overflow: 'hidden',
    },
    progressFill: {
        height: '100%',
        backgroundColor: Colors.bNormal,
        borderRadius: Dims.borderRadius,
    },

    // Info Box
    infoBox: {
        backgroundColor: Colors.bLightNotActive2,
        borderRadius: Dims.borderRadius,
        padding: Dims.paddingL,
        marginBottom: Dims.spacingXL,
        width: '100%',
    },
    infoTitle: {
        fontSize: Dims.textSizeXL,
        fontWeight: 'bold',
        color: Colors.dark,
        marginBottom: Dims.spacingS,
        textAlign: 'center',
    },
    infoDescription: {
        fontSize: Dims.textSizeM,
        color: Colors.dark,
        textAlign: 'center',
        lineHeight: 22,
    },

    // BMI Indicator
    bmiContainer: {
        backgroundColor: Colors.wWhite,
        borderRadius: Dims.borderRadius,
        padding: Dims.paddingM,
        marginBottom: Dims.spacingL,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.05,
        shadowRadius: 8,
        elevation: 2,
    },
    bmiText: {
        fontSize: Dims.textSizeM,
        fontWeight: 'bold',
        color: Colors.dark,
        textAlign: 'center',
        marginBottom: Dims.spacingSM,
    },
    bmiBarContainer: {
        position: 'relative',
        height: Dims.size24,
        justifyContent: 'center',
    },
    bmiBar: {
        height: Dims.size8,
        flexDirection: 'row',
        borderRadius: Dims.borderRadiusTiny,
        overflow: 'hidden',
    },
    bmiSegment: {
        height: '100%',
    },
    bmiIndicator: {
        position: 'absolute',
        width: Dims.size24,
        height: Dims.size24,
        borderRadius: Dims.borderRadiusLarge,
        borderWidth: 2,
        borderColor: Colors.wWhite,
        marginLeft: -12,
        top: 0,
        justifyContent: 'center',
        alignItems: 'center',
    },

    // Weight Container
    weightContainer: {
        flex: 1,
        backgroundColor: Colors.bLight,
        borderRadius: Dims.borderRadius,
        paddingVertical: Dims.paddingXXL,
    },
    weightDisplay: {
        flexDirection: 'row',
        alignItems: 'flex-end',
        justifyContent: 'center',
        marginBottom: Dims.spacingGiant,
    },
    weightValue: {
        fontSize: Dims.size48,
        fontWeight: 'bold',
        color: Colors.bNormal,
    },
    weightUnit: {
        fontSize: Dims.textSizeXL,
        color: Colors.lightHover,
        fontWeight: '500',
        marginLeft: Dims.spacingS,
        marginBottom: Dims.spacingS,
    },

    // Ruler
    rulerContainer: {
        height: Dims.size120,
        position: 'relative',
        paddingHorizontal: Dims.paddingL,
    },
    centerIndicator: {
        position: 'absolute',
        top: 0,
        left: '50%',
        width: 2,
        height: Dims.size24,
        backgroundColor: Colors.bNormal,
        marginLeft: -1,
        zIndex: 10,
    },
    weightMarkContainer: {
        width: ITEM_WIDTH,
        alignItems: 'center',
    },
    weightMark: {
        width: 2,
    },
    weightMarkMinor: {
        height: Dims.size16,
        backgroundColor: Colors.lighter,
    },
    weightMarkMain: {
        height: Dims.size24,
        backgroundColor: Colors.lighter,
    },
    weightMarkActive: {
        backgroundColor: Colors.bNormal,
    },
    weightMarkSpacer: {
        height: Dims.spacingS,
    },
    weightMarkText: {
        fontSize: Dims.textSizeXS,
        color: Colors.lighter,
    },
    weightMarkTextActive: {
        color: Colors.bNormal,
        fontWeight: 'bold',
    },

    // Bottom Container
    bottomContainer: {
        paddingVertical: Dims.paddingXL,
        paddingBottom: Dims.paddingXXXL,
    },
    continueButton: {
        backgroundColor: Colors.bNormal,
        borderRadius: Dims.borderRadiusLarge,
        paddingVertical: Dims.paddingM,
        alignItems: 'center',
        justifyContent: 'center',
    },
    continueButtonText: {
        fontSize: Dims.textSizeL,
        fontWeight: '600',
        color: Colors.wWhite,
    },
});
