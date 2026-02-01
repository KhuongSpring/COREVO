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
 * Training Setup - Step 7: Equipment Selection
 * Converted from Flutter training_equipment_selection_widget.dart
 * NOTE: This is a multi-select screen unlike previous single-select screens
 */
export default function EquipmentSelectionScreen() {
    const router = useRouter();
    const [selectedIndexes, setSelectedIndexes] = useState<number[]>([]);

    const equipments = [
        AppStrings.equipmentNone,
        AppStrings.equipmentYogaMat,
        AppStrings.equipmentTreadmill,
        AppStrings.equipmentResistanceBand,
        AppStrings.equipmentFullGym,
        AppStrings.equipmentPullUpBar,
        AppStrings.equipmentDips,
    ];

    const handleEquipmentPress = (index: number) => {
        if (selectedIndexes.includes(index)) {
            setSelectedIndexes(selectedIndexes.filter(i => i !== index));
        } else {
            setSelectedIndexes([...selectedIndexes, index]);
        }
    };

    const handleContinue = () => {
        if (selectedIndexes.length === 0) return;

        // TODO: Send equipment selections to API
        // TODO: Navigate to home/main app
        router.replace('/welcome-3' as any);
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
                            <View style={[styles.progressBarFill, { width: '100%' }]} />
                        </View>
                    </View>
                </View>

                {/* Title Header */}
                <View style={styles.titleContainer}>
                    <View style={styles.titleAccent} />
                    <Text style={styles.titleText}>
                        {AppStrings.equipmentSelectionTitle}
                    </Text>
                </View>

                {/* Scrollable Equipment List */}
                <ScrollView
                    style={styles.scrollView}
                    contentContainerStyle={styles.scrollContent}
                    showsVerticalScrollIndicator={false}
                >
                    {equipments.map((equipment, index) => (
                        <TouchableOpacity
                            key={index}
                            style={[
                                styles.equipmentCard,
                                selectedIndexes.includes(index) && styles.equipmentCardSelected,
                            ]}
                            onPress={() => handleEquipmentPress(index)}
                        >
                            <Text style={[
                                styles.equipmentText,
                                selectedIndexes.includes(index) && styles.equipmentTextSelected,
                            ]}>
                                {equipment}
                            </Text>
                            <Image
                                source={selectedIndexes.includes(index) ? AppAssets.tickActive : AppAssets.tickNonActive}
                                style={styles.tickIcon}
                            />
                        </TouchableOpacity>
                    ))}
                </ScrollView>

                {/* Gradient Overlay */}
                <LinearGradient
                    colors={['rgba(255, 255, 255, 0)', Colors.wWhite]}
                    locations={[0.0, 0.2]}
                    style={styles.gradientOverlay}
                    pointerEvents="none"
                />

                {/* Continue Button */}
                <View style={styles.buttonContainer}>
                    <TouchableOpacity
                        style={styles.continueButton}
                        onPress={handleContinue}
                        disabled={selectedIndexes.length === 0}
                    >
                        <Text style={styles.continueButtonText}>
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
    equipmentCard: {
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
    equipmentCardSelected: {
        backgroundColor: Colors.bLightHover,
        borderWidth: 2,
        borderColor: Colors.bNormal,
    },
    equipmentText: {
        flex: 1,
        fontSize: Dims.textSizeL,
        color: Colors.darkActive,
        fontWeight: '500',
        marginLeft: Dims.spacingML,
    },
    equipmentTextSelected: {
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
    continueButtonText: {
        fontSize: Dims.textSizeL,
        color: Colors.wWhite,
    },
});
