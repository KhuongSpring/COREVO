/**
 * User Types - Extended
 * Complete user profile and health information types
 * Migrated from Flutter user models
 */

import { TrainingPlan } from './training';

// User Health Information
export interface UserHealth {
    gender?: string;
    height?: number;
    weight?: number;
    age?: number;
    activityLevel?: string;
    basalMetabolicRate?: number;
    maximumHeartRate?: number;
    tdee?: number;
}

// Personal Health Request
export interface PersonalHealthRequest {
    gender: string;
    age: number;
    height: number;
    weight: number;
    activityLevel: string;
}

// User Profile (Complete)
export interface UserProfile {
    id?: string;
    username?: string;
    email?: string;
    firstName?: string;
    lastName?: string;
    birth?: string;
    phone?: string;
    nationality?: string;
    linkAvatar?: string;
    userHealth?: UserHealth;
    trainingPlans?: TrainingPlan[];
}

// User Profile Response (API)
export interface UserProfileResponse {
    status: string;
    data: UserProfile;
}

// User Health Response (API)
export interface UserHealthResponse {
    status: string;
    data: UserHealth;
}

// Update User Profile Request
export interface UpdateUserProfileRequest {
    firstName?: string;
    lastName?: string;
    birth?: string;
    phone?: string;
    nationality?: string;
}

// Upload Avatar Request 
export interface UploadAvatarRequest {
    image: string; // Base64 or file path
}
