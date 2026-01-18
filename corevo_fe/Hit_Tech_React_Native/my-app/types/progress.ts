/**
 * Progress Types
 * TypeScript interfaces for tracking user progress and achievements
 */

export interface ProgressStats {
    id: string;
    userId: string;
    date: string;
    weight?: number;
    bodyFat?: number;
    muscleMass?: number;
    measurements?: BodyMeasurements;
    photos?: ProgressPhoto[];
    notes?: string;
    createdAt: string;
}

export interface BodyMeasurements {
    chest?: number;
    waist?: number;
    hips?: number;
    arms?: number;
    thighs?: number;
    calves?: number;
    shoulders?: number;
    neck?: number;
    unit: 'CM' | 'INCH';
}

export interface ProgressPhoto {
    id: string;
    url: string;
    angle: PhotoAngle;
    uploadedAt: string;
}

export type PhotoAngle =
    | 'FRONT'
    | 'BACK'
    | 'SIDE_LEFT'
    | 'SIDE_RIGHT';

export interface Achievement {
    id: string;
    type: AchievementType;
    title: string;
    description: string;
    iconUrl: string;
    unlockedAt?: string;
    progress: number;
    target: number;
    isUnlocked: boolean;
}

export type AchievementType =
    | 'WORKOUT_STREAK'
    | 'TOTAL_WORKOUTS'
    | 'WEIGHT_MILESTONE'
    | 'STRENGTH_MILESTONE'
    | 'ENDURANCE_MILESTONE'
    | 'CONSISTENCY';

export interface WeeklyProgressSummary {
    week: string;
    workoutsCompleted: number;
    totalDuration: number;
    caloriesBurned: number;
    averageCalories: number;
    weightChange?: number;
}

export interface MonthlyProgressSummary {
    month: string;
    workoutsCompleted: number;
    totalDuration: number;
    caloriesBurned: number;
    averageCalories: number;
    weightChange?: number;
    bodyFatChange?: number;
}
