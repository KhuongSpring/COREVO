import React, { useState } from 'react';
import { View, Text, StyleSheet, ImageBackground, TouchableOpacity, Image } from 'react-native';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { LinearGradient } from 'expo-linear-gradient';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { AppStrings } from '@/constants/AppStrings';

const BACKGROUND_IMAGE = require('@/assets/images/main_background_image.png');
const BOY_IMAGE = require('@/assets/images/health_infor/boy.png');
const GIRL_IMAGE = require('@/assets/images/health_infor/girl.png');

type GenderType = 'MALE' | 'FEMALE' | null;

export default function GenderSelectionScreen() {
    const router = useRouter();
    const [selectedGender, setSelectedGender] = useState<GenderType>(null);

    const handleContinue = () => {
        if (selectedGender) {
            router.push({
                pathname: '/(personal-health)/age-selection' as any,
                params: { gender: selectedGender }
            });
        }
    };

    // Reusable Gender Option Widget (Mimicking Flutter's _buildGenderOption)
    const renderGenderOption = (gender: GenderType, label: string, imageSource: any) => {
        const isSelected = selectedGender === gender;

        return (
            <TouchableOpacity
                activeOpacity={0.9}
                onPress={() => setSelectedGender(gender)}
                style={styles.cardWrapper}
            >
                {/* 1. The Card Container (Background) */}
                <View style={[
                    styles.cardContainer,
                    isSelected ? styles.cardContainerSelected : styles.cardContainerNormal
                ]}>
                    {/* Gradient Background inside card */}
                    {isSelected && (
                        <LinearGradient
                            colors={[Colors.bLightActive, Colors.wWhite]}
                            start={{ x: 0.5, y: 1 }}
                            end={{ x: 0.5, y: 0 }}
                            style={StyleSheet.absoluteFill}
                        />
                    )}
                </View>

                {/* 2. The Image (Positioned Absolute to pop out) */}
                <View style={styles.imagePositionWrapper}>
                    <Image
                        source={imageSource}
                        style={styles.genderImage}
                        resizeMode="contain"
                    />
                </View>

                {/* 3. The Label Container (Bottom) */}
                <View style={[
                    styles.labelContainer,
                    isSelected ? styles.labelContainerSelected : styles.labelContainerNormal
                ]}>
                    <Ionicons
                        name={gender === 'MALE' ? 'male' : 'female'}
                        size={18}
                        color={gender === 'MALE' ? '#2196F3' : '#E91E63'}
                    />
                    <Text style={styles.labelText}>{label}</Text>
                </View>
            </TouchableOpacity>
        );
    };

    return (
        <ImageBackground
            source={BACKGROUND_IMAGE}
            style={styles.backgroundImage}
            resizeMode="cover"
        >
            <View style={styles.container}>
                {/* Header */}
                <View style={styles.header}>
                    <TouchableOpacity style={styles.backButton} onPress={() => router.back()}>
                        <Ionicons name="chevron-back" size={28} color={Colors.bNormal} />
                    </TouchableOpacity>
                    <View style={styles.progressContainer}>
                        <View style={styles.progressBar}>
                            <View style={[styles.progressFill, { width: '20%' }]} />
                        </View>
                    </View>
                </View>

                {/* Content */}
                <View style={styles.content}>
                    <View style={styles.infoBox}>
                        <Text style={styles.infoTitle}>{AppStrings.genderSelectionTitle}</Text>
                        <Text style={styles.infoDescription}>{AppStrings.genderSelectionDescription}</Text>
                    </View>

                    {/* Gender Selection Row */}
                    <View style={styles.genderRow}>
                        {renderGenderOption('MALE', AppStrings.genderSelectionBoy, BOY_IMAGE)}
                        {renderGenderOption('FEMALE', AppStrings.genderSelectionGirl, GIRL_IMAGE)}
                    </View>
                </View>

                {/* Continue Button */}
                <View style={styles.bottomContainer}>
                    <TouchableOpacity
                        style={[styles.continueButton, !selectedGender && styles.continueButtonDisabled]}
                        onPress={handleContinue}
                        disabled={!selectedGender}
                    >
                        <Text style={[styles.continueButtonText, !selectedGender && styles.continueButtonTextDisabled]}>
                            {AppStrings.selectionContinue}
                        </Text>
                    </TouchableOpacity>
                </View>
            </View>
        </ImageBackground>
    );
}

const styles = StyleSheet.create({
    backgroundImage: { flex: 1, width: '100%', height: '100%' },
    container: { flex: 1, paddingHorizontal: Dims.paddingL },

    // Header
    header: {
        flexDirection: 'row',
        alignItems: 'center',
        paddingTop: Dims.spacingGiant,
        marginBottom: Dims.spacingXL,
        paddingRight: Dims.paddingXL,
        gap: Dims.spacingM,
    },
    backButton: { width: 40, height: 40, justifyContent: 'center', alignItems: 'center' },
    progressContainer: { flex: 1 },
    progressBar: { height: 8, backgroundColor: '#E0E0E0', borderRadius: 4, overflow: 'hidden' },
    progressFill: { height: '100%', backgroundColor: Colors.bNormal, borderRadius: 4 },

    // Content
    content: { flex: 1 },
    infoBox: {
        backgroundColor: Colors.bLightNotActive2,
        borderRadius: Dims.borderRadius,
        padding: Dims.paddingL,
        marginBottom: Dims.spacingGiant,
    },
    infoTitle: {
        fontSize: Dims.textSizeXXL,
        fontWeight: 'bold',
        color: Colors.textGenderSelection,
        marginBottom: Dims.spacingS,
        textAlign: 'center',
    },
    infoDescription: {
        fontSize: Dims.textSizeM,
        color: Colors.textGenderSelection,
        textAlign: 'center',
        lineHeight: 22,
    },

    // --- GENDER CARD STYLES (MATCHING FLUTTER LOGIC) ---
    genderRow: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        gap: 16,
    },
    cardWrapper: {
        width: Dims.size160, // Fixed width like Flutter's AppDimensions.size160
        height: Dims.size320, // Fixed height like Flutter's AppDimensions.size320
        position: 'relative', // Essential for stacking
    },
    // 1. Background Card (Bottom Layer)
    cardContainer: {
        position: 'absolute',
        bottom: Dims.spacingXXL, // Leave space for label container overlap if needed, or adjust
        left: 0,
        right: 0,
        height: Dims.size240, // Roughly size264
        borderRadius: Dims.borderRadius,
        // borderWidth: 1,
        overflow: 'hidden', // Keeps gradient inside
    },
    cardContainerNormal: {
        backgroundColor: Colors.wWhite,
        // borderColor: Colors.wDark, // Light border
    },
    cardContainerSelected: {
        backgroundColor: Colors.bLightActive, // Light blue bg
        // borderColor: Colors.bNormal, // Blue border
        // borderWidth: 2,
    },

    // 2. Image Position (Top Layer - Popping out)
    imagePositionWrapper: {
        position: 'absolute',
        top: 0,
        left: 0,
        right: 0,
        height: 280, // Allow height for the image
        alignItems: 'center',
        zIndex: 2, // Ensure image is above card background
    },
    genderImage: {
        width: '90%',
        height: '100%',
    },

    // 3. Label Container (Bottom Layer - Floating)
    labelContainer: {
        position: 'absolute',
        bottom: 20, // Pinned to bottom
        left: 0,
        right: 0,
        height: 50, // size64
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        borderRadius: Dims.borderRadius,
        // borderWidth: 1,
        gap: 8,
        zIndex: 3, // Above everything
    },
    labelContainerNormal: {
        backgroundColor: Colors.wWhite,
        // borderColor: Colors.wDark,
    },
    labelContainerSelected: {
        backgroundColor: Colors.bLightActive,
        // borderColor: Colors.bNormal,
        // borderWidth: 2,
    },
    labelText: {
        fontSize: Dims.textSizeS,
        fontWeight: '600',
        color: '#000',
    },

    // Bottom Button
    bottomContainer: { paddingVertical: Dims.paddingXL, paddingBottom: Dims.paddingXXXL },
    continueButton: {
        backgroundColor: Colors.bNormal,
        borderRadius: Dims.borderRadiusXL,
        paddingVertical: Dims.paddingM,
        alignItems: 'center',
        justifyContent: 'center',
    },
    continueButtonDisabled: { backgroundColor: Colors.bLightNotActive },
    continueButtonText: { fontSize: Dims.textSizeL, fontWeight: '600', color: Colors.wWhite },
    continueButtonTextDisabled: { color: 'rgba(255,255,255,0.7)' },
});