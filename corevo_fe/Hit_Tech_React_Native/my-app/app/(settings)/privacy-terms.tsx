import React, { useState } from 'react';
import {
    View,
    Text,
    StyleSheet,
    ScrollView,
    TouchableOpacity,
    ImageBackground,
} from 'react-native';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { AppAssets } from '@/constants/AppAssets';
import SafeAreaWrapper from '@/components/common/SafeAreaWrapper';
// import { authService } from '@/services/authService';

// Mock privacy and terms content
const MOCK_CONTENT = `CHÍNH SÁCH BẢO MẬT

Cập nhật lần cuối: 20/01/2026

1. Thu thập thông tin
Chúng tôi thu thập các thông tin sau từ người dùng:
- Thông tin cá nhân: họ tên, email, số điện thoại
- Thông tin sức khỏe: chiều cao, cân nặng, tuổi, giới tính
- Thông tin tập luyện: mục tiêu, kế hoạch tập luyện

2. Sử dụng thông tin
Thông tin được sử dụng để:
- Cung cấp dịch vụ tập luyện cá nhân hóa
- Theo dõi tiến trình và đưa ra khuyến nghị
- Cải thiện trải nghiệm người dùng

3. Bảo mật thông tin
Chúng tôi cam kết:
- Mã hóa dữ liệu nhạy cảm
- Không chia sẻ thông tin với bên thứ ba
- Tuân thủ các quy định về bảo vệ dữ liệu cá nhân


ĐIỀU KHOẢN SỬ DỤNG

1. Chấp nhận điều khoản
Bằng việc sử dụng ứng dụng, bạn đồng ý với các điều khoản sau:

2. Trách nhiệm người dùng
- Cung cấp thông tin chính xác
- Không chia sẻ tài khoản
- Tuân thủ hướng dẫn tập luyện an toàn

3. Quyền lợi người dùng
- Truy cập và chỉnh sửa thông tin cá nhân
- Xóa tài khoản bất cứ lúc nào
- Nhận hỗ trợ từ đội ngũ chăm sóc khách hàng

4. Giới hạn trách nhiệm
Chúng tôi không chịu trách nhiệm về:
- Chấn thương do tập luyện không đúng cách
- Vấn đề sức khỏe từ các tình trạng có sẵn
- Thiết bị hoặc kết nối internet

Liên hệ: support@hittech.com`;

/**
 * Privacy and Terms Screen
 * Displays privacy policy and terms of service with mock content
 */
export default function PrivacyTermsScreen() {
    const router = useRouter();
    const [content] = useState(MOCK_CONTENT);

    // Commented out API call
    // useEffect(() => {
    //     loadPrivacyAndTerms();
    // }, []);

    // const loadPrivacyAndTerms = async () => {
    //     try {
    //         let combinedContent = '';
    //         const privacyResponse = await authService.getPrivacy();
    //         if (privacyResponse.status === 'SUCCESS' && privacyResponse.data?.content) {
    //             combinedContent += privacyResponse.data.content + '\n\n';
    //         }
    //         const termsResponse = await authService.getTerms();
    //         if (termsResponse.status === 'SUCCESS' && termsResponse.data?.content) {
    //             combinedContent += termsResponse.data.content;
    //         }
    //         setContent(combinedContent || 'Không có nội dung');
    //     } catch (error) {
    //         console.error('Error loading privacy and terms:', error);
    //     }
    // };

    return (
        <SafeAreaWrapper backgroundColor={Colors.bLight} edges={['top']}>
            <ImageBackground
                source={AppAssets.mainBackground}
                style={styles.backgroundImage}
                resizeMode="cover"
            >
                <View style={styles.container}>
                    {/* Header */}
                    <View style={styles.header}>
                        <TouchableOpacity
                            style={styles.backButton}
                            onPress={() => router.back()}
                        >
                            <Ionicons name="chevron-back" size={28} color={Colors.bNormal} />
                        </TouchableOpacity>

                        <Text style={styles.headerTitle}>Chính sách & Điều khoản</Text>
                        <View style={styles.headerSpacer} />
                    </View>

                    {/* Content */}
                    <ScrollView
                        style={styles.scrollView}
                        contentContainerStyle={styles.scrollContent}
                        showsVerticalScrollIndicator={false}
                    >
                        <View style={styles.contentCard}>
                            <Text style={styles.contentText}>{content}</Text>
                        </View>
                    </ScrollView>
                </View>
            </ImageBackground>
        </SafeAreaWrapper>
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
    },
    header: {
        paddingTop: Dims.spacingXL,
        paddingBottom: Dims.spacingM,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        paddingHorizontal: Dims.paddingL,
    },
    backButton: {
        width: Dims.size40,
        height: Dims.size40,
        justifyContent: 'center',
        alignItems: 'center',
    },
    headerTitle: {
        fontSize: Dims.textSizeL,
        fontWeight: 'bold',
        color: Colors.dark,
        flex: 1,
        textAlign: 'center',
    },
    headerSpacer: {
        width: Dims.size40,
    },
    scrollView: {
        flex: 1,
    },
    scrollContent: {
        paddingHorizontal: Dims.paddingL,
        paddingBottom: Dims.spacingXXL,
    },
    contentCard: {
        backgroundColor: Colors.wWhite,
        borderRadius: Dims.borderRadiusSmall,
        padding: Dims.paddingL,
        marginBottom: Dims.spacingXXL,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.1,
        shadowRadius: 4,
        elevation: 2,
    },
    contentText: {
        fontSize: Dims.textSizeM,
        color: Colors.dark,
        lineHeight: Dims.textSizeM * 1.6,
    },
});
