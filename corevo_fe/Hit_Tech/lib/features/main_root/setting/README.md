# Setting Feature - 5 API Endpoints Implementation

## Tổng quan

Đã triển khai thành công 5 API endpoints cho tính năng Setting với các trang riêng biệt để quản lý các chức năng khác nhau.

## Cấu trúc thư mục

```
lib/features/main_root/setting/
├── cubit/
│   ├── setting_cubit.dart          # Business logic
│   └── setting_state.dart          # State management
├── service/
│   └── setting_service.dart        # API service layer
├── model/
│   ├── user_profile_model.dart     # Data models
│   └── setting_request_model.dart  # Request models
└── view/
    ├── setting_page.dart           # Main setting page
    ├── pages/                      # Separate pages for 5 functions
    │   ├── profile_view_page.dart          # 1. GET Profile
    │   ├── profile_update_page.dart        # 2. PUT Update Profile
    │   ├── avatar_upload_page.dart         # 3. POST Upload Avatar
    │   ├── personal_info_update_page.dart  # 4. POST Personal Info
    │   └── account_deletion_page.dart      # 5. DELETE Account
    └── widgets/                    # Original widget pages
        ├── personal_information_page.dart
        ├── personal_health_page.dart
        └── notice_training_page.dart
```

## 5 API Endpoints đã triển khai

### 1. GET /api/v1/user/profile - Xem thông tin Profile

- **File**: `profile_view_page.dart`
- **Chức năng**: Hiển thị thông tin profile người dùng
- **Cubit method**: `loadUserProfile()`
- **State**: `SettingLoaded`

### 2. PUT /api/v1/user/update-profile - Cập nhật Profile

- **File**: `profile_update_page.dart`
- **Chức năng**: Cập nhật thông tin cơ bản (username hiện tại)
- **Cubit method**: `updateProfile()`
- **State**: `SettingProfileUpdated`

### 3. POST /api/v1/user/upload-avatar - Upload Avatar

- **File**: `avatar_upload_page.dart`
- **Chức năng**: Upload ảnh đại diện (cần thêm image_picker dependency)
- **Cubit method**: `uploadAvatarFromPicker()`
- **State**: `SettingAvatarUploaded`

### 4. POST /api/v1/user/personal-information - Thông tin cá nhân

- **File**: `personal_info_update_page.dart`
- **Chức năng**: Cập nhật thông tin cá nhân chi tiết
- **Cubit method**: `updatePersonalInformation()`
- **State**: `SettingPersonalInfoUpdated`

### 5. DELETE /api/v1/user/delete-my-account - Xóa tài khoản

- **File**: `account_deletion_page.dart`
- **Chức năng**: Xóa tài khoản vĩnh viễn với xác nhận bảo mật
- **Cubit method**: `deleteUserAccount()`
- **State**: `SettingAccountDeleted`

## Service Layer (setting_service.dart)

Tất cả 5 endpoints đã được implement với:

- Proper error handling
- Response mapping
- Dio HTTP client integration
- Timeout configuration

```dart
class SettingService {
  // 1. GET Profile
  Future<UserProfileModel> getUserProfile()

  // 2. UPDATE Profile
  Future<ApiResponse<UserProfileModel>> updateProfile({required UpdateProfileRequest request})

  // 3. Upload Avatar
  Future<ApiResponse<String>> uploadAvatar({required File avatarFile})

  // 4. Personal Information
  Future<ApiResponse<String>> updatePersonalInformation({required PersonalInformationRequest request})

  // 5. Delete Account
  Future<ApiResponse<String>> deleteUserAccount()
}
```

## State Management (setting_cubit.dart)

Các methods tương ứng trong Cubit:

- `loadUserProfile()` - Load user profile
- `updateProfile()` - Update profile with validation
- `uploadAvatarFromPicker()` - Upload avatar with file picker
- `updatePersonalInformation()` - Update personal info
- `deleteUserAccount()` - Delete account with confirmation

## State Classes (setting_state.dart)

- `SettingLoading` - Loading state
- `SettingLoaded` - Profile loaded successfully
- `SettingError` - Error handling
- `SettingProfileUpdating/Updated` - Profile update states
- `SettingAvatarUploading/Uploaded` - Avatar upload states
- `SettingPersonalInfoUpdating/Updated` - Personal info states
- `SettingAccountDeleting/Deleted` - Account deletion states

## UI/UX Design Pattern

Tất cả các trang đều tuân theo design pattern từ `setting_demo`:

- Background image với `TrainingAssets.mainBackground`
- Header với back button và title
- White container với rounded corners
- Consistent spacing và typography
- Loading overlays
- Error handling với SnackBar

## Main Setting Page (setting_page.dart)

Đã cập nhật để bao gồm navigation đến tất cả 5 chức năng:

- "Xem thông tin Profile" → ProfileViewPage
- "Cập nhật Profile" → ProfileUpdatePage
- "Upload Avatar" → AvatarUploadPage
- "Cập nhật thông tin cá nhân" → PersonalInformationUpdatePage
- "Xóa tài khoản vĩnh viễn" → AccountDeletionPage

## Tính năng đặc biệt

### Avatar Upload Page

- Mock implementation sẵn sàng cho image_picker
- Preview ảnh đã chọn
- Validation và error handling
- Instructions cho người dùng

### Account Deletion Page

- Multi-layer security confirmation
- Checkbox confirmation
- Text input confirmation ("XÓA TÀI KHOẢN")
- Final dialog confirmation
- Warning messages rõ ràng về việc mất dữ liệu vĩnh viễn

### Personal Information Update Page

- Form validation
- Date picker cho ngày sinh
- Email validation
- Phone number formatting
- Required field indicators

## Cần thêm dependencies

Để hoàn thiện tính năng upload avatar:

```yaml
dependencies:
  image_picker: ^1.0.4
```

## Kết luận

Đã triển khai thành công:
✅ 5 API endpoints trong service layer
✅ 5 cubit methods với proper state management  
✅ 5 trang UI riêng biệt với consistent design
✅ Navigation integration trong main setting page
✅ Error handling và loading states
✅ Form validation và security measures

Tính năng Setting hiện đã có cấu trúc modular với các chức năng riêng biệt, dễ bảo trì và mở rộng.
