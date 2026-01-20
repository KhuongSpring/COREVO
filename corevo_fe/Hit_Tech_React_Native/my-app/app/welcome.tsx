import React from 'react';
import { View, Text, Image, StyleSheet, ScrollView } from 'react-native';
import { useRouter } from 'expo-router';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import SafeAreaWrapper from '@/components/common/SafeAreaWrapper';
import CustomButton from '@/components/auth/CustomButton';
import { AppAssets } from '@/constants/AppAssets';
import { AppStrings } from '@/constants/AppStrings';

/**
 * Welcome Screen
 * Introduction to Corevo assistant
 */
export default function WelcomeScreen() {
    const router = useRouter();

    const handleGetStarted = () => {
        // Navigate to Training Setup flow
        router.push('/welcome-1' as any);
    };

    return (
        <SafeAreaWrapper backgroundColor={Colors.wWhite}>
            <View style={styles.container}>
                <ScrollView
                    contentContainerStyle={styles.scrollContent}
                    showsVerticalScrollIndicator={false}
                >
                    {/* Welcome Image */}
                    <View style={styles.imageContainer}>
                        <View style={styles.imagePlaceholder}>
                            <Image source={AppAssets.welcomeHandImage} style={styles.imageEmoji} />
                        </View>
                    </View>

                    {/* Welcome Text */}
                    <View style={styles.textContainer}>
                        <Text style={styles.title}>{AppStrings.welcomeTitle}</Text>

                        <Text style={styles.description}>
                            Tôi là <Text style={styles.brandName}>Corevo</Text> - Trợ lý tập luyện của bạn
                        </Text>

                        <Text style={styles.subtitle}>
                            Sau đây là một số câu hỏi để <Text style={styles.brandName}>cá nhân hóa</Text> kế hoạch tập luyện dành cho bạn.
                        </Text>
                    </View>
                </ScrollView>

                {/* Bottom Button */}
                <View style={styles.buttonContainer}>
                    <CustomButton
                        title="Bắt đầu"
                        onPress={handleGetStarted}
                        variant="primary"
                    />
                </View>
            </View>
        </SafeAreaWrapper>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    scrollContent: {
        flexGrow: 1,
        padding: Dims.paddingL,
        paddingTop: Dims.spacingGiant,
    },
    imageContainer: {
        alignItems: 'center',
        marginBottom: Dims.spacingXL,
        marginTop: Dims.spacingGiant,
    },
    imagePlaceholder: {
        width: Dims.size152,
        height: Dims.size152,
        borderRadius: Dims.size152 / 2,
        alignItems: 'center',
        justifyContent: 'center',
    },
    imageEmoji: {
        width: Dims.size152,
        height: Dims.size152,
    },
    textContainer: {
        alignItems: 'flex-start',
    },
    title: {
        fontSize: Dims.textSizeXXXL,
        fontWeight: 'bold',
        color: Colors.dark,
        marginBottom: Dims.spacingM,
    },
    description: {
        fontSize: Dims.textSizeL,
        color: Colors.dark,
        marginBottom: Dims.spacingL,
    },
    brandName: {
        color: Colors.bNormal,
        fontWeight: '600',
    },
    subtitle: {
        fontSize: Dims.textSizeL,
        color: Colors.dark,
        lineHeight: Dims.textSizeL * 1.5,
    },
    highlight: {
        color: Colors.bNormal,
        fontWeight: '600',
    },
    buttonContainer: {
        padding: Dims.paddingL,
    },
});
