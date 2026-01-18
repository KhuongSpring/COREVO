import React from 'react';
import { View, Text, StyleSheet, ImageBackground, TouchableOpacity, StatusBar, Image, Dimensions } from 'react-native';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import PageIndicator from '@/components/common/PageIndicator';

// 1. Lấy chiều rộng màn hình hiện tại
const { width: SCREEN_WIDTH } = Dimensions.get('window');

// 2. Import ảnh
const waveImageSource = require('@/assets/image_utils/intro_image_util.png');

// 3. Tính toán tỷ lệ ảnh (Aspect Ratio)
// Image.resolveAssetSource giúp lấy kích thước thật của file ảnh local
const { width: imgOriginalWidth, height: imgOriginalHeight } = Image.resolveAssetSource(waveImageSource);

// 4. Tính chiều cao hiển thị dựa trên màn hình:
// (Chiều rộng màn hình / Chiều rộng ảnh gốc) * Chiều cao ảnh gốc
const calculatedHeight = (SCREEN_WIDTH / imgOriginalWidth) * imgOriginalHeight;

export default function Intro1Screen() {
    const router = useRouter();

    const handleNext = () => {
        router.push('/(onboarding)/intro-2' as any);
    };

    return (
        <View style={styles.container}>
            <StatusBar barStyle="light-content" translucent backgroundColor="transparent" />

            <ImageBackground
                source={require('@/assets/images/intro_1_image.png')}
                style={styles.backgroundImage}
            >
                <View style={styles.spacer} />

                {/* Container chính của phần dưới */}
                <View style={styles.bottomSectionWrapper}>

                    {/* --- PHẦN NỘI DUNG - DÙNG ẢNH LÀM BACKGROUND --- */}
                    <ImageBackground
                        source={waveImageSource}
                        style={styles.contentContainer}
                        resizeMode="cover"
                    >
                        <Text style={styles.title}>Tập trung vào mục tiêu</Text>

                        <Text style={styles.description}>
                            Cá nhân hóa lộ trình tập luyện phù hợp với thể trạng và mục tiêu của bạn, giúp bạn duy trì động lực và tiến bộ mỗi ngày.
                        </Text>

                        <View style={styles.indicatorContainer}>
                            <PageIndicator count={3} activeIndex={0} activeColor={Colors.wWhite} />
                        </View>

                        <TouchableOpacity
                            style={styles.nextButton}
                            onPress={handleNext}
                            activeOpacity={0.8}
                        >
                            <Text style={styles.nextButtonText}>Tiếp theo</Text>
                            <Ionicons name="chevron-forward" size={20} color={Colors.bNormal} />
                        </TouchableOpacity>
                    </ImageBackground>
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
        width: '100%',
        height: '100%',
    },
    spacer: {
        flex: 1,
    },
    // Wrapper này chỉ đóng vai trò neo vị trí ở đáy
    bottomSectionWrapper: {
        width: '100%',
        justifyContent: 'flex-end',
    },
    // Phần nội dung - dùng ảnh làm background
    contentContainer: {
        alignItems: 'center',
        paddingHorizontal: Dims.paddingL,
        paddingBottom: Dims.spacingXXL + 20,
        paddingTop: Dims.spacingXL,
    },
    title: {
        fontSize: Dims.textSizeXXL,
        fontWeight: 'bold',
        color: Colors.wWhite,
        textAlign: 'center',
        marginBottom: Dims.spacingM,
    },
    description: {
        fontSize: Dims.textSizeM,
        color: 'rgba(255, 255, 255, 0.9)',
        textAlign: 'center',
        lineHeight: 24,
        marginBottom: Dims.spacingXL,
    },
    indicatorContainer: {
        marginBottom: Dims.spacingL,
    },
    nextButton: {
        flexDirection: 'row',
        backgroundColor: Colors.wWhite,
        paddingVertical: 12,
        paddingHorizontal: 32,
        borderRadius: 30,
        alignItems: 'center',
        justifyContent: 'center',
        gap: 8,
    },
    nextButtonText: {
        color: Colors.bNormal,
        fontSize: Dims.textSizeM,
        fontWeight: 'bold',
    },
});