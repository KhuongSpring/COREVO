import axios, { AxiosInstance, AxiosError, InternalAxiosRequestConfig, AxiosResponse } from 'axios';
import { ApiEndpoints } from '@/constants/ApiEndpoints';
import { AppConfig } from '@/constants/AppConfig';
import { getAccessToken, saveAccessToken, getRefreshToken, clearTokens } from '@/services/storage';

/**
 * Axios API Client
 * Configured with base URL, timeout, and interceptors for auth and error handling
 */

// Create axios instance
const apiClient: AxiosInstance = axios.create({
    baseURL: ApiEndpoints.baseUrl,
    timeout: AppConfig.apiTimeout,
    headers: {
        'Content-Type': 'application/json',
    },
});

// ===== Request Interceptor =====
// Automatically attach access token to requests

apiClient.interceptors.request.use(
    async (config: InternalAxiosRequestConfig) => {
        const token = await getAccessToken();

        if (token && config.headers) {
            config.headers.Authorization = `Bearer ${token}`;
        }

        return config;
    },
    (error) => {
        return Promise.reject(error);
    }
);

// ===== Response Interceptor =====
// Handle token refresh and errors

let isRefreshing = false;
let failedQueue: Array<{
    resolve: (value?: unknown) => void;
    reject: (reason?: unknown) => void;
}> = [];

const processQueue = (error: AxiosError | null, token: string | null = null) => {
    failedQueue.forEach((prom) => {
        if (error) {
            prom.reject(error);
        } else {
            prom.resolve(token);
        }
    });

    failedQueue = [];
};

apiClient.interceptors.response.use(
    (response: AxiosResponse) => {
        // Return successful response
        return response;
    },
    async (error: AxiosError) => {
        const originalRequest = error.config as InternalAxiosRequestConfig & { _retry?: boolean };

        // If error is 401 and we haven't retried yet
        // Also skip refresh for auth endpoints (login, register, etc.)
        const isAuthRequest = originalRequest.url?.includes('/auth/');

        if (error.response?.status === 401 && !originalRequest._retry && !isAuthRequest) {
            if (isRefreshing) {
                // If already refreshing, queue this request
                return new Promise((resolve, reject) => {
                    failedQueue.push({ resolve, reject });
                })
                    .then((token) => {
                        if (originalRequest.headers) {
                            originalRequest.headers.Authorization = `Bearer ${token}`;
                        }
                        return apiClient(originalRequest);
                    })
                    .catch((err) => {
                        return Promise.reject(err);
                    });
            }

            originalRequest._retry = true;
            isRefreshing = true;

            try {
                // Get refresh token
                const refreshToken = await getRefreshToken();

                if (!refreshToken) {
                    // No refresh token, logout user
                    await clearTokens();
                    // TODO: Navigate to login screen
                    throw new Error('No refresh token available');
                }

                // Call refresh token endpoint
                const response = await axios.post(
                    ApiEndpoints.auth.refreshToken,
                    { refreshToken },
                    {
                        headers: { 'Content-Type': 'application/json' },
                    }
                );

                const newAccessToken = response.data.data.accessToken;

                // Save new access token
                await saveAccessToken(newAccessToken);

                // Update authorization header
                if (originalRequest.headers) {
                    originalRequest.headers.Authorization = `Bearer ${newAccessToken}`;
                }

                // Process queued requests
                processQueue(null, newAccessToken);

                // Retry original request
                return apiClient(originalRequest);
            } catch (refreshError) {
                // Token refresh failed, logout user
                processQueue(refreshError as AxiosError, null);
                await clearTokens();
                // TODO: Navigate to login screen
                return Promise.reject(refreshError);
            } finally {
                isRefreshing = false;
            }
        }

        // Return error for non-401 or already retried requests
        return Promise.reject(error);
    }
);

export default apiClient;
