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
 * Training Setup - Step 2: Level Selection
 * Converted from Flutter training_level_selection_widget.dart
 */
export default function LevelSelectionScreen() {
    const router = useRouter();
    const [selectedIndex, setSelectedIndex] = useState<number | null>(null);

    const levels = [
        AppStrings.levelSelectionBeginner,
        AppStrings.levelSelectionIntermediate,
        AppStrings.levelSelectionAdvanced,
    ];

    const levelDetails = [
        AppStrings.levelSelectionBeginnerDescription,
        AppStrings.levelSelectionIntermediateDescription,
        AppStrings.levelSelectionAdvancedDescription,
    ];

    const getLevelImage = (index: number, isSelected: boolean) => {
        if (index === 0) {
            return isSelected ? AppAssets.beginnerSelected : AppAssets.beginner;
        } else if (index === 1) {
            return isSelected ? AppAssets.intermediateSelected : AppAssets.intermediate;
        } else {
            return isSelected ? AppAssets.advancedSelected : AppAssets.advanced;
        }
    };

    const handleLevelPress = (index: number) => {
        if (selectedIndex === index) {
            setSelectedIndex(null);
        } else {
            setSelectedIndex(index);
        }
    };

    const handleContinue = () => {
        if (selectedIndex === null) return;

        // TODO: Map level to English and send to API
        // TODO: Navigate to next step with duration options
        router.push('/(training-setup)/step-3-duration' as any);
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
                            <View style={[styles.progressBarFill, { width: `${(2 / 7) * 100}%` }]} />
                        </View>
                    </View>
                </View>

                {/* Title Header */}
                <View style={styles.titleContainer}>
                    <View style={styles.titleAccent} />
                    <Text style={styles.titleText}>
                        {AppStrings.levelSelectionTitle}
                    </Text>
                </View>

                {/* Scrollable Level List */}
                <ScrollView
                    style={styles.scrollView}
                    contentContainerStyle={styles.scrollContent}
                    showsVerticalScrollIndicator={false}
                >
                    {levels.map((level, index) => (
                        <TouchableOpacity
                            key={index}
                            style={[
                                styles.levelCard,
                                selectedIndex === index && styles.levelCardSelected,
                            ]}
                            onPress={() => handleLevelPress(index)}
                        >
                            <Image
                                source={getLevelImage(index, selectedIndex === index)}
                                style={styles.levelImage}
                            />
                            <View style={styles.levelContent}>
                                <Text style={styles.levelText}>{level}</Text>
                                <Text style={styles.levelDetail}>{levelDetails[index]}</Text>
                            </View>
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
    levelCard: {
        flexDirection: 'row',
        alignItems: 'center',
        backgroundColor: Colors.wWhite,
        borderRadius: Dims.borderRadiusSmall,
        padding: Dims.paddingM,
        marginBottom: Dims.paddingM,
        height: Dims.size112,
        borderWidth: 1,
        borderColor: Colors.wWhite,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 3 },
        shadowOpacity: 0.1,
        shadowRadius: 6,
        elevation: 3,
    },
    levelCardSelected: {
        backgroundColor: Colors.bLightHover,
        borderWidth: 2,
        borderColor: Colors.bNormal,
    },
    levelImage: {
        width: Dims.iconSizeL,
        height: Dims.size80,
        marginLeft: Dims.spacingML,
        marginRight: Dims.spacingL,
        resizeMode: 'contain'
    },
    levelContent: {
        flex: 1,
        justifyContent: 'center',
    },
    levelText: {
        fontSize: Dims.textSizeL,
        color: Colors.dark,
        marginBottom: Dims.spacingSM,
    },
    levelDetail: {
        fontSize: Dims.textSizeS,
        color: Colors.lightHover,
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
