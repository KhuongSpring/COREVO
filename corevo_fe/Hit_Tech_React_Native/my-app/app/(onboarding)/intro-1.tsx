import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { useRouter } from 'expo-router';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import SafeAreaWrapper from '@/components/common/SafeAreaWrapper';
import CustomButton from '@/components/auth/CustomButton';
import PageIndicator from '@/components/common/PageIndicator';

/**
 * Onboarding Screen 1
 * Focus on Goals
 */
export default function Intro1Screen() {
    const router = useRouter();

    const handleNext = () => {
        router.push('/(onboarding)/intro-2' as any);
    };

    return (
        <SafeAreaWrapper backgroundColor={Colors.wWhite}>
            <View style={styles.container}>
                {/* Content */}
                <View style={styles.content}>
                    {/* Image Placeholder */}
                    <View style={styles.imageContainer}>
                        <View style={styles.imagePlaceholder}>
                            <Text style={styles.imageEmoji}>🎯</Text>
                        </View>
                    </View>

                    {/* Text */}
                    <View style={styles.textContainer}>
                        <Text style={styles.title}>Tập trung vào{'\n'}mục tiêu</Text>
                        <Text style={styles.description}>
                            Cá nhân hóa lộ trình tập luyện phù hợp với thể trạng và mục tiêu của bạn, giúp bạn duy trì động lực và tiến bộ mỗi ngày.
                        </Text>
                    </View>
                </View>

                {/* Bottom Section */}
                <View style={styles.bottomContainer}>
                    <PageIndicator count={3} activeIndex={0} />

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