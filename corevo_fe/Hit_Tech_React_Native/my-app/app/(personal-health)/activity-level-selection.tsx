import React, { useState } from 'react';
import { View, Text, StyleSheet, ImageBackground, TouchableOpacity, Animated, Image, ImageSourcePropType } from 'react-native';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { AppStrings } from '@/constants/AppStrings';
import { AppAssets } from '@/constants/AppAssets';

type ActivityLevel = {
    level: string;
    title: string;
    description: string;
    icon: keyof typeof Ionicons.glyphMap;
    apiValue: string;
    image: ImageSourcePropType;
};

const activityLevels: ActivityLevel[] = [
    {
        level: 'LEVEL_1',
        title: AppStrings.activityLevelSedentary,
        description: AppStrings.activityLevelSedentaryDescription,
        icon: 'bed-outline',
        apiValue: AppStrings.level1,
        image: (AppAssets.imageActivityLevelSedentary),
    },
    {
        level: 'LEVEL_2',
        title: AppStrings.activityLevelLight,
        description: AppStrings.activityLevelLightDescription,
        icon: 'walk-outline',
        apiValue: AppStrings.level2,
        image: (AppAssets.imageActivityLevelLight),
    },
    {
        level: 'LEVEL_3',
        title: AppStrings.activityLevelModerate,
        description: AppStrings.activityLevelModerateDescription,
        icon: 'bicycle-outline',
        apiValue: AppStrings.level3,
        image: (AppAssets.imageActivityLevelModerate),
    },
    {
        level: 'LEVEL_4',
        title: AppStrings.activityLevelActive,
        description: AppStrings.activityLevelActiveDescription,
        icon: 'fitness-outline',
        apiValue: AppStrings.level4,
        image: (AppAssets.imageActivityLevelActive),
    },
    {
        level: 'LEVEL_5',
        title: AppStrings.activityLevelSuperActive,
        description: AppStrings.activityLevelSuperActiveDescription,
        icon: 'flame-outline',
        apiValue: AppStrings.level5,
        image: (AppAssets.imageActivityLevelSuperActive),
    }
];

/**
 * Activity Level Selection Screen
 * Final step in personal health information collection
 * Allows user to select their daily activity level
 */
export default function ActivityLevelSelectionScreen() {
    const router = useRouter();
    const params = useLocalSearchParams();

    const [currentIndex, setCurrentIndex] = useState<number>(0);
    const [fadeAnim] = useState(new Animated.Value(1));

    const handleSliderChange = (index: number) => {
        if (index !== currentIndex) {
            // Fade out
            Animated.timing(fadeAnim, {
                toValue: 0,
                duration: 150,
                useNativeDriver: true,
            }).start(() => {
                setCurrentIndex(index);
                // Fade in
                Animated.timing(fadeAnim, {
                    toValue: 1,
                    duration: 150,
                    useNativeDriver: true,
                }).start();
            });
        }
    };

    const handleContinue = async () => {
        // Navigate to next screen or complete personal health flow
        // In Flutter this calls API and then navigates to training flow or home
        const selectedLevel = activityLevels[currentIndex].apiValue;

        // TODO: Call API to save personal health data with all collected info
        // const response = await savePersonalHealth({
        //     gender: params.gender,
        //     age: params.age,
        //     height: params.height,
        //     weight: params.weight,
        //     activityLevel: selectedLevel
        // });

        // For now, navigate to main app (tabs)
        router.replace('/welcome-2' as any);
    };

    const currentActivity = activityLevels[currentIndex];

    return (
        <ImageBackground
            source={AppAssets.mainBackground}
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
                            <View style={[styles.progressFill, { width: '100%' }]} />
                        </View>
                    </View>
                </View>

                {/* Info Box */}
                <View style={styles.infoBox}>
                    <Text style={styles.infoTitle}>{AppStrings.activityLevelSelectionTitle}</Text>
                    <Text style={styles.infoDescription}>
                        {AppStrings.activityLevelSelectionDescription}
                    </Text>
                </View>

                {/* Activity Display */}
                <View style={styles.activityDisplay}>
                    <Animated.View style={[styles.activityContent, { opacity: fadeAnim }]}>
                        <View style={styles.iconContainer}>
                            <Image
                                source={currentActivity.image}
                                style={styles.activityImage}
                                resizeMode="contain"
                            />
                        </View>
                        <Text style={styles.activityDescription}>
                            {currentActivity.description}
                        </Text>
                    </Animated.View>
                </View>

                {/* Slider */}
                <View style={styles.sliderSection}>

                    {/* Thanh Track nền xám */}
                    <View style={styles.trackContainer}>
                        {activityLevels.map((_, index) => {
                            const isActive = index === currentIndex;
                            return (
                                <TouchableOpacity
                                    key={index}
                                    onPress={() => handleSliderChange(index)}
                                    activeOpacity={0.9}
                                    // HitSlop giúp dễ bấm vào chấm nhỏ hơn
                                    hitSlop={{ top: 20, bottom: 20, left: 10, right: 10 }}
                                    style={styles.touchArea}
                                >
                                    {isActive ? (
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

                    {/* Labels dưới thanh slider */}
                    <View style={styles.labelsContainer}>
                        <Text style={styles.labelText}>{AppStrings.activityLevelSedentary}</Text>
                        <Text style={styles.labelText}>{AppStrings.activityLevelSuperActive}</Text>
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

    // Activity Display
    activityDisplay: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
    },
    activityContent: {
        alignItems: 'center',
        paddingHorizontal: Dims.paddingM,
    },
    iconContainer: {
        width: Dims.size232,
        height: Dims.size232,
        justifyContent: 'center',
        alignItems: 'center',
        marginBottom: Dims.spacingL,
    },
    activityImage: {
        width: '100%',
        height: '100%',
    },
    activityDescription: {
        fontSize: Dims.textSizeS,
        color: Colors.dark,
        textAlign: 'center',
        fontWeight: '500',
        lineHeight: 20,
    },

    // Slider
    sliderSection: {
        marginBottom: Dims.spacingGiant,
        paddingHorizontal: Dims.spacingXS,
    },
    // Khung nền xám (Track)
    trackContainer: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        backgroundColor: Colors.wNormalNonActive,
        height: Dims.size48, // Chiều cao của thanh track
        borderRadius: Dims.borderRadiusLarge, // Bo tròn 2 đầu
        paddingHorizontal: Dims.paddingM, // Padding để các chấm không dính sát mép
        position: 'relative',
    },
    // Vùng bấm của mỗi điểm
    touchArea: {
        width: Dims.size40,
        height: Dims.size40,
        justifyContent: 'center',
        alignItems: 'center',
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
    // Text Labels dưới slider
    labelsContainer: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        marginTop: Dims.spacingS,
        paddingHorizontal: Dims.spacingS,
    },
    labelText: {
        fontSize: Dims.textSizeS,
        color: Colors.dark,
        fontWeight: '500',
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
