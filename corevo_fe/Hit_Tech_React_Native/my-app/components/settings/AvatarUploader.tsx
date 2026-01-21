import React, { useState } from 'react';
import { View, TouchableOpacity, Image, StyleSheet, Alert, ActivityIndicator, ActionSheetIOS, Platform } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import * as ImagePicker from 'expo-image-picker';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { AppAssets } from '@/constants/AppAssets';

interface AvatarUploaderProps {
    avatarUrl?: string | null;
    onUpload: (imageUri: string) => Promise<void>;
    size?: number;
    isHaveCamera?: boolean;
}

/**
 * Avatar Uploader Component
 * Displays avatar with camera overlay button for upload
 */
export default function AvatarUploader({
    avatarUrl,
    onUpload,
    size = Dims.size40 * 2, // 80 (radius * 2)
    isHaveCamera = true,
}: AvatarUploaderProps) {
    const [isUploading, setIsUploading] = useState(false);

    const requestPermissions = async () => {
        const cameraPermission = await ImagePicker.requestCameraPermissionsAsync();
        const mediaPermission = await ImagePicker.requestMediaLibraryPermissionsAsync();

        if (!cameraPermission.granted || !mediaPermission.granted) {
            Alert.alert(
                'Cần quyền truy cập',
                'Vui lòng cấp quyền truy cập camera và thư viện ảnh để tải lên ảnh đại diện.'
            );
            return false;
        }
        return true;
    };

    const pickImage = async (source: 'camera' | 'gallery') => {
        const hasPermission = await requestPermissions();
        if (!hasPermission) return;

        try {
            let result;

            if (source === 'camera') {
                result = await ImagePicker.launchCameraAsync({
                    mediaTypes: ImagePicker.MediaTypeOptions.Images,
                    allowsEditing: true,
                    aspect: [1, 1],
                    quality: 0.75,
                });
            } else {
                result = await ImagePicker.launchImageLibraryAsync({
                    mediaTypes: ImagePicker.MediaTypeOptions.Images,
                    allowsEditing: true,
                    aspect: [1, 1],
                    quality: 0.75,
                });
            }

            if (!result.canceled && result.assets[0]) {
                setIsUploading(true);
                await onUpload(result.assets[0].uri);
                setIsUploading(false);
            }
        } catch (error) {
            setIsUploading(false);
            Alert.alert('Lỗi', 'Không thể tải lên ảnh. Vui lòng thử lại.');
        }
    };

    const showImagePicker = () => {
        if (Platform.OS === 'ios') {
            ActionSheetIOS.showActionSheetWithOptions(
                {
                    options: ['Hủy bỏ', 'Chụp ảnh', 'Chọn ảnh từ Album'],
                    cancelButtonIndex: 0,
                },
                (buttonIndex) => {
                    if (buttonIndex === 1) {
                        pickImage('camera');
                    } else if (buttonIndex === 2) {
                        pickImage('gallery');
                    }
                }
            );
        } else {
            Alert.alert(
                'Chọn ảnh',
                'Chọn nguồn ảnh',
                [
                    { text: 'Hủy bỏ', style: 'cancel' },
                    { text: 'Chụp ảnh', onPress: () => pickImage('camera') },
                    { text: 'Chọn ảnh từ Album', onPress: () => pickImage('gallery') },
                ]
            );
        }
    };

    return (
        <View style={styles.container}>
            <View style={[styles.avatarContainer, { width: size, height: size, borderRadius: size / 2 }]}>
                <Image
                    source={
                        avatarUrl
                            ? { uri: avatarUrl }
                            : { uri: AppAssets.defaultImage }
                    }
                    style={[styles.avatar, { width: size, height: size, borderRadius: size / 2 }]}
                />

                {isUploading && (
                    <View style={[styles.loadingOverlay, { borderRadius: size / 2 }]}>
                        <ActivityIndicator size="large" color={Colors.bNormal} />
                    </View>
                )}
            </View>

            {isHaveCamera && (
                <TouchableOpacity
                    style={styles.cameraButton}
                    onPress={showImagePicker}
                    disabled={isUploading}
                >
                    <Ionicons
                        name="camera"
                        size={Dims.iconSizeM}
                        color={Colors.dark}
                    />
                </TouchableOpacity>
            )}
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        position: 'relative',
    },
    avatarContainer: {
        borderWidth: 2,
        borderColor: Colors.bNormal,
        overflow: 'hidden',
    },
    avatar: {
        width: '100%',
        height: '100%',
    },
    loadingOverlay: {
        ...StyleSheet.absoluteFillObject,
        backgroundColor: 'rgba(255, 255, 255, 0.8)',
        justifyContent: 'center',
        alignItems: 'center',
    },
    cameraButton: {
        position: 'absolute',
        bottom: 0,
        right: 0,
        backgroundColor: Colors.wWhite,
        borderRadius: 100,
        padding: Dims.paddingXS,
        borderWidth: 1.5,
        borderColor: Colors.bNormal,
    },
});
