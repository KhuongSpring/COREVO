import React, { useState } from 'react';
import {
    View,
    Text,
    StyleSheet,
    ScrollView,
    TouchableOpacity,
    ImageBackground,
    Alert
} from 'react-native';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { AppAssets } from '@/constants/AppAssets';
import AvatarUploader from '@/components/settings/AvatarUploader';
import { AppStrings } from '@/constants/AppStrings';
import { useTheme } from '@/hooks/useTheme';
// import { userService } from '@/services/api/userService';

// Mock data - combining user and health data
const MOCK_USER = {
    username: 'nguyenvana',
    email: 'nguyenvana@example.com',
    firstName: 'Nguyễn',
    lastName: 'Văn A',
    linkAvatar: AppAssets.defaultImage,
};

const MOCK_HEALTH = {
    gender: 'MALE',
    age: 28,
    height: 175,
    weight: 70,
    activityLevel: 'MODERATELY_ACTIVE',
};

/**
 * Health Information Screen - Matching Flutter design
 * Displays user's health profile information with mock data
 */
export default function HealthInformationScreen() {
    const router = useRouter();
    const [profile] = useState(MOCK_USER);
    const [health] = useState(MOCK_HEALTH);
    const { colors, mode } = useTheme();

    const getActivityLevelText = (level: string) => {
        const levels: Record<string, string> = {
            SEDENTARY: 'Ít vận động',
            LIGHTLY_ACTIVE: 'Hoạt động nhẹ',
            MODERATELY_ACTIVE: 'Hoạt động vừa phải',
            VERY_ACTIVE: 'Hoạt động nhiều',
            SUPER_ACTIVE: 'Rất năng động',
        };
        return levels[level] || level;
    };

    const getGenderText = (gender: string) => {
        if (gender === 'MALE') return 'Nam';
        if (gender === 'FEMALE') return 'Nữ';
        return gender;
    };

    const handleAvatarUpload = async (imageUri: string) => {
        Alert.alert('Thông báo', 'Chức năng đang sử dụng dữ liệu mẫu');
    };

    const renderInfoItem = (label: string, value: string) => {
        return (
            <TouchableOpacity
                style={styles.infoItem}
                disabled={true}
                activeOpacity={0.7}
            >
                <Text style={[styles.label, { color: colors.text.primary }]}>{label}</Text>
                <Text style={[styles.value, { color: colors.brand.primary }]}>{value}</Text>
            </TouchableOpacity>
        );
    };

    const fullName = `${profile.firstName} ${profile.lastName}`;

    return (
        <View style={styles.container}>
            <ImageBackground
                source={mode === 'dark' ? AppAssets.mainBackgroundDark : AppAssets.mainBackground}
                style={styles.backgroundImage}
                resizeMode="cover"
            >
                <View style={styles.content}>
                    {/* Header with Back Button + Avatar */}
                    <View style={styles.headerContainer}>
                        <TouchableOpacity
                            style={styles.backButton}
                            onPress={() => router.back()}
                        >
                            <Ionicons name="chevron-back" size={Dims.iconSizeXXL} color={Colors.bNormal} />
                        </TouchableOpacity>

                        <View style={styles.avatarWrapper}>
                            <AvatarUploader
                                avatarUrl={profile.linkAvatar}
                                onUpload={handleAvatarUpload}
                                size={Dims.size80}
                                isHaveCamera={false}
                            />
                        </View>
                    </View>

                    {/* User Info */}
                    <View style={styles.userInfo}>
                        <Text style={[styles.fullName, { color: colors.text.primary }]}>{fullName}</Text>
                        <Text style={[styles.email, { color: colors.text.secondary }]}>{profile.email}</Text>
                    </View>

                    {/* Health Information List */}
                    <ScrollView
                        style={styles.scrollView}
                        contentContainerStyle={styles.scrollContent}
                        showsVerticalScrollIndicator={false}
                    >
                        <View style={[styles.section, { backgroundColor: colors.background.primary }]}>
                            {renderInfoItem(AppStrings.height, `${health.height} cm`)}
                            <View style={[styles.divider, { backgroundColor: colors.interactive.disabled }]} />
                            {renderInfoItem(AppStrings.weight, `${health.weight} kg`)}
                            <View style={[styles.divider, { backgroundColor: colors.interactive.disabled }]} />
                            {renderInfoItem(AppStrings.age, health.age.toString())}
                            <View style={[styles.divider, { backgroundColor: colors.interactive.disabled }]} />
                            {renderInfoItem(AppStrings.gender, getGenderText(health.gender))}
                            <View style={[styles.divider, { backgroundColor: colors.interactive.disabled }]} />
                            {renderInfoItem(AppStrings.activityLevel, getActivityLevelText(health.activityLevel))}
                        </View>
                    </ScrollView>
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
    content: {
        flex: 1,
        paddingTop: Dims.spacingXXXL,
    },
    headerContainer: {
        height: Dims.size112,
        position: 'relative',
    },
    backButton: {
        position: 'absolute',
        left: Dims.spacingML,
        top: 0,
        bottom: Dims.size72,
        justifyContent: 'center',
    },
    avatarWrapper: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
    },
    userInfo: {
        alignItems: 'center',
    },
    fullName: {
        fontWeight: 'bold',
        fontSize: Dims.textSizeM,
    },
    email: {
        fontSize: Dims.textSizeS,
        marginTop: Dims.size4,
    },
    scrollView: {
        flex: 1,
        marginTop: Dims.spacingXXXL,
    },
    scrollContent: {
        paddingHorizontal: Dims.paddingL,
    },
    section: {
        borderRadius: Dims.borderRadius,
        marginBottom: Dims.spacingXL,
    },
    infoItem: {
        paddingVertical: Dims.paddingM,
        paddingHorizontal: Dims.paddingM,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
    },
    label: {
        fontSize: Dims.textSizeS,
        flex: 1,
    },
    value: {
        fontSize: Dims.textSizeS,
        fontWeight: '500',
    },
    divider: {
        height: 1,
    },
});
