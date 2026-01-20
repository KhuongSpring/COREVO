import React, { useState, useRef, useEffect } from 'react';
import { View, Text, StyleSheet, ImageBackground, TouchableOpacity, ScrollView, Image } from 'react-native';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { AppStrings } from '@/constants/AppStrings';

const BACKGROUND_IMAGE = require('@/assets/images/main_background_image.png');
const BOY_IMAGE = require('@/assets/images/health_infor/boy.png');
const GIRL_IMAGE = require('@/assets/images/health_infor/girl.png');

const ITEM_HEIGHT = 32;
const MIN_HEIGHT = 100;
const MAX_HEIGHT = 200;

/**
 * Height Selection Screen
 * Third step in personal health information collection
 * Uses a vertical ruler to select height
 */
export default function HeightSelectionScreen() {
    const router = useRouter();
    const params = useLocalSearchParams();
    const scrollViewRef = useRef<ScrollView>(null);


    const [height, setHeight] = useState<number>(180);

    // Scroll to initial height on mount
    useEffect(() => {
        const initialScrollOffset = (MAX_HEIGHT - 180) * ITEM_HEIGHT;
        setTimeout(() => {
            scrollViewRef.current?.scrollTo({ y: initialScrollOffset, animated: false });
        }, 100);
    }, []);

    const handleScroll = (event: any) => {
        const offsetY = event.nativeEvent.contentOffset.y;
        const total = (MAX_HEIGHT - MIN_HEIGHT) * ITEM_HEIGHT;
        const progress = offsetY / total;
        const range = MAX_HEIGHT - MIN_HEIGHT;
        const newHeight = Math.round(MAX_HEIGHT - progress * range);
        const clampedHeight = Math.max(MIN_HEIGHT, Math.min(MAX_HEIGHT, newHeight));
        setHeight(clampedHeight);
    };

    const handleContinue = () => {
        router.push({
            pathname: '/(personal-health)/weight-selection' as any,
            params: {
                gender: params.gender,
                age: params.age,
                height: height.toString()
            }
        });
    };

    const renderRulerItem = (h: number) => {
        const isMain = h % 10 === 0 || h % 5 === 0;
        const isNear = Math.abs(h - height) <= 2;

        return (
            <View key={h} style={styles.rulerItem}>
                <View style={styles.rulerRow}>
                    {isMain && (
                        <>
                            <Text
                                style={[
                                    styles.rulerText,
                                    isNear && styles.rulerTextActive
                                ]}
                            >
                                {h}
                            </Text>
                            <View style={styles.rulerTextSpacer} />
                        </>
                    )}
                    <View
                        style={[
                            styles.rulerMark,
                            isMain ? styles.rulerMarkMain : styles.rulerMarkMinor,
                            isNear && styles.rulerMarkActive
                        ]}
                    />
                </View>
            </View>
        );
    };

    // Determine which gender image to show
    const genderImage = params.gender === 'FEMALE' ? GIRL_IMAGE : BOY_IMAGE;

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
                            <View style={[styles.progressFill, { width: '60%' }]} />
                        </View>
                    </View>
                </View>

                {/* Info Box */}
                <View style={styles.infoBox}>
                    <Text style={styles.infoTitle}>{AppStrings.heightSelectionTitle}</Text>
                    <Text style={styles.infoDescription}>
                        {AppStrings.heightSelectionDescription}
                    </Text>
                </View>

                {/* Main Content Area */}
                <View style={styles.mainContent}>
                    {/* Height Display */}
                    <View style={styles.heightDisplay}>
                        <Text style={styles.heightValue}>{height}</Text>
                        <Text style={styles.heightUnit}>cm</Text>
                    </View>

                    {/* Height Indicator Line */}
                    <View style={styles.heightIndicator} />

                    {/* Gender Image */}
                    <View style={styles.genderImageContainer}>
                        <Image
                            source={genderImage}
                            style={styles.genderImage}
                            resizeMode="contain"
                        />
                    </View>

                    {/* Ruler */}
                    <View style={styles.rulerContainer}>
                        <ScrollView
                            ref={scrollViewRef}
                            showsVerticalScrollIndicator={false}
                            onScroll={handleScroll}
                            scrollEventThrottle={16}
                            bounces={true}
                            contentContainerStyle={{
                                paddingVertical: Dims.size104
                            }}
                        >
                            {Array.from({ length: MAX_HEIGHT - MIN_HEIGHT + 1 }, (_, i) => MAX_HEIGHT - i).map(h =>
                                renderRulerItem(h)
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

    // Main Content
    mainContent: {
        flex: 1,
        position: 'relative',
    },

    // Height Display
    heightDisplay: {
        position: 'absolute',
        top: Dims.paddingM,
        left: Dims.paddingXL,
        flexDirection: 'row',
        alignItems: 'baseline',
        zIndex: 10,
    },
    heightValue: {
        fontSize: Dims.size40,
        fontWeight: 'bold',
        color: Colors.dark,
    },
    heightUnit: {
        fontSize: Dims.textSizeL,
        color: Colors.lightActive,
        fontWeight: '500',
        marginLeft: Dims.spacingS,
    },

    // Height Indicator Line
    heightIndicator: {
        position: 'absolute',
        top: Dims.spacingGiant,
        left: Dims.paddingXL,
        width: Dims.size144,
        height: Dims.size4,
        backgroundColor: Colors.bNormal,
        borderRadius: Dims.borderRadiusTiny,
        zIndex: 10,
    },

    // Gender Image
    genderImageContainer: {
        position: 'absolute',
        left: Dims.paddingXL,
        top: Dims.size80,
        bottom: Dims.paddingXXL,
        width: Dims.size176,
    },
    genderImage: {
        width: '100%',
        height: '100%',
    },

    // Ruler
    rulerContainer: {
        position: 'absolute',
        right: Dims.paddingL,
        top: Dims.size80,
        bottom: Dims.size104,
        width: Dims.size80,
    },
    rulerItem: {
        height: ITEM_HEIGHT,
        justifyContent: 'center',
    },
    rulerRow: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'flex-end',
    },
    rulerText: {
        fontSize: Dims.textSizeM,
        color: Colors.lightActive,
        fontWeight: '500',
    },
    rulerTextActive: {
        color: Colors.bNormal,
        fontWeight: 'bold',
    },
    rulerTextSpacer: {
        width: Dims.spacingS,
    },
    rulerMark: {
        height: 2,
        borderRadius: Dims.borderRadiusTiny,
    },
    rulerMarkMinor: {
        width: Dims.size16,
        backgroundColor: Colors.lighter,
    },
    rulerMarkMain: {
        width: Dims.size24,
        backgroundColor: Colors.lightActive,
    },
    rulerMarkActive: {
        height: 3,
        backgroundColor: Colors.bNormal,
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
