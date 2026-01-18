import React from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, Alert } from 'react-native';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import SafeAreaWrapper from '@/components/common/SafeAreaWrapper';
import { useAuthStore } from '@/store/authStore';
import { useUserStore } from '@/store/userStore';

/**
 * Settings Tab Screen
 * User settings and preferences
 */
export default function SettingsScreen() {
    const router = useRouter();
    const { logout } = useAuthStore();
    const { user, clearUser } = useUserStore();

    const handleLogout = () => {
        Alert.alert(
            'Đăng xuất',
            'Bạn có chắc chắn muốn đăng xuất?',
            [
                { text: 'Hủy', style: 'cancel' },
                {
                    text: 'Đăng xuất',
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

    return (
        <SafeAreaWrapper backgroundColor={Colors.wWhite}>
            <ScrollView style={styles.container}>
                <Text style={styles.title}>Cài Đặt</Text>

                {/* User Profile Section */}
                <View style={styles.section}>
                    <Text style={styles.sectionTitle}>Thông tin tài khoản</Text>
                    <View style={styles.profileCard}>
                        <View style={styles.avatar}>
                            <Ionicons name="person" size={40} color={Colors.wWhite} />
                        </View>
                        <View style={styles.profileInfo}>
                            <Text style={styles.profileName}>{user?.fullName || 'User'}</Text>
                            <Text style={styles.profileEmail}>{user?.email || 'email@example.com'}</Text>
                        </View>
                    </View>
                </View>

                {/* Settings Options */}
                <View style={styles.section}>
                    <Text style={styles.sectionTitle}>Tùy chọn</Text>

                    <TouchableOpacity style={styles.settingItem}>
                        <Ionicons name="person-outline" size={24} color={Colors.bNormal} />
                        <Text style={styles.settingText}>Chỉnh sửa hồ sơ</Text>
                        <Ionicons name="chevron-forward" size={20} color={Colors.lighter} />
                    </TouchableOpacity>

                    <TouchableOpacity style={styles.settingItem}>
                        <Ionicons name="notifications-outline" size={24} color={Colors.bNormal} />
                        <Text style={styles.settingText}>Thông báo</Text>
                        <Ionicons name="chevron-forward" size={20} color={Colors.lighter} />
                    </TouchableOpacity>

                    <TouchableOpacity style={styles.settingItem}>
                        <Ionicons name="shield-outline" size={24} color={Colors.bNormal} />
                        <Text style={styles.settingText}>Chính sách bảo mật</Text>
                        <Ionicons name="chevron-forward" size={20} color={Colors.lighter} />
                    </TouchableOpacity>

                    <TouchableOpacity style={styles.settingItem}>
                        <Ionicons name="document-text-outline" size={24} color={Colors.bNormal} />
                        <Text style={styles.settingText}>Điều khoản dịch vụ</Text>
                        <Ionicons name="chevron-forward" size={20} color={Colors.lighter} />
                    </TouchableOpacity>
                </View>

                {/* Logout Button */}
                <TouchableOpacity style={styles.logoutButton} onPress={handleLogout}>
                    <Ionicons name="log-out-outline" size={24} color="#EF4444" />
                    <Text style={styles.logoutText}>Đăng xuất</Text>
                </TouchableOpacity>

                {/* App Version */}
                <Text style={styles.version}>Version 1.0.0</Text>
            </ScrollView>
        </SafeAreaWrapper>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        padding: Dims.paddingL,
    },
    title: {
        fontSize: Dims.textSizeXXL,
        fontWeight: 'bold',
        color: Colors.dark,
        marginBottom: Dims.spacingXL,
        marginTop: Dims.spacingM,
    },
    section: {
        marginBottom: Dims.spacingXL,
    },
    sectionTitle: {
        fontSize: Dims.textSizeL,
        fontWeight: '600',
        color: Colors.dark,
        marginBottom: Dims.spacingM,
    },
    profileCard: {
        flexDirection: 'row',
        alignItems: 'center',
        backgroundColor: Colors.wNormal,
        padding: Dims.paddingL,
        borderRadius: Dims.borderRadius,
    },
    avatar: {
        width: Dims.size64,
        height: Dims.size64,
        borderRadius: Dims.size32,
        backgroundColor: Colors.bNormal,
        alignItems: 'center',
        justifyContent: 'center',
        marginRight: Dims.spacingM,
    },
    profileInfo: {
        flex: 1,
    },
    profileName: {
        fontSize: Dims.textSizeL,
        fontWeight: 'bold',
        color: Colors.dark,
        marginBottom: Dims.spacingS,
    },
    profileEmail: {
        fontSize: Dims.textSizeM,
        color: Colors.lighter,
    },
    settingItem: {
        flexDirection: 'row',
        alignItems: 'center',
        backgroundColor: Colors.wNormal,
        padding: Dims.paddingM,
        borderRadius: Dims.borderRadius,
        marginBottom: Dims.spacingM,
    },
    settingText: {
        flex: 1,
        fontSize: Dims.textSizeM,
        color: Colors.dark,
        marginLeft: Dims.spacingM,
    },
    logoutButton: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: '#FEE2E2',
        padding: Dims.paddingM,
        borderRadius: Dims.borderRadius,
        marginTop: Dims.spacingL,
        marginBottom: Dims.spacingXL,
    },
    logoutText: {
        fontSize: Dims.textSizeM,
        fontWeight: '600',
        color: '#EF4444',
        marginLeft: Dims.spacingS,
    },
    version: {
        fontSize: Dims.textSizeS,
        color: Colors.lighter,
        textAlign: 'center',
        marginBottom: Dims.spacingXXL,
    },
});
