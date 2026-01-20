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
 * Onboarding Screen 3
 * Community & Support
 */
export default function Intro3Screen() {
    const router = useRouter();

    const handleGetStarted = async () => {
        await setSeenOnboarding(true);
        router.replace('/(auth)/login' as any);
    };

    return (
        <SafeAreaWrapper backgroundColor={Colors.wWhite}>
            <View style={styles.container}>
                {/* No Skip Button on last screen */}
                <View style={styles.skipContainer} />

                {/* Content */}
                <View style={styles.content}>
                    {/* Image Placeholder */}
                    <View style={styles.imageContainer}>
                        <View style={styles.imagePlaceholder}>
                            <Text style={styles.imageEmoji}>🚀</Text>
                        </View>
                    </View>

                    {/* Text */}
                    <View style={styles.textContainer}>
                        <Text style={styles.title}>Bắt đầu hành trình mới</Text>
                        <Text style={styles.description}>
                            Từ những bước khởi đầu hôm nay, bạn sẽ khám phá giới hạn của bản thân, chinh phục thể lực và đạt được phong cách sống năng động hơn.
                        </Text>
                    </View>
                </View>

                {/* Bottom Section */}
                <View style={styles.bottomContainer}>
                    <PageIndicator count={3} activeIndex={2} />

                    <CustomButton
                        title="Bắt đầu"
                        onPress={handleGetStarted}
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
        height: 50, // Same height as skip button for consistency
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
        borderRadius: Dims.size144,
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
