/**
 * App Fonts
 * Font family constants
 * Migrated from Flutter app_fontfamily.dart
 */

export const AppFonts = {
    poppins: 'Poppins',
    roboto: 'Roboto',
    // Uncomment if needed in the future:
    // lato: 'Lato',
    // montserrat: 'Montserrat',
    // openSans: 'Open Sans',
    // sourceSansPro: 'Source Sans Pro',
    // raleway: 'Raleway',
    // nunito: 'Nunito',
    // ubuntu: 'Ubuntu',
} as const;

export type AppFontKey = keyof typeof AppFonts;
