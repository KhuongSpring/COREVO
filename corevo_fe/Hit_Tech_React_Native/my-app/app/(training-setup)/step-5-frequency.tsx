import React, { useState } from 'react';
import {
    View,
    Text,
    StyleSheet,
    TouchableOpacity,
    ImageBackground,
    Image,
    Animated
} from 'react-native';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { LinearGradient } from 'expo-linear-gradient';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { AppAssets } from '@/constants/AppAssets';
import { AppStrings } from '@/constants/AppStrings';

/**
 * Training Setup - Step 5: Frequency Selection
 * Converted from Flutter training_frequency_selection_widget.dart
 */
export default function FrequencySelectionScreen() {
    const router = useRouter();
    const [selectedIndex, setSelectedIndex] = useState(0);

    const frequencies = ['1', '2', '3', '4', '5+'];
    const descriptions = [
        AppStrings.frequencyDescription1,
        AppStrings.frequencyDescription2,
        AppStrings.frequencyDescription3,
        AppStrings.frequencyDescription4,
        AppStrings.frequencyDescription5,
    ];
    const frequencyImages = [
        AppAssets.frequency1,
        AppAssets.frequency2,
        AppAssets.frequency3,
        AppAssets.frequency4,
        AppAssets.frequency5,
    ];

    const handleContinue = () => {
        // TODO: Send frequency to API
        // TODO: Navigate to next step
        router.push('/(training-setup)/step-6-location' as any);
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
                            <View style={[styles.progressBarFill, { width: `${(5 / 7) * 100}%` }]} />
                        </View>
                    </View>
                </View>

                {/* Title Header */}
                <View style={styles.titleContainer}>
                    <View style={styles.titleAccent} />
                    <Text style={styles.titleText}>
                        {AppStrings.frequencySelectionTitle}
                    </Text>
                </View>

                {/* Content Area */}
                <View style={styles.contentContainer}>
                    {/* Frequency Image */}
                    <Image
                        source={frequencyImages[selectedIndex]}
                        style={styles.frequencyImage}
                        resizeMode="contain"
                    />

                    {/* Frequency Text */}
                    <Text style={styles.frequencyText}>
                        {frequencies[selectedIndex]} {AppStrings.frequencySessionsPerWeek}
                    </Text>

                    {/* Description */}
                    <Text style={styles.descriptionText}>
                        {descriptions[selectedIndex]}
                    </Text>

                    {/* Circular Selector */}
                    <View style={styles.selectorContainer}>
                        {frequencies.map((_, index) => {
                            const isSelected = index === selectedIndex;
                            return (
                                <TouchableOpacity
                                    key={index}
                                    onPress={() => setSelectedIndex(index)}
                                    activeOpacity={0.9}
                                    hitSlop={{ top: 20, bottom: 20, left: 10, right: 10 }}
                                    style={styles.dotButton}
                                >
                                    {isSelected ? (
                                        // Render Nút Tròn Trắng (Thumb) khi Active
                                        <View style={styles.activeThumb}>
                                            <View style={styles.activeThumbDot} />
                                        </View>
                                    ) : (
                                        // Render Chấm Xanh nhỏ khi Inactive
                                        <View style={styles.inactiveDot} />
                                    )}
                                </TouchableOpacity>
                            );
                        })}
                    </View>
                </View>

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
                        style={styles.continueButton}
                        onPress={handleContinue}
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
    contentContainer: {
        flex: 1,
        alignItems: 'center',
        marginTop: Dims.spacingXXL,
        paddingHorizontal: Dims.paddingL,
    },
    frequencyImage: {
        width: Dims.size120,
        height: Dims.size120,
        marginBottom: Dims.spacingL,
    },
    frequencyText: {
        fontSize: Dims.textSizeL,
        fontWeight: 'bold',
        color: Colors.dark,
        marginBottom: Dims.spacingML,
    },
    descriptionText: {
        fontSize: Dims.textSizeM,
        color: Colors.dark,
        textAlign: 'center',
        marginBottom: Dims.spacingGiant,
        paddingHorizontal: Dims.paddingL,
    },
    selectorContainer: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        backgroundColor: Colors.wNormalNonActive,
        height: Dims.size48, // Chiều cao của thanh track
        borderRadius: Dims.borderRadiusLarge, // Bo tròn 2 đầu
        paddingHorizontal: Dims.paddingS, // Padding để các chấm không dính sát mép
        position: 'relative',
    },
    dotButton: {
        width: Dims.size40,
        height: Dims.size40,
        justifyContent: 'center',
        alignItems: 'center',
        marginHorizontal: Dims.spacingS,
        // zIndex cao để nút active nổi lên
        zIndex: 1,
    },
    // Chấm xanh nhỏ (khi chưa chọn)
    inactiveDot: {
        width: Dims.size16,
        height: Dims.size16,
        borderRadius: Dims.borderRadiusSmall,
        backgroundColor: Colors.bLightActive2, // Màu xanh nhạt hơn active một chút
    },
    // Nút tròn trắng to (Thumb - khi chọn)
    activeThumb: {
        width: Dims.size40, // Kích thước to hơn chiều cao track một chút để nổi bật
        height: Dims.size40,
        borderRadius: Dims.borderRadiusLarge,
        backgroundColor: Colors.wWhite,
        justifyContent: 'center',
        alignItems: 'center',

        // Đổ bóng (Shadow)
        elevation: 6, // Android
        shadowColor: '#000', // iOS
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.2,
        shadowRadius: 3,
    },
    // Chấm xanh đậm bên trong Thumb
    activeThumbDot: {
        width: Dims.iconSizeL,
        height: Dims.iconSizeL,
        borderRadius: Dims.borderRadiusSmall,
        backgroundColor: Colors.bNormal, // Màu xanh chủ đạo
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
