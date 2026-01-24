/**
 * App Color Palette
 * Migrated from Flutter app_color.dart
 * 
 * @deprecated For new components, prefer using ThemeColors from '@/constants/ThemeColors'
 * and the useTheme() hook for theme-aware colors.
 * These static colors are kept for backward compatibility and specific use cases
 * where colors should not change with theme (e.g., brand logos, specific UI elements).
 */


export const Colors = {
  // Blue shades
  bLight: '#e8f4fc',
  bLightHover: '#dceefb',
  bLightNotActive: '#9DC4E0',
  bLightNotActive2: '#D4EDFF',
  bLightActive: '#b6dbf6',
  bLightActive2: '#53B4FE',
  bNormal: '#148ce2',
  bNormalHover: '#127ecb',
  bNormalActive: '#1070b5',
  bDark: '#0f69aa',
  bDarkHover: '#0c5488',
  bDarkActive: '#093f66',
  bDarker: '#07314f',
  bDarkerLogo: '#112947',

  // Black/Gray shades
  moreLighter: '#b6b6b6',
  lighter: '#8c8c8c',
  lightHover: '#757575',
  lightActive: '#595959',
  normal: '#000000',
  normalHover: '#000000',
  normalActive: '#000000',
  dark: '#000000',
  darkHover: '#000000',
  darkActive: '#000000',

  // White shades
  wWhite: '#ffffff',
  wWhiteHover: '#fcfdfd',
  wWhiteActive: '#f5f7f9',
  wLight: '#fcfdfd',
  wLightHover: '#f5f7f9',
  wLightActive: '#f0f3f6',
  wNormal: '#f9fafb',
  wNormalHover: '#f2f4f7',
  wNormalActive: '#ebeef2',
  wNormalNonActive: '#D2DDE6',
  wDark: '#dadada',

  // Health Information Colors
  bgHealthInfor: '#EDF3F8',
  iconHealthInfor: '#B2B7BC',
  bgGenderSelection: '#E3F2FD',
  textGenderSelection: '#07314F',
  buttonBGBottomGenderFocus: '#2196F3',
  buttonBGBottomGender: '#E0E0E0',
  buttonTextGenderFocus: '#FFFFFF',
  buttonTextGender: '#9E9E9E',
  prizeSelected: '#E5E8FF',
} as const;

export type ColorKey = keyof typeof Colors;
