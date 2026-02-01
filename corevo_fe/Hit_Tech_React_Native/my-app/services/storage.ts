import AsyncStorage from '@react-native-async-storage/async-storage';
import { AppConfig } from '@/constants/AppConfig';

/**
 * AsyncStorage wrapper with type-safe methods
 * Provides simple get/set/remove operations for local storage
 */

/**
 * Save a value to storage
 */
export const setItem = async (key: string, value: string): Promise<void> => {
    try {
        await AsyncStorage.setItem(key, value);
    } catch (error) {
        console.error(`Error saving ${key} to storage:`, error);
        throw error;
    }
};

/**
 * Get a value from storage
 */
export const getItem = async (key: string): Promise<string | null> => {
    try {
        return await AsyncStorage.getItem(key);
    } catch (error) {
        console.error(`Error getting ${key} from storage:`, error);
        return null;
    }
};

/**
 * Remove a value from storage
 */
export const removeItem = async (key: string): Promise<void> => {
    try {
        await AsyncStorage.removeItem(key);
    } catch (error) {
        console.error(`Error removing ${key} from storage:`, error);
        throw error;
    }
};

/**
 * Clear all storage
 */
export const clearAll = async (): Promise<void> => {
    try {
        await AsyncStorage.clear();
    } catch (error) {
        console.error('Error clearing storage:', error);
        throw error;
    }
};

/**
 * Save object to storage (JSON stringified)
 */
export const setObject = async (key: string, value: object): Promise<void> => {
    try {
        const jsonValue = JSON.stringify(value);
        await AsyncStorage.setItem(key, jsonValue);
    } catch (error) {
        console.error(`Error saving object ${key} to storage:`, error);
        throw error;
    }
};

/**
 * Get object from storage (JSON parsed)
 */
export const getObject = async <T>(key: string): Promise<T | null> => {
    try {
        const jsonValue = await AsyncStorage.getItem(key);
        return jsonValue != null ? JSON.parse(jsonValue) : null;
    } catch (error) {
        console.error(`Error getting object ${key} from storage:`, error);
        return null;
    }
};

// ===== Token Management =====

export const saveAccessToken = async (token: string): Promise<void> => {
    await setItem(AppConfig.storageKeys.accessToken, token);
};

export const getAccessToken = async (): Promise<string | null> => {
    return await getItem(AppConfig.storageKeys.accessToken);
};

export const saveRefreshToken = async (token: string): Promise<void> => {
    await setItem(AppConfig.storageKeys.refreshToken, token);
};

export const getRefreshToken = async (): Promise<string | null> => {
    return await getItem(AppConfig.storageKeys.refreshToken);
};

export const clearTokens = async (): Promise<void> => {
    await removeItem(AppConfig.storageKeys.accessToken);
    await removeItem(AppConfig.storageKeys.refreshToken);
};

// ===== Onboarding =====

export const setSeenOnboarding = async (seen: boolean): Promise<void> => {
    await setItem(AppConfig.storageKeys.seenOnboarding, seen.toString());
};

export const getSeenOnboarding = async (): Promise<boolean> => {
    const value = await getItem(AppConfig.storageKeys.seenOnboarding);
    return value === 'true';
};

// ===== User ID =====

export const saveUserId = async (userId: string): Promise<void> => {
    await setItem(AppConfig.storageKeys.userId, userId);
};

export const getUserId = async (): Promise<string | null> => {
    return await getItem(AppConfig.storageKeys.userId);
};

export const clearUserId = async (): Promise<void> => {
    await removeItem(AppConfig.storageKeys.userId);
};

// ===== Check Login Status =====

export const isLoggedIn = async (): Promise<boolean> => {
    const accessToken = await getAccessToken();
    return accessToken !== null;
};
