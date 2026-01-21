import React, { useState } from 'react';
import {
    View,
    Text,
    StyleSheet,
    ScrollView,
    TouchableOpacity,
    Alert,
    ImageBackground,
} from 'react-native';
import { useRouter } from 'expo-router';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { AppAssets } from '@/constants/AppAssets';
import { useAuthStore } from '@/store/authStore';
import { useUserStore } from '@/store/userStore';
import AvatarUploader from '@/components/settings/AvatarUploader';
import SettingItem from '@/components/settings/SettingItem';
import SectionTitle from '@/components/settings/SectionTitle';
import { AppStrings } from '@/constants/AppStrings';
// import { userService } from '@/services/api/userService';

// Mock data - default user profile
const MOCK_USER = {
    firstName: 'Nguyễn',
    lastName: 'Văn A',
    username: 'nguyenvana',
    email: 'nguyenvana@example.com',
    linkAvatar: AppAssets.defaultImage,
    phone: '0912345678',
    birth: '15/05/1995',
    nationality: 'Việt Nam',
};

/**
 * Settings Tab Screen - Matching Flutter design
 * User settings and preferences with mock data
 */
export default function SettingsScreen() {
    const router = useRouter();
    const { logout } = useAuthStore();
    const { clearUser } = useUserStore();

    const [profile] = useState(MOCK_USER);
    const [isDarkMode, setIsDarkMode] = useState(false);

    const handleAvatarUpload = async (imageUri: string) => {
        Alert.alert('Thông báo', 'Chức năng đang sử dụng dữ liệu mẫu');
    };

    const handleLogout = () => {
        Alert.alert(
            AppStrings.settingsLogout,
            AppStrings.settingsLogoutConfirm,
            [
                { text: AppStrings.cancel, style: 'cancel' },
                {
                    text: AppStrings.settingsLogout,
                    style: 'destructive',
                    onPress: async () => {
                        await logout();
                        clearUser();
                        router.replace('/(auth)/login' as any);
                    },
                },
            ]
        );
    };

    const handlePersonalInfo = () => {
        router.push('/(settings)/personal-information' as any);
    };

    const handleHealthInfo = () => {
        router.push('/(settings)/health-information' as any);
    };

    const handlePrivacyTerms = () => {
        router.push('/(settings)/privacy-terms' as any);
    };

    const handleComingSoon = (feature: string) => {
        Alert.alert('Sắp ra mắt', `Tính năng ${feature} đang được phát triển`);
    };

    const fullName = `${profile.firstName} ${profile.lastName}`;

    return (
        <View style={styles.container}>
            <ImageBackground
                source={AppAssets.mainBackground}
                style={styles.backgroundImage}
                resizeMode="cover"
            >
                <ScrollView
                    style={styles.scrollView}
                    contentContainerStyle={styles.scrollContent}
                    showsVerticalScrollIndicator={false}
                >
                    {/* Avatar Section */}
                    <View style={styles.avatarSection}>
                        <AvatarUploader
                            avatarUrl={profile.linkAvatar}
                            onUpload={handleAvatarUpload}
                            size={Dims.size80}
                        />

                        <Text style={styles.fullName}>{fullName}</Text>
                        <Text style={styles.username}>{profile.username}</Text>
                    </View>

                    {/* User Profile Section */}
                    <SectionTitle title={AppStrings.settingsUserProfile} />
                    <View style={styles.section}>
                        <SettingItem
                            icon={AppAssets.personalInformationIcon}
                            title={AppStrings.settingsUserInfor}
                            onPress={handlePersonalInfo}
                        />
                        <SettingItem
                            icon={AppAssets.healthInformationIcon}
                            title={AppStrings.settingsUserHealthInfor}
                            onPress={handleHealthInfo}
                        />
                    </View>

                    {/* General Settings Section */}
                    <SectionTitle title={AppStrings.settingsOverall} />
                    <View style={styles.section}>
                        <SettingItem
                            icon={AppAssets.themeIcon}
                            title={AppStrings.settingsDarkTheme}
                            showArrow={false}
                            showSwitch={true}
                            switchValue={isDarkMode}
                            onSwitchChange={setIsDarkMode}
                        />
                        <SettingItem
                            icon={AppAssets.noticeIcon}
                            title={AppStrings.settingsTrainingNotice}
                            onPress={() => handleComingSoon(AppStrings.settingsTrainingNotice)}
                        />
                        <SettingItem
                            icon={AppAssets.trashIcon}
                            title={AppStrings.settingsDeleteUserData}
                            onPress={() => handleComingSoon(AppStrings.settingsDeleteUserData)}
                        />
                    </View>

                    {/* Support Section */}
                    <SectionTitle title={AppStrings.settingsSupportInfor} />
                    <View style={styles.section}>
                        <SettingItem
                            icon={AppAssets.commentIcon}
                            title={AppStrings.settingsFeedback}
                            onPress={() => handleComingSoon(AppStrings.settingsFeedback)}
                        />
                        <SettingItem
                            icon={AppAssets.policyIcon}
                            title={AppStrings.settingsPolicyAndTerms}
                            onPress={handlePrivacyTerms}
                        />
                    </View>

                    {/* Logout Button */}
                    <TouchableOpacity style={styles.logoutButton} onPress={handleLogout}>
                        <Text style={styles.logoutText}>{AppStrings.settingsLogout}</Text>
                    </TouchableOpacity>
                </ScrollView>
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
    scrollView: {
        flex: 1,
    },
    scrollContent: {
        paddingTop: Dims.spacingGiant,
        paddingHorizontal: Dims.paddingL,
    },
    avatarSection: {
        alignItems: 'center',
        marginBottom: Dims.spacingS,
    },
    fullName: {
        fontWeight: 'bold',
        fontSize: Dims.textSizeM,
        color: Colors.normal,
        marginTop: Dims.spacingM,
    },
    username: {
        fontSize: Dims.textSizeS,
        color: Colors.lightActive,
        marginTop: Dims.size4,
    },
    section: {
        backgroundColor: Colors.wWhite,
        borderRadius: Dims.borderRadius,
        marginBottom: Dims.spacingML,
        overflow: 'hidden',
    },
    logoutButton: {
        backgroundColor: Colors.wWhite,
        borderRadius: Dims.borderRadius,
        paddingVertical: Dims.paddingM,
        alignItems: 'center',
        marginTop: Dims.spacingML,
        marginBottom: Dims.spacingXL,
    },
    logoutText: {
        color: '#EF4444',
        fontSize: Dims.textSizeM,
    },
});
