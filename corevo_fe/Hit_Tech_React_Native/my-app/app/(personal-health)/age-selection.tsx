import React, { useState, useRef, useEffect } from 'react';
import { View, Text, StyleSheet, ImageBackground, TouchableOpacity, ScrollView, Dimensions } from 'react-native';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { AppStrings } from '@/constants/AppStrings';

const BACKGROUND_IMAGE = require('@/assets/images/main_background_image.png');
const ITEM_HEIGHT = 60;
const VISIBLE_ITEMS = 5;

/**
 * Age Selection Screen
 * Second step in personal health information collection
 * Uses a picker wheel to select birth year
 */
export default function AgeSelectionScreen() {
    const router = useRouter();
    const params = useLocalSearchParams();
    const scrollViewRef = useRef<ScrollView>(null);

    // Generate years from current year to 50 years ago
    const currentYear = new Date().getFullYear();
    const years = Array.from({ length: 50 }, (_, i) => currentYear - i);

    // Initial year is 2005 (age ~20)
    const initialYear = 2005;
    const initialIndex = years.indexOf(initialYear);
    const [selectedYear, setSelectedYear] = useState<number>(initialYear);
    const [scrollOffset, setScrollOffset] = useState<number>(0);

    useEffect(() => {
        // Scroll to initial position after mount
        if (scrollViewRef.current && initialIndex >= 0) {
            const offset = initialIndex * ITEM_HEIGHT;
            scrollViewRef.current.scrollTo({ y: offset, animated: false });
        }
    }, []);

    const handleScroll = (event: any) => {
        const offsetY = event.nativeEvent.contentOffset.y;
        setScrollOffset(offsetY);

        // Calculate which year is in the center
        const index = Math.round(offsetY / ITEM_HEIGHT);
        const clampedIndex = Math.max(0, Math.min(index, years.length - 1));
        setSelectedYear(years[clampedIndex]);
    };

    const handleMomentumScrollEnd = (event: any) => {
        const offsetY = event.nativeEvent.contentOffset.y;
        const index = Math.round(offsetY / ITEM_HEIGHT);
        const clampedIndex = Math.max(0, Math.min(index, years.length - 1));

        // Snap to the nearest item
        scrollViewRef.current?.scrollTo({
            y: clampedIndex * ITEM_HEIGHT,
            animated: true
        });

        setSelectedYear(years[clampedIndex]);
    };

    const handleContinue = () => {
        const age = currentYear - selectedYear;
        router.push({
            pathname: '/(personal-health)/height-selection' as any,
            params: {
                gender: params.gender,
                age: age.toString(),
                year: selectedYear.toString()
            }
        });
    };

    const renderYearItem = (year: number, index: number) => {
        const isSelected = year === selectedYear;

        return (
            <View
                key={year}
                style={[
                    styles.yearItem,
                    isSelected && styles.yearItemSelected
                ]}
            >
                <Text
                    style={[
                        styles.yearText,
                        isSelected && styles.yearTextSelected
                    ]}
                >
                    {year}
                </Text>
            </View>
        );
    };

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
                            <View style={[styles.progressFill, { width: '40%' }]} />
                        </View>
                    </View>
                </View>

                {/* Info Box */}
                <View style={styles.infoBox}>
                    <Text style={styles.infoTitle}>{AppStrings.ageSelectionTitle}</Text>
                    <Text style={styles.infoDescription}>
                        {AppStrings.ageSelectionDescription}
                    </Text>
                </View>

                {/* Year Picker */}
                <View style={styles.pickerContainer}>
                    {/* Center highlight indicator */}
                    <View style={styles.centerIndicator} />

                    {/* Scrollable year list */}
                    {/* Center highlight indicator */}
                    <View style={styles.centerIndicator} />

                    {/* Scrollable year list */}
                    <ScrollView
                        ref={scrollViewRef}
                        showsVerticalScrollIndicator={false}
                        onScroll={handleScroll}
                        onMomentumScrollEnd={handleMomentumScrollEnd}
                        scrollEventThrottle={16}
                        snapToInterval={ITEM_HEIGHT}
                        decelerationRate="fast"
                        contentContainerStyle={{
                            paddingVertical: (VISIBLE_ITEMS - 1) * ITEM_HEIGHT / 2
                        }}
                    >
                        {years.map((year, index) => renderYearItem(year, index))}
                    </ScrollView>
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
        borderRadius: Dims.borderRadiusTiny,
        overflow: 'hidden',
    },
    progressFill: {
        height: '100%',
        backgroundColor: Colors.bNormal,
        borderRadius: Dims.borderRadiusTiny,
    },

    // Info Box
    infoBox: {
        backgroundColor: Colors.bLightNotActive2,
        borderRadius: Dims.borderRadius,
        padding: Dims.paddingL,
        marginBottom: Dims.spacingGiant,
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

    // Year Picker
    pickerContainer: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
        position: 'relative',
        marginVertical: Dims.spacingXL,
    },
    centerIndicator: {
        position: 'absolute',
        top: '50%',
        left: 0,
        right: 0,
        height: ITEM_HEIGHT,
        backgroundColor: Colors.bLightHover,
        borderColor: Colors.bNormal,
        borderWidth: 2,
        borderRadius: Dims.borderRadiusLarge,
        marginTop: -(ITEM_HEIGHT / 2),
        zIndex: -1,
    },
    yearItem: {
        height: ITEM_HEIGHT,
        justifyContent: 'center',
        alignItems: 'center',
    },
    yearItemSelected: {
        // Selected state is shown by the center indicator
    },
    yearText: {
        fontSize: Dims.textSizeL,
        fontWeight: '500',
        color: Colors.lighter,
    },
    yearTextSelected: {
        fontSize: Dims.textSizeXXXL,
        fontWeight: 'bold',
        color: Colors.bNormal,
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