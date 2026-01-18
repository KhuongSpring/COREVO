import { Dimensions as RNDimensions, PixelRatio } from 'react-native';

/**
 * Responsive Dimensions
 * Migrated from Flutter app_dimension.dart
 * Uses similar scaling approach to flutter_screenutil
 */

// Design size (same as Flutter: 412 x 917)
const DESIGN_WIDTH = 412;
const DESIGN_HEIGHT = 917;

// Get device dimensions
const { width: DEVICE_WIDTH, height: DEVICE_HEIGHT } = RNDimensions.get('window');

// Scale factors
const widthScale = DEVICE_WIDTH / DESIGN_WIDTH;
const heightScale = DEVICE_HEIGHT / DESIGN_HEIGHT;

/**
 * Scale width proportionally
 */
export const scaleWidth = (size: number): number => {
    return PixelRatio.roundToNearestPixel(size * widthScale);
};

/**
 * Scale height proportionally
 */
export const scaleHeight = (size: number): number => {
    return PixelRatio.roundToNearestPixel(size * heightScale);
};

/**
 * Scale font size
 */
export const scaleFont = (size: number): number => {
    return PixelRatio.roundToNearestPixel(size * widthScale);
};

/**
 * Scale size (for width/height that should maintain aspect ratio)
 */
export const scale = (size: number): number => {
    return PixelRatio.roundToNearestPixel(size * Math.min(widthScale, heightScale));
};

/**
 * App Dimensions
 * All values are scaled based on design size
 */
export const Dims = {
    // Device dimensions
    width: DEVICE_WIDTH,
    height: DEVICE_HEIGHT,

    // Spacing
    spacingXS: scaleWidth(4),
    spacingS: scaleWidth(8),
    spacingSM: scaleWidth(12),
    spacingM: scaleWidth(16),
    spacingML: scaleWidth(20),
    spacingL: scaleWidth(24),
    spacingXL: scaleWidth(32),
    spacingXXL: scaleWidth(40),
    spacingXXXL: scaleWidth(48),
    spacingHuge: scaleWidth(56),
    spacingGiant: scaleWidth(64),

    // Padding
    paddingXS: scaleWidth(4),
    paddingS: scaleWidth(8),
    paddingM: scaleWidth(16),
    paddingL: scaleWidth(24),
    paddingXL: scaleWidth(32),
    paddingXXL: scaleWidth(40),
    paddingXXXL: scaleWidth(48),

    // Text sizes
    textSizeXS: scaleFont(12),
    textSizeS: scaleFont(14),
    textSizeM: scaleFont(16),
    textSizeL: scaleFont(20),
    textSizeXL: scaleFont(24),
    textSizeXXL: scaleFont(28),
    textSizeXXXL: scaleFont(32),

    // Icon sizes
    iconSizeXS: scaleFont(12),
    iconSizeS: scaleFont(14),
    iconSizeM: scaleFont(16),
    iconSizeL: scaleFont(20),
    iconSizeXL: scaleFont(24),
    iconSizeXXL: scaleFont(28),
    iconSizeXXXL: scaleFont(32),

    // Border radius
    borderRadiusTiny: scale(4),
    borderRadiusSmall: scale(10),
    borderRadius: scale(12),
    borderRadiusLarge: scale(28),

    // Common sizes
    size4: scaleWidth(4),
    size8: scaleWidth(8),
    size16: scaleWidth(16),
    size24: scaleWidth(24),
    size28: scaleWidth(28),
    size32: scaleWidth(32),
    size40: scaleWidth(40),
    size48: scaleWidth(48),
    size56: scaleWidth(56),
    size64: scaleWidth(64),
    size72: scaleWidth(72),
    size80: scaleWidth(80),
    size88: scaleWidth(88),
    size96: scaleWidth(96),
    size104: scaleWidth(104),
    size112: scaleWidth(112),
    size120: scaleWidth(120),
    size128: scaleWidth(128),
    size136: scaleWidth(136),
    size144: scaleWidth(144),
    size152: scaleWidth(152),
    size160: scaleWidth(160),
    size168: scaleWidth(168),
    size176: scaleWidth(176),
    size184: scaleWidth(184),
    size192: scaleWidth(192),
    size200: scaleWidth(200),
    size208: scaleWidth(208),
    size216: scaleWidth(216),
    size224: scaleWidth(224),
    size232: scaleWidth(232),
    size240: scaleWidth(240),
    size248: scaleWidth(248),
    size256: scaleWidth(256),
    size264: scaleWidth(264),
    size272: scaleWidth(272),
    size280: scaleWidth(280),
    size288: scaleWidth(288),
    size296: scaleWidth(296),
    size304: scaleWidth(304),
    size312: scaleWidth(312),
    size320: scaleWidth(320),
    size328: scaleWidth(328),
    size336: scaleWidth(336),
    size344: scaleWidth(344),
    size352: scaleWidth(352),
    size360: scaleWidth(360),
    size368: scaleWidth(368),
    size376: scaleWidth(376),
    size384: scaleWidth(384),
    size392: scaleWidth(392),
    size400: scaleWidth(400),

    // Special heights
    heightButton: scaleHeight(50),
} as const;

export type DimensionKey = keyof typeof Dims;
