import React, { useState } from 'react';
import {
    View,
    Text,
    StyleSheet,
    TouchableOpacity,
    ScrollView,
    ImageBackground,
    Image
} from 'react-native';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { LinearGradient } from 'expo-linear-gradient';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { AppAssets } from '@/constants/AppAssets';
import { AppStrings } from '@/constants/AppStrings';

/**
 * Training Setup - Step 3: Duration Selection
 * Converted from Flutter training_duration_selection_widget.dart
 */
export default function DurationSelectionScreen() {
    const router = useRouter();
    const [selectedIndex, setSelectedIndex] = useState<number | null>(null);

    const durations = [
        AppStrings.duration1530,
        AppStrings.duration3045,
        AppStrings.duration4560,
        AppStrings.duration60plus,
    ];

    const getDurationImage = (index: number, isSelected: boolean) => {
        const images = [
            { normal: AppAssets.duration1, selected: AppAssets.durationSelected1 },
            { normal: AppAssets.duration2, selected: AppAssets.durationSelected2 },
            { normal: AppAssets.duration3, selected: AppAssets.durationSelected3 },
            { normal: AppAssets.duration4, selected: AppAssets.durationSelected4 },
        ];
        return isSelected ? images[index].selected : images[index].normal;
    };

    const handleDurationPress = (index: number) => {
        if (selectedIndex === index) {
            setSelectedIndex(null);
        } else {
            setSelectedIndex(index);
        }
    };

    const handleContinue = () => {
        if (selectedIndex === null) return;

        // TODO: Send duration to API
        // TODO: Navigate to next step
        router.push('/(training-setup)/step-4-type' as any);
    };

    return (
        <View style={styles.container}>
            {/* Background Image */}
            <ImageBackground
                source={AppAssets.mainBackground}
                style={styles.backgroundImage}
                resizeMode="cover"
            >
                {/* Header with Back Button and Progress Bar */}
                <View style={styles.headerContainer}>
                    <TouchableOpacity style={styles.backButton} onPress={() => router.back()}>
                        <Ionicons name="chevron-back" size={28} color={Colors.bNormal} />
                    </TouchableOpacity>

                    <View style={styles.progressBarContainer}>
                        <View style={styles.progressBarBackground}>
                            <View style={[styles.progressBarFill, { width: `${(3 / 7) * 100}%` }]} />
                        </View>
                    </View>
                </View>

                {/* Title Header */}
                <View style={styles.titleContainer}>
                    <View style={styles.titleAccent} />
                    <Text style={styles.titleText}>
                        {AppStrings.durationSelectionTitle}
                    </Text>
                </View>

                {/* Scrollable Duration List */}
                <ScrollView
                    style={styles.scrollView}
                    contentContainerStyle={styles.scrollContent}
                    showsVerticalScrollIndicator={false}
                >
                    {durations.map((duration, index) => (
                        <TouchableOpacity
                            key={index}
                            style={[
                                styles.durationCard,
                                selectedIndex === index && styles.durationCardSelected,
                            ]}
                            onPress={() => handleDurationPress(index)}
                        >
                            <Image
                                source={getDurationImage(index, selectedIndex === index)}
                                style={styles.durationImage}
                            />
                            <Text style={[
                                styles.durationText,
                                selectedIndex === index && styles.durationTextSelected,
                            ]}>
                                {duration}
                            </Text>
                            <Image
                                source={selectedIndex === index ? AppAssets.tickActive : AppAssets.tickNonActive}
                                style={styles.tickIcon}
                            />
                        </TouchableOpacity>
                    ))}
                </ScrollView>

                {/* Gradient Overlay */}
                <LinearGradient
                    colors={['rgba(255, 255, 255, 0)', Colors.wWhite]}
                    locations={[0.0, 1.0]}
                    style={styles.gradientOverlay}
                    pointerEvents="none"
                />

                {/* Continue Button */}
                <View style={styles.buttonContainer}>
                    <TouchableOpacity
                        style={[
                            styles.continueButton,
                            selectedIndex === null && styles.continueButtonDisabled,
                        ]}
                        onPress={handleContinue}
                        disabled={selectedIndex === null}
                    >
                        <Text style={[
                            styles.continueButtonText,
                            selectedIndex === null && styles.continueButtonTextDisabled,
                        ]}>
                            {AppStrings.selectionContinue}
                        </Text>
                    </TouchableOpacity>
                </View>
            </ImageBackground>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    backgroundImage: {
        flex: 1,
    },
    headerContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        paddingTop: Dims.size48,
        paddingRight: Dims.size72,
    },
    backButton: {
        padding: Dims.spacingM,
    },
    progressBarContainer: {
        flex: 1,
        marginLeft: Dims.spacingL,
    },
    progressBarBackground: {
        height: Dims.size8,
        backgroundColor: Colors.buttonBGBottomGender,
        borderRadius: Dims.borderRadius,
        overflow: 'hidden',
    },
    progressBarFill: {
        height: '100%',
        backgroundColor: Colors.bNormal,
        borderRadius: Dims.borderRadius,
    },
    titleContainer: {
        flexDirection: 'row',
        marginHorizontal: Dims.paddingM,
        marginTop: Dims.spacingXL,
        backgroundColor: Colors.bLightHover,
        borderRadius: Dims.borderRadiusSmall,
        alignItems: 'center',
    },
    titleAccent: {
        width: Dims.size16,
        height: Dims.size88,
        backgroundColor: Colors.bLightActive2,
    },
    titleText: {
        flex: 1,
        fontSize: Dims.textSizeXL,
        fontWeight: '600',
        color: Colors.dark,
        marginLeft: Dims.size16,
        paddingVertical: Dims.spacingM,
    },
    scrollView: {
        flex: 1,
        marginTop: Dims.spacingXXL,
    },
    scrollContent: {
        paddingHorizontal: Dims.paddingM,
        paddingBottom: Dims.size152,
    },
    durationCard: {
        flexDirection: 'row',
        alignItems: 'center',
        backgroundColor: Colors.wWhite,
        borderRadius: Dims.borderRadiusSmall,
        padding: Dims.paddingM,
        marginBottom: Dims.paddingM,
        height: Dims.size96,
        borderWidth: 1,
        borderColor: Colors.wWhite,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 3 },
        shadowOpacity: 0.1,
        shadowRadius: 6,
        elevation: 3,
    },
    durationCardSelected: {
        backgroundColor: Colors.bLightHover,
        borderWidth: 2,
        borderColor: Colors.bNormal,
    },
    durationImage: {
        width: Dims.size40,
        height: Dims.size40,
        marginLeft: Dims.spacingSM,
        marginRight: Dims.spacingML,
        resizeMode: 'contain',
    },
    durationText: {
        flex: 1,
        fontSize: Dims.textSizeL,
        color: Colors.darkActive,
        fontWeight: '500',
    },
    durationTextSelected: {
        color: Colors.bNormal,
    },
    tickIcon: {
        width: Dims.iconSizeL,
        height: Dims.iconSizeL,
        marginRight: Dims.spacingSM,
    },
    gradientOverlay: {
        position: 'absolute',
        bottom: 0,
        left: 0,
        right: 0,
        height: Dims.size152,
    },
    buttonContainer: {
        position: 'absolute',
        bottom: Dims.size72,
        left: Dims.paddingM,
        right: Dims.paddingM,
    },
    continueButton: {
        backgroundColor: Colors.bNormal,
        height: Dims.size56,
        borderRadius: Dims.borderRadiusLarge,
        alignItems: 'center',
        justifyContent: 'center',
    },
    continueButtonDisabled: {
        backgroundColor: Colors.bLightNotActive,
    },
    continueButtonText: {
        fontSize: Dims.textSizeL,
        color: Colors.wWhite,
    },
    continueButtonTextDisabled: {
        color: Colors.wDark,
    },
});
