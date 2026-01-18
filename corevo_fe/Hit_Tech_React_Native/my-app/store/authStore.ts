import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';
import AsyncStorage from '@react-native-async-storage/async-storage';
import * as authService from '@/services/authService';
import * as storage from '@/services/storage';
import type { LoginRequest, OAuth2GoogleRequest } from '@/types/auth';

/**
 * Authentication Store
 * Manages authentication state, tokens, and auth actions
 */

interface AuthState {
    // State
    isAuthenticated: boolean;
    accessToken: string | null;
    refreshToken: string | null;
    isLoading: boolean;
    error: string | null;

    // Actions
    login: (credentials: LoginRequest) => Promise<void>;
    loginWithGoogle: (googleToken: string) => Promise<void>;
    logout: () => Promise<void>;
    refreshAccessToken: () => Promise<void>;
    clearError: () => void;
    setTokens: (accessToken: string, refreshToken: string) => void;
    checkAuthStatus: () => Promise<void>;
}

export const useAuthStore = create<AuthState>()(
    persist(
        (set, get) => ({
            // Initial state
            isAuthenticated: false,
            accessToken: null,
            refreshToken: null,
            isLoading: false,
            error: null,

            // ===== Actions =====

            /**
             * Login with username and password
             */
            login: async (credentials: LoginRequest) => {
                set({ isLoading: true, error: null });
                try {
                    const response = await authService.login(credentials);

                    if (response.status === 'SUCCESS' && response.data.accessToken && response.data.refreshToken) {
                        // Save tokens to storage
                        await storage.saveAccessToken(response.data.accessToken);
                        await storage.saveRefreshToken(response.data.refreshToken);

                        if (response.data.userId) {
                            await storage.saveUserId(response.data.userId);
                        }

                        set({
                            isAuthenticated: true,
                            accessToken: response.data.accessToken,
                            refreshToken: response.data.refreshToken,
                            isLoading: false,
                            error: null,
                        });
                    } else {
                        throw new Error(response.message || 'Login failed');
                    }
                } catch (error: any) {
                    const errorMessage = error.response?.data?.message || error.message || 'Login failed';
                    set({
                        error: errorMessage,
                        isLoading: false,
                        isAuthenticated: false,
                    });
                    throw error;
                }
            },

            /**
             * Login with Google OAuth
             */
            loginWithGoogle: async (googleToken: string) => {
                set({ isLoading: true, error: null });
                try {
                    const request: OAuth2GoogleRequest = { token: googleToken };
                    const response = await authService.loginWithGoogle(request);

                    if (response.status === 'SUCCESS' && response.data.accessToken && response.data.refreshToken) {
                        await storage.saveAccessToken(response.data.accessToken);
                        await storage.saveRefreshToken(response.data.refreshToken);

                        if (response.data.userId) {
                            await storage.saveUserId(response.data.userId);
                        }

                        set({
                            isAuthenticated: true,
                            accessToken: response.data.accessToken,
                            refreshToken: response.data.refreshToken,
                            isLoading: false,
                            error: null,
                        });
                    } else {
                        throw new Error(response.message || 'Google login failed');
                    }
                } catch (error: any) {
                    const errorMessage = error.response?.data?.message || error.message || 'Google login failed';
                    set({
                        error: errorMessage,
                        isLoading: false,
                    });
                    throw error;
                }
            },

            /**
             * Logout user
             */
            logout: async () => {
                const { accessToken } = get();
                try {
                    if (accessToken) {
                        await authService.logout(accessToken);
                    }
                } catch (error) {
                    console.error('Logout API call failed:', error);
                } finally {
                    // Clear tokens from storage
                    await storage.clearTokens();
                    await storage.clearUserId();

                    // Reset state
                    set({
                        isAuthenticated: false,
                        accessToken: null,
                        refreshToken: null,
                        error: null,
                    });
                }
            },

            /**
             * Refresh access token
             */
            refreshAccessToken: async () => {
                try {
                    const newAccessToken = await authService.refreshAccessToken();

                    if (newAccessToken) {
                        set({ accessToken: newAccessToken });
                    } else {
                        // Refresh failed, logout user
                        await get().logout();
                        throw new Error('Token refresh failed');
                    }
                } catch (error) {
                    await get().logout();
                    throw error;
                }
            },

            /**
             * Clear error
             */
            clearError: () => {
                set({ error: null });
            },

            /**
             * Set tokens manually (useful after registration)
             */
            setTokens: (accessToken: string, refreshToken: string) => {
                set({
                    accessToken,
                    refreshToken,
                    isAuthenticated: true,
                });
            },

            /**
             * Check authentication status on app start
             */
            checkAuthStatus: async () => {
                const accessToken = await storage.getAccessToken();
                const refreshToken = await storage.getRefreshToken();

                if (accessToken && refreshToken) {
                    set({
                        isAuthenticated: true,
                        accessToken,
                        refreshToken,
                    });
                } else {
                    set({
                        isAuthenticated: false,
                        accessToken: null,
                        refreshToken: null,
                    });
                }
            },
        }),
        {
            name: 'auth-storage',
            storage: createJSONStorage(() => AsyncStorage),
            partialize: (state) => ({
                isAuthenticated: state.isAuthenticated,
                accessToken: state.accessToken,
                refreshToken: state.refreshToken,
            }),
        }
    )
);
