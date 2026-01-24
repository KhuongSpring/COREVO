import React, { useState } from 'react';
import {
    View,
    Text,
    StyleSheet,
    ScrollView,
    TouchableOpacity,
    ImageBackground,
    Alert,
    Modal,
    TextInput,
    KeyboardAvoidingView,
    Platform,
    TouchableWithoutFeedback,
    Keyboard
} from 'react-native';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { AppAssets } from '@/constants/AppAssets';
import AvatarUploader from '@/components/settings/AvatarUploader';
import { AppStrings } from '@/constants/AppStrings';
import DateTimePicker from '@react-native-community/datetimepicker';
import { Picker } from '@react-native-picker/picker';
import CountryPicker, { Flag, Country, CountryCode } from 'react-native-country-picker-modal';
import { useTheme } from '@/hooks/useTheme';
// import { userService } from '@/services/api/userService';

// Mock data
const MOCK_USER = {
    username: 'nguyenvana',
    email: 'nguyenvana@example.com',
    firstName: 'Nguyễn',
    lastName: 'Văn A',
    birth: '15/05/1995',
    phone: '0912345678',
    nationality: 'Việt Nam',
    countryCode: 'VN' as CountryCode,
    linkAvatar: AppAssets.defaultImage,
};

const getFlagEmoji = (countryCode?: string) => {
    if (!countryCode) return '';
    const codePoints = countryCode
        .toUpperCase()
        .split('')
        .map(char => 127397 + char.charCodeAt(0));
    return String.fromCodePoint(...codePoints);
};

/**
 * Personal Information Screen - Matching Flutter design
 * Displays and allows editing of user's personal information with mock data
 */
export default function PersonalInformationScreen() {
    const router = useRouter();
    const [profile, setProfile] = useState(MOCK_USER);
    const { colors, mode } = useTheme();

    const [modalVisible, setModalVisible] = useState(false);
    const [editConfig, setEditConfig] = useState({
        field: '',
        label: '',
        value: ''
    });
    const [inputValue, setInputValue] = useState('');
    const [errorMsg, setErrorMsg] = useState<string | null>(null);

    const [showDatePicker, setShowDatePicker] = useState(false);
    const [selectedDate, setSelectedDate] = useState(new Date());

    const [showCountryPicker, setShowCountryPicker] = useState(false);

    const handleOpenEdit = (field: string, currentValue: string, label: string) => {
        if (field === 'username') return;

        if (field === 'birth') {
            setSelectedDate(parseDate(currentValue));
            setShowDatePicker(true);
            return;
        }

        if (field === 'nationality') {
            setShowCountryPicker(true);
            return;
        }

        setEditConfig({ field, label, value: currentValue });
        setInputValue(currentValue);
        setErrorMsg(null);
        setModalVisible(true);
    };

    // Hàm upload ảnh (Mock)
    const handleAvatarUpload = async (imageUri: string) => {
        Alert.alert('Thông báo', 'Chức năng đang sử dụng dữ liệu mẫu');
    };

    // Hàm Validate
    const validate = (text: string) => {
        const trimmed = text.trim();
        if (!trimmed) return AppStrings.fieldNotBlank + ' ' + editConfig.label.toLowerCase();

        if (editConfig.field === 'phone') {
            const phoneRegex = /^[0-9]{10,11}$/;
            if (!phoneRegex.test(trimmed)) return AppStrings.phoneIsNotValid;
        }
        return null;
    };

    // Hàm Lưu
    const handleSave = () => {
        const error = validate(inputValue);
        if (error) {
            setErrorMsg(error);
            return;
        }

        setProfile(prev => ({ ...prev, [editConfig.field]: inputValue }));
        setModalVisible(false);
    };

    // [NOTE] Hàm chuyển đổi chuỗi "DD/MM/YYYY" sang đối tượng Date
    const parseDate = (dateStr: string) => {
        const parts = dateStr.split('/');
        // Lưu ý: Tháng trong JS bắt đầu từ 0 (0 = tháng 1)
        return new Date(parseInt(parts[2]), parseInt(parts[1]) - 1, parseInt(parts[0]));
    };

    // [NOTE] Hàm chuyển đổi Date sang chuỗi "DD/MM/YYYY"
    const formatDate = (date: Date) => {
        const day = date.getDate().toString().padStart(2, '0');
        const month = (date.getMonth() + 1).toString().padStart(2, '0');
        const year = date.getFullYear();
        return `${day}/${month}/${year}`;
    };

    const onChangeDate = (event: any, date?: Date) => {
        // Trên Android, picker tự đóng sau khi chọn
        if (Platform.OS === 'android') {
            setShowDatePicker(false);
        }

        if (date) {
            setSelectedDate(date);
            // Trên Android: cập nhật luôn khi chọn xong
            if (Platform.OS === 'android') {
                const dateString = formatDate(date);
                setProfile(prev => ({ ...prev, birth: dateString }));
            }
        } else {
            // Trường hợp hủy trên Android
            if (Platform.OS === 'android') setShowDatePicker(false);
        }
    };

    const confirmIOSDate = () => {
        const dateString = formatDate(selectedDate);
        setProfile(prev => ({ ...prev, birth: dateString }));
        setShowDatePicker(false);
    };

    // [NOTE] Hàm xử lý khi chọn nước xong
    const onSelectCountry = (country: Country) => {
        setProfile(prev => ({
            ...prev,
            nationality: country.name as string, // Lấy tên nước (Vietnam)
            countryCode: country.cca2 // Lấy mã nước (VN) để hiện cờ
        }));
        setShowCountryPicker(false); // Đóng modal
    };

    const renderInfoItem = (label: string, field: string, value: string) => {
        const isUsername = field === 'username';
        const isNationality = field === 'nationality';
        return (
            <TouchableOpacity
                style={styles.infoItem}
                onPress={() => !isUsername && handleOpenEdit(field, value, label)}
                disabled={isUsername}
                activeOpacity={0.7}
            >
                <Text style={[styles.label, { color: colors.text.primary }]}>{label}</Text>

                {/* [NOTE] Container cho Value (chứa cả Flag và Text) */}
                <View style={styles.valueContainer}>
                    {/* Chỉ hiện cờ nếu là trường quốc tịch và có mã nước */}
                    {isNationality && profile.countryCode && (
                        <Text style={{ marginRight: Dims.size4, fontSize: Dims.textSizeL }}>
                            {getFlagEmoji(profile.countryCode)}
                        </Text>
                    )}
                    <Text style={[styles.value, { color: colors.brand.primary }]}>
                        {value}
                    </Text>
                </View>
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
                            <Ionicons name="chevron-back" size={Dims.iconSizeXXL} color={colors.brand.primary} />
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

                    {/* Information List */}
                    <ScrollView
                        style={styles.scrollView}
                        contentContainerStyle={styles.scrollContent}
                        showsVerticalScrollIndicator={false}
                    >
                        <View style={[styles.section, { backgroundColor: colors.background.primary }]}>
                            {renderInfoItem(AppStrings.username, 'username', profile.username)}
                            <View style={[styles.divider, { backgroundColor: colors.interactive.disabled }]} />
                            {renderInfoItem(AppStrings.firstName, 'firstName', profile.firstName)}
                            <View style={[styles.divider, { backgroundColor: colors.interactive.disabled }]} />
                            {renderInfoItem(AppStrings.lastName, 'lastName', profile.lastName)}
                            <View style={[styles.divider, { backgroundColor: colors.interactive.disabled }]} />
                            {renderInfoItem(AppStrings.birth, 'birth', profile.birth)}
                            <View style={[styles.divider, { backgroundColor: colors.interactive.disabled }]} />
                            {renderInfoItem(AppStrings.phone, 'phone', profile.phone)}
                            <View style={[styles.divider, { backgroundColor: colors.interactive.disabled }]} />
                            {renderInfoItem(AppStrings.nationality, 'nationality', profile.nationality)}
                        </View>
                    </ScrollView>
                </View>

                {/* --- CUSTOM EDIT MODAL --- */}
                <Modal
                    visible={modalVisible}
                    transparent
                    animationType="fade"
                    onRequestClose={() => setModalVisible(false)}
                >
                    <TouchableWithoutFeedback onPress={Keyboard.dismiss}>
                        <KeyboardAvoidingView
                            behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
                            style={[styles.modalOverlay, { backgroundColor: colors.overlay }]}
                        >
                            <View style={[styles.modalContent, { backgroundColor: colors.background.primary, shadowColor: colors.surface.inverse }]}>
                                <Text style={[styles.modalTitle, { color: colors.text.primary }]}>{editConfig.label}</Text>

                                {/* [NOTE] Input Wrapper: Chứa TextInput + Nút Xóa */}
                                <View style={[
                                    styles.inputContainer,
                                    { borderColor: colors.border.focus, backgroundColor: colors.background.primary },
                                    errorMsg ? [styles.inputError, { borderColor: colors.semantic.error, backgroundColor: colors.semantic.errorLight }] : null, // [NOTE] Border đỏ khi lỗi
                                ]}>
                                    <TextInput
                                        style={[styles.textInput, { color: colors.text.primary }]}
                                        value={inputValue}
                                        onChangeText={(text) => {
                                            setInputValue(text);
                                            if (errorMsg) setErrorMsg(null); // Xóa lỗi khi gõ lại
                                        }}
                                        autoFocus={true}
                                        keyboardType={editConfig.field === 'phone' ? 'numeric' : 'default'}
                                    />

                                    {/* [NOTE] Nút Xóa Tất Cả (x) */}
                                    {inputValue.length > 0 && (
                                        <TouchableOpacity onPress={() => setInputValue('')} style={styles.clearBtn}>
                                            <Ionicons name="close-circle" size={Dims.iconSizeL} color={colors.text.secondary} />
                                        </TouchableOpacity>
                                    )}
                                </View>

                                {/* [NOTE] Error Message Text */}
                                {errorMsg && <Text style={[styles.errorText, { color: colors.semantic.error }]}>{errorMsg}</Text>}

                                {/* Buttons */}
                                <View style={styles.buttonRow}>
                                    <TouchableOpacity
                                        style={[styles.modalBtn]}
                                        onPress={() => setModalVisible(false)}
                                    >
                                        {/* [NOTE] Nút Hủy màu đỏ */}
                                        <Text style={[styles.cancelText, { color: colors.semantic.error }]}>{AppStrings.cancel}</Text>
                                    </TouchableOpacity>

                                    <TouchableOpacity
                                        style={[styles.modalBtn, styles.saveBtn]}
                                        onPress={handleSave}
                                    >
                                        <Text style={styles.saveText}>{AppStrings.save}</Text>
                                    </TouchableOpacity>
                                </View>
                            </View>
                        </KeyboardAvoidingView>
                    </TouchableWithoutFeedback>
                </Modal>

                {/* --- [NOTE] XỬ LÝ DATE PICKER CHO ANDROID VÀ IOS --- */}
                {/* Android: DatePicker là một Dialog native, chỉ cần render component là nó tự hiện.
                    iOS: DatePicker là dạng Spinner/Inline, cần bọc trong Modal để hiện giống popup dưới đáy.
                */}

                {/* ANDROID PICKER */}
                {Platform.OS === 'android' && showDatePicker && (
                    <DateTimePicker
                        value={selectedDate}
                        mode="date"
                        display="default" // Native Dialog của Android
                        onChange={onChangeDate}
                        maximumDate={new Date()} // Không chọn ngày tương lai
                    />
                )}

                {/* IOS PICKER MODAL */}
                {Platform.OS === 'ios' && (
                    <Modal
                        visible={showDatePicker}
                        transparent={true}
                        animationType="slide"
                        onRequestClose={() => setShowDatePicker(false)}
                    >
                        <View style={[styles.iosDatePickerOverlay, { backgroundColor: colors.overlay }]}>
                            <View style={styles.iosDatePickerContainer}>
                                {/* Toolbar nút bấm */}
                                <View style={styles.iosDatePickerHeader}>
                                    <TouchableOpacity onPress={() => setShowDatePicker(false)}>
                                        <Text style={[styles.cancelText, { color: colors.semantic.error, fontSize: Dims.textSizeM }]}>{AppStrings.cancel}</Text>
                                    </TouchableOpacity>
                                    <Text style={styles.iosDatePickerTitle}>{AppStrings.birth}</Text>
                                    <TouchableOpacity onPress={confirmIOSDate}>
                                        <Text style={[styles.saveText, { color: colors.brand.primary, fontSize: Dims.textSizeM }]}>{AppStrings.save}</Text>
                                    </TouchableOpacity>
                                </View>

                                {/* Native iOS Spinner */}
                                <DateTimePicker
                                    value={selectedDate}
                                    mode="date"
                                    display="spinner" // Dạng cuộn chuẩn iOS
                                    onChange={onChangeDate}
                                    maximumDate={new Date()}
                                    style={{ height: Dims.size200, width: '100%' }}
                                    locale="vi-VN" // Hiển thị Tiếng Việt
                                />
                            </View>
                        </View>
                    </Modal>
                )}

                {/* --- [NOTE] COUNTRY PICKER COMPONENT --- */}
                {showCountryPicker && (
                    <CountryPicker
                        visible={showCountryPicker}
                        onClose={() => setShowCountryPicker(false)}
                        onSelect={onSelectCountry}
                        withFilter={true} // Hiện ô tìm kiếm
                        withFlag={true} // Hiện cờ trong list
                        withCountryNameButton={false} // Không hiện nút mặc định, ta tự control
                        withAlphaFilter={true} // Thanh cuộn chữ cái bên phải
                        withCallingCode={false}
                        withEmoji={true} // Cờ dạng emoji (nhẹ hơn)
                        translation='common' // Dùng tên thông dụng (Vietnam)
                        countryCode={profile.countryCode} // Mã nước mặc định khi mở

                    // Style cho modal bên trong thư viện (Tuỳ chỉnh nếu muốn)
                    // containerButtonStyle={{...}} 
                    />
                )}
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

    // --- [NOTE] CUSTOM MODAL STYLES ---
    modalOverlay: {
        flex: 1,
        justifyContent: 'center',
        paddingHorizontal: Dims.paddingXL,
    },
    modalContent: {
        borderRadius: Dims.borderRadiusL,
        paddingHorizontal: Dims.paddingL,
        paddingVertical: Dims.paddingM,
        width: '100%',
        // Shadow cho nổi bật
        elevation: 5,
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.25,
        shadowRadius: 4,
    },
    modalTitle: {
        fontSize: Dims.textSizeL,
        fontWeight: 'bold',
        marginBottom: Dims.spacingM,
        textAlign: 'center',
    },

    // Style cho Input Group (Border bao quanh)
    inputContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        borderWidth: 1.2,
        borderRadius: Dims.borderRadiusSmall,
        paddingHorizontal: Dims.paddingM,
        height: Dims.size48,
    },
    // [NOTE] Style khi có lỗi: Border đỏ
    inputError: {
        borderWidth: 1.5,
    },
    textInput: {
        flex: 1,
        fontSize: Dims.textSizeS,
        height: '100%',
    },
    clearBtn: {
        padding: Dims.paddingXS,
        marginLeft: Dims.spacingS,
    },

    // [NOTE] Error Message Style
    errorText: {
        fontSize: Dims.textSizeXS, // 12px
        marginTop: Dims.spacingXS,
        marginLeft: Dims.spacingXS,
        fontWeight: '500',
    },

    buttonRow: {
        flexDirection: 'row',
        justifyContent: 'flex-end',
        marginTop: Dims.spacingL,
        gap: Dims.spacingM,
    },
    modalBtn: {
        paddingVertical: 10,
        paddingHorizontal: 20,
        borderRadius: Dims.borderRadiusSmall,
        justifyContent: 'center',
    },
    saveBtn: {
        backgroundColor: Colors.bLightActive2,
    },
    // [NOTE] Text Nút Hủy màu đỏ
    cancelText: {
        fontWeight: 'bold',
        fontSize: Dims.textSizeS,
    },
    saveText: {
        color: Colors.wWhite,
        fontWeight: 'bold',
        fontSize: Dims.textSizeS,
    },

    // --- [NOTE] IOS DATE PICKER STYLES ---
    iosDatePickerOverlay: {
        flex: 1,
        justifyContent: 'flex-end',
    },
    iosDatePickerContainer: {
        backgroundColor: Colors.wWhite,
        borderTopLeftRadius: Dims.borderRadius,
        borderTopRightRadius: Dims.borderRadius,
        paddingBottom: Dims.paddingL, // An toàn cho iPhone X+
        alignItems: 'center',
    },
    iosDatePickerHeader: {
        width: '100%',
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        padding: Dims.paddingM,
        borderBottomWidth: 1,
        borderBottomColor: Colors.bLightHover,
        backgroundColor: '#F2F2F2',
        borderTopLeftRadius: Dims.borderRadius,
        borderTopRightRadius: Dims.borderRadius,
    },
    iosDatePickerTitle: {
        fontWeight: 'bold',
        fontSize: Dims.textSizeM,
        color: Colors.dark,
    },
    bottomModalOverlay: {
        flex: 1,
        justifyContent: 'flex-end',
        backgroundColor: 'rgba(0,0,0,0.4)',
    },
    bottomModalContainer: {
        backgroundColor: Colors.wWhite,
        borderTopLeftRadius: Dims.borderRadius,
        borderTopRightRadius: Dims.borderRadius,
        paddingBottom: Dims.paddingL,
        alignItems: 'center', // Căn giữa nội dung picker
    },
    bottomModalHeader: {
        width: '100%',
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        padding: Dims.paddingM,
        borderBottomWidth: 1,
        borderBottomColor: Colors.bLightHover,
        backgroundColor: '#F2F2F2',
        borderTopLeftRadius: Dims.borderRadius,
        borderTopRightRadius: Dims.borderRadius,
    },
    bottomModalTitle: {
        fontWeight: 'bold',
        fontSize: Dims.textSizeM,
        color: Colors.dark,
    },
    // [NOTE] Styles mới cho phần hiển thị Value + Cờ
    valueContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        // justifyContent: 'flex-end',
        // flex: 1,
    },
    flagContainer: {
        marginRight: Dims.spacingXS, // Khoảng cách giữa cờ và tên nước
    },
});
