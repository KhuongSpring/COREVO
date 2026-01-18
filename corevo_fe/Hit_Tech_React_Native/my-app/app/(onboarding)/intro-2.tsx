import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { useRouter } from 'expo-router';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import SafeAreaWrapper from '@/components/common/SafeAreaWrapper';
import CustomButton from '@/components/auth/CustomButton';
import PageIndicator from '@/components/common/PageIndicator';
import { setSeenOnboarding } from '@/services/storage';

/**
 * Onboarding Screen 2
 * Track Progress
 */
export default function Intro2Screen() {
    const router = useRouter();

    const handleNext = () => {
        router.push('/(onboarding)/intro-3' as any);
    };

    const handleSkip = async () => {
        await setSeenOnboarding(true);
        router.replace('/(auth)/login' as any);
    };

    return (
        <SafeAreaWrapper backgroundColor={Colors.wWhite}>
            <View style={styles.container}>
                {/* Skip Button */}
                <View style={styles.skipContainer}>
                    <CustomButton
                        title="Bỏ qua"
                        onPress={handleSkip}
                        variant="outline"
                        style={styles.skipButton}
                        textStyle={styles.skipText}
                    />
                </View>

                {/* Content */}
                <View style={styles.content}>
                    {/* Image Placeholder */}
                    <View style={styles.imageContainer}>
                        <View style={styles.imagePlaceholder}>
                            <Text style={styles.imageEmoji}>📊</Text>
                        </View>
                    </View>

                    {/* Text */}
                    <View style={styles.textContainer}>
                        <Text style={styles.title}>Theo dõi tiến độ{'\n'}của bạn</Text>
                        <Text style={styles.description}>
                            Ghi nhận sự tiến bộ của bạn và đạt được mục tiêu tập luyện
                        </Text>
                    </View>
                </View>

                {/* Bottom Section */}
                <View style={styles.bottomContainer}>
                    <PageIndicator count={3} activeIndex={1} />

                    <CustomButton
                        title="Tiếp theo"
                        onPress={handleNext}
                        style={styles.nextButton}
                    />
                </View>
            </View>
        </SafeAreaWrapper>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        paddingHorizontal: Dims.paddingL,
    },
    skipContainer: {
        paddingTop: Dims.paddingL,
        alignItems: 'flex-end',
    },
    skipButton: {
        paddingVertical: Dims.paddingS,
        paddingHorizontal: Dims.paddingM,
        minHeight: 0,
    },
    skipText: {
        fontSize: Dims.textSizeS,
    },
    content: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
    },
    imageContainer: {
        marginBottom: Dims.spacingXXL,
    },
    imagePlaceholder: {
        width: Dims.size280,
        height: Dims.size280,
        backgroundColor: Colors.bLight,
        borderRadius: Dims.size140,
        alignItems: 'center',
        justifyContent: 'center',
    },
    imageEmoji: {
        fontSize: 120,
    },
    textContainer: {
        alignItems: 'center',
        paddingHorizontal: Dims.paddingL,
    },
    title: {
        fontSize: Dims.textSizeXXL,
        fontWeight: 'bold',
        color: Colors.dark,
        textAlign: 'center',
        marginBottom: Dims.spacingL,
    },
    description: {
        fontSize: Dims.textSizeM,
        color: Colors.lighter,
        textAlign: 'center',
        lineHeight: Dims.textSizeM * 1.6,
    },
    bottomContainer: {
        paddingBottom: Dims.spacingXXL,
        gap: Dims.spacingXL,
    },
    nextButton: {
        marginTop: Dims.spacingM,
    },
});
