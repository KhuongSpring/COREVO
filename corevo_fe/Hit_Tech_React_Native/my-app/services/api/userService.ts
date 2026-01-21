import apiClient from './client';
import type { UserProfileResponse, UpdateUserProfileRequest } from '@/types/user';

/**
 * User Service
 * Handles user profile and avatar operations
 */

export const userService = {
    /**
     * Get user profile
     */
    async getProfile(): Promise<UserProfileResponse> {
        const response = await apiClient.get<UserProfileResponse>('/users/profile');
        return response.data;
    },

    /**
     * Update personal information
     */
    async updatePersonalInformation(data: {
        password: string;
        profileData: {
            personalInformation: {
                firstName?: string;
                lastName?: string;
                phone?: string;
                birth?: string;
                nationality?: string;
                address?: {
                    province: string;
                    district: string;
                };
            };
            health?: {
                gender?: string;
                height?: number;
                weight?: number;
                age?: number;
                activityLevel?: string;
            };
        };
    }): Promise<UserProfileResponse> {
        const response = await apiClient.put<UserProfileResponse>('/users/profile', data);
        return response.data;
    },

    /**
     * Upload avatar image
     */
    async uploadAvatar(imageUri: string): Promise<{ linkAvatar: string }> {
        const formData = new FormData();

        // Create file object from image URI
        const filename = imageUri.split('/').pop() || 'avatar.jpg';
        const match = /\.(\w+)$/.exec(filename);
        const type = match ? `image/${match[1]}` : 'image/jpeg';

        formData.append('file', {
            uri: imageUri,
            name: filename,
            type,
        } as any);

        const response = await apiClient.post<{ linkAvatar: string }>(
            '/users/upload-avatar',
            formData,
            {
                headers: {
                    'Content-Type': 'multipart/form-data',
                },
            }
        );

        return response.data;
    },
};
