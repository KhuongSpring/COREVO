import React from 'react';
import { View, Text, StyleSheet, ScrollView } from 'react-native';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import SafeAreaWrapper from '@/components/common/SafeAreaWrapper';
import { useAuthStore } from '@/store/authStore';
import { useUserStore } from '@/store/userStore';

/**
 * Home Screen (Main Tab)
 * Dashboard with user info, training overview, and calendar
 */
export default function HomeScreen() {
  const { isAuthenticated } = useAuthStore();
  const { user } = useUserStore();

  return (
    <SafeAreaWrapper backgroundColor={Colors.wWhite}>
      <ScrollView style={styles.container}>
        {/* Header */}
        <View style={styles.header}>
          <Text style={styles.greeting}>Xin chào,</Text>
          <Text style={styles.name}>{user?.fullName || 'User'} 👋</Text>
        </View>

        {/* Welcome Card */}
        <View style={styles.card}>
          <Text style={styles.cardTitle}>Trang chủ Corevo</Text>
          <Text style={styles.cardDescription}>
            Đây là màn hình trang chủ. Sẽ hiển thị:
          </Text>
          <View style={styles.featureList}>
            <Text style={styles.featureItem}>• Thông tin người dùng</Text>
            <Text style={styles.featureItem}>• Tổng quan tập luyện</Text>
            <Text style={styles.featureItem}>• Lịch tập trong tuần</Text>
            <Text style={styles.featureItem}>• Thống kê tiến độ</Text>
          </View>
        </View>

        {/* Status */}
        <View style={[styles.card, { backgroundColor: Colors.bLight }]}>
          <Text style={styles.statusText}>
            ✅ Tab Navigation hoạt động!
          </Text>
          <Text style={styles.statusText}>
            Auth: {isAuthenticated ? 'Logged In' : 'Guest'}
          </Text>
        </View>
      </ScrollView>
    </SafeAreaWrapper>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: Dims.paddingL,
  },
  header: {
    marginBottom: Dims.spacingXL,
    paddingTop: Dims.spacingM,
  },
  greeting: {
    fontSize: Dims.textSizeL,
    color: Colors.lighter,
    marginBottom: Dims.spacingS,
  },
  name: {
    fontSize: Dims.textSizeXXXL,
    fontWeight: 'bold',
    color: Colors.dark,
  },
  card: {
    backgroundColor: Colors.wNormal,
    borderRadius: Dims.borderRadius,
    padding: Dims.paddingL,
    marginBottom: Dims.spacingL,
  },
  cardTitle: {
    fontSize: Dims.textSizeXL,
    fontWeight: 'bold',
    color: Colors.bNormal,
    marginBottom: Dims.spacingM,
  },
  cardDescription: {
    fontSize: Dims.textSizeM,
    color: Colors.dark,
    marginBottom: Dims.spacingM,
  },
  featureList: {
    marginTop: Dims.spacingS,
  },
  featureItem: {
    fontSize: Dims.textSizeM,
    color: Colors.lighter,
    marginBottom: Dims.spacingS,
  },
  statusText: {
    fontSize: Dims.textSizeM,
    color: Colors.dark,
    marginBottom: Dims.spacingS,
  },
});
