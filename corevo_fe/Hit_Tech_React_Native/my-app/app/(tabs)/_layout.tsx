import React, { useEffect, useRef } from 'react';
import { View, Text, TouchableOpacity, StyleSheet, Image, Animated, Easing } from 'react-native';
import { Tabs } from 'expo-router';
import { Colors } from '@/constants/Colors';
import { AppAssets } from '@/constants/AppAssets';
import { Dims } from '@/constants/Dimensions';

/**
 * Component TabItem riêng biệt để xử lý Animation cho từng nút
 */
const TabItem = ({ isFocused, options, label, onPress }: any) => {
  // Giá trị Animation: 0 (Chưa chọn) -> 1 (Đã chọn)
  const animatedValue = useRef(new Animated.Value(isFocused ? 1 : 0)).current;

  useEffect(() => {
    Animated.spring(animatedValue, {
      toValue: isFocused ? 1 : 0,
      damping: 30,       // Độ nảy (càng thấp càng nảy nhiều, chuẩn ~10-15)
      stiffness: 150,    // Độ cứng lò xo (càng cao càng nhanh, chuẩn ~100-150)
      mass: 0.5,           // Khối lượng vật thể
      useNativeDriver: false,
    }).start();
  }, [isFocused]);

  // 1. Animation màu nền: Trắng -> Xanh Nhạt
  const backgroundColor = animatedValue.interpolate({
    inputRange: [0, 1],
    outputRange: [Colors.wWhite, Colors.bLightActive2]
  });

  // 2. Animation độ mờ chữ: 0 -> 1
  const labelOpacity = animatedValue.interpolate({
    inputRange: [0, 1],
    outputRange: [0, 1]
  });

  // 3. Animation chiều rộng chữ: 0 -> 100 (đủ rộng để chứa chữ)
  // Đây là chìa khóa để fix lỗi: Chữ sẽ trượt ra/vào thay vì hiện thụp
  const labelMaxWidth = animatedValue.interpolate({
    inputRange: [0, 1],
    outputRange: [0, 120] // Max width ước lượng cho chữ dài nhất
  });

  // 4. Animation padding cho chữ: Để khi đóng lại nó khít hoàn toàn
  const labelPaddingLeft = animatedValue.interpolate({
    inputRange: [0, 1],
    outputRange: [0, Dims.spacingS]
  });

  // Lấy icon component
  const IconComponent = options.tabBarIcon;

  return (
    <TouchableOpacity
      accessibilityRole="button"
      onPress={onPress}
      activeOpacity={1} // Fix lỗi icon bị mờ khi nhấn
      style={styles.touchableWrapper}
    >
      <Animated.View style={[styles.tabItem, { backgroundColor }]}>
        {/* Render Icon */}
        {IconComponent && IconComponent({ focused: isFocused })}

        {/* Render Text với Animation */}
        <Animated.View
          style={{
            opacity: labelOpacity,
            maxWidth: labelMaxWidth,
            paddingLeft: labelPaddingLeft,
            overflow: 'hidden', // Quan trọng: che chữ khi đang thu nhỏ
            justifyContent: 'center'
          }}
        >
          <Text style={styles.tabLabel} numberOfLines={1}>
            {label}
          </Text>
        </Animated.View>
      </Animated.View>
    </TouchableOpacity>
  );
};

/**
 * Container chứa các TabItem
 */
function CustomTabBar({ state, descriptors, navigation }: any) {
  return (
    <View style={styles.tabBarContainer}>
      {state.routes.map((route: any, index: number) => {
        const { options } = descriptors[route.key];
        const label =
          options.tabBarLabel !== undefined
            ? options.tabBarLabel
            : options.title !== undefined
              ? options.title
              : route.name;

        const isFocused = state.index === index;

        const onPress = () => {
          const event = navigation.emit({
            type: 'tabPress',
            target: route.key,
            canPreventDefault: true,
          });

          if (!isFocused && !event.defaultPrevented) {
            navigation.navigate(route.name, route.params);
          }
        };

        return (
          <TabItem
            key={index}
            isFocused={isFocused}
            options={options}
            label={label}
            onPress={onPress}
          />
        );
      })}
    </View>
  );
}

// --- Main Layout ---
export default function TabLayout() {
  return (
    <Tabs
      tabBar={(props) => <CustomTabBar {...props} />}
      screenOptions={{
        headerShown: false,
      }}
    >
      {/* Các màn hình Tabs giữ nguyên như cũ */}
      <Tabs.Screen
        name="index"
        options={{
          title: 'Tổng quan',
          tabBarIcon: ({ focused }) => (
            <Image
              source={focused ? AppAssets.homeIconActive : AppAssets.homeIconNonActive}
              style={{ width: Dims.size24, height: Dims.size24 }}
              resizeMode="contain"
            />
          ),
        }}
      />
      <Tabs.Screen
        name="library"
        options={{
          title: 'Thư viện',
          tabBarIcon: ({ focused }) => (
            <Image
              source={focused ? AppAssets.libraryIconActive : AppAssets.libraryIconNonActive}
              style={{ width: Dims.size24, height: Dims.size24 }}
              resizeMode="contain"
            />
          ),
        }}
      />
      <Tabs.Screen
        name="training"
        options={{
          title: 'Tập luyện',
          tabBarIcon: ({ focused }) => (
            <Image
              source={focused ? AppAssets.trainingIconActive : AppAssets.trainingIconNonActive}
              style={{ width: Dims.size24, height: Dims.size24 }}
              resizeMode="contain"
            />
          ),
        }}
      />
      <Tabs.Screen
        name="feeds"
        options={{
          title: 'Cộng đồng',
          tabBarIcon: ({ focused }) => (
            <Image
              source={focused ? AppAssets.feedsIconActive : AppAssets.feedsIconNonActive}
              style={{ width: Dims.size24, height: Dims.size24 }}
              resizeMode="contain"
            />
          ),
        }}
      />
      <Tabs.Screen
        name="settings"
        options={{
          title: 'Cá nhân',
          tabBarIcon: ({ focused }) => (
            <Image
              source={focused ? AppAssets.profileIconActive : AppAssets.profileIconNonActive}
              style={{ width: Dims.size24, height: Dims.size24 }}
              resizeMode="contain"
            />
          ),
        }}
      />
    </Tabs>
  );
}

const styles = StyleSheet.create({
  tabBarContainer: {
    flexDirection: 'row',
    position: 'absolute',
    bottom: Dims.spacingML,
    left: Dims.spacingL,
    right: Dims.spacingL,
    backgroundColor: Colors.bNormal,
    borderRadius: Dims.borderRadiusXL,
    height: Dims.size72,
    alignItems: 'center',
    justifyContent: 'space-around', // Dàn đều các nút
    paddingHorizontal: Dims.spacingXS,

    // Shadow
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 8 },
    shadowOpacity: 0.15,
    shadowRadius: 12,
    elevation: 8,
  },
  touchableWrapper: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  tabItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: Dims.spacingSM,
    paddingHorizontal: Dims.spacingSM, // Padding cơ bản cho icon
    borderRadius: Dims.borderRadiusXL,
    height: 48, // Chiều cao cố định cho item để đẹp hơn
  },
  tabLabel: {
    color: Colors.wWhite, // Đổi thành màu bạn muốn (trắng trên nền xanh nhạt?? Cần check lại độ tương phản)
    fontSize: Dims.textSizeXS,
    fontWeight: 'bold',
    // Nếu nền là bLightActive2 (xanh nhạt), bạn có thể muốn đổi màu chữ thành Colors.bNormal (xanh đậm)
    // color: Colors.bNormal 
  }
});