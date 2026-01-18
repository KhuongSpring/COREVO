/**
 * User Types
 * User profile and health information interfaces
 */

// ===== User Profile =====

export interface User {
    id: string;
    username: string;
    email: string;
    fullName: string;
    phoneNumber?: string;
    avatar?: string;
    createdAt?: string;
    updatedAt?: string;
}

// ===== User Health Profile =====

export interface UserHealth {
    id: string;
    userId: string;
    gender?: 'MALE' | 'FEMALE' | 'OTHER';
    age?: number;
    height?: number; // cm
    weight?: number; // kg
    bmi?: number;
    targetWeight?: number;
    activityLevel?: 'SEDENTARY' | 'LIGHTLY_ACTIVE' | 'MODERATELY_ACTIVE' | 'VERY_ACTIVE' | 'EXTRA_ACTIVE';
    medicalConditions?: string[];
    allergies?: string[];
    createdAt?: string;
    updatedAt?: string;
}

// ===== User with Health Profile =====

export interface UserWithHealth extends User {
    healthProfile?: UserHealth;
}

// ===== User Profile Response =====

export interface UserProfileResponse {
    status: string;
    message?: string;
    user: User;
    userHealth?: UserHealth;
    trainingPlans?: any[]; // Will be defined in training.ts
}

// ===== Update Profile Request =====

export interface UpdateProfileRequest {
    fullName?: string;
    phoneNumber?: string;
    avatar?: string;
}

// ===== Update Health Profile Request =====

export interface UpdateHealthProfileRequest {
    gender?: 'MALE' | 'FEMALE' | 'OTHER';
    age?: number;
    height?: number;
    weight?: number;
    targetWeight?: number;
    activityLevel?: 'SEDENTARY' | 'LIGHTLY_ACTIVE' | 'MODERATELY_ACTIVE' | 'VERY_ACTIVE' | 'EXTRA_ACTIVE';
    medicalConditions?: string[];
    allergies?: string[];
}
