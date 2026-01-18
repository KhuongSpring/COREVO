/**
 * Training Types
 * TypeScript interfaces for training-related models
 */

export interface TrainingPlan {
    id: string;
    userId: string;
    name: string;
    goal: TrainingGoal;
    experienceLevel: ExperienceLevel;
    daysPerWeek: number;
    durationMinutes: number;
    equipment: Equipment[];
    focusAreas: FocusArea[];
    startDate: string;
    endDate?: string;
    isActive: boolean;
    createdAt: string;
    updatedAt: string;
}

export interface TrainingSession {
    id: string;
    planId: string;
    dayOfWeek: DayOfWeek;
    exercises: ExerciseSet[];
    totalDuration: number;
    caloriesBurned?: number;
    completed: boolean;
    completedAt?: string;
}

export interface ExerciseSet {
    id: string;
    exerciseId: string;
    exercise: Exercise;
    sets: number;
    reps: number;
    weight?: number;
    duration?: number;
    restTime: number;
    notes?: string;
}

export interface Exercise {
    id: string;
    name: string;
    nameVi: string;
    description: string;
    descriptionVi: string;
    category: ExerciseCategory;
    muscleGroups: MuscleGroup[];
    equipment: Equipment[];
    difficulty: Difficulty;
    videoUrl?: string;
    thumbnailUrl?: string;
    instructions: string[];
    tips?: string[];
}

export interface WorkoutLog {
    id: string;
    userId: string;
    sessionId: string;
    exerciseId: string;
    sets: number;
    reps: number;
    weight?: number;
    duration?: number;
    completedAt: string;
    notes?: string;
}

// Enums
export type TrainingGoal =
    | 'BUILD_MUSCLE'
    | 'LOSE_WEIGHT'
    | 'STAY_FIT'
    | 'INCREASE_STRENGTH'
    | 'IMPROVE_ENDURANCE'
    | 'FLEXIBILITY';

export type ExperienceLevel =
    | 'BEGINNER'
    | 'INTERMEDIATE'
    | 'ADVANCED'
    | 'EXPERT';

export type DayOfWeek =
    | 'MON'
    | 'TUE'
    | 'WED'
    | 'THU'
    | 'FRI'
    | 'SAT'
    | 'SUN';

export type Equipment =
    | 'NONE'
    | 'DUMBBELL'
    | 'BARBELL'
    | 'KETTLEBELL'
    | 'RESISTANCE_BAND'
    | 'CABLE'
    | 'MACHINE'
    | 'BODYWEIGHT'
    | 'FULL_GYM';

export type FocusArea =
    | 'CHEST'
    | 'BACK'
    | 'SHOULDERS'
    | 'ARMS'
    | 'ABS'
    | 'LEGS'
    | 'CARDIO'
    | 'FULL_BODY';

export type ExerciseCategory =
    | 'STRENGTH'
    | 'CARDIO'
    | 'FLEXIBILITY'
    | 'BALANCE'
    | 'HIIT'
    | 'YOGA'
    | 'PILATES';

export type MuscleGroup =
    | 'CHEST'
    | 'BACK'
    | 'SHOULDERS'
    | 'BICEPS'
    | 'TRICEPS'
    | 'FOREARMS'
    | 'ABS'
    | 'OBLIQUES'
    | 'LOWER_BACK'
    | 'QUADS'
    | 'HAMSTRINGS'
    | 'CALVES'
    | 'GLUTES';

export type Difficulty =
    | 'BEGINNER'
    | 'INTERMEDIATE'
    | 'ADVANCED';

// API Request/Response Types
export interface CreateTrainingPlanRequest {
    goal: TrainingGoal;
    experienceLevel: ExperienceLevel;
    daysPerWeek: number;
    durationMinutes: number;
    equipment: Equipment[];
    focusAreas: FocusArea[];
}

export interface TrainingPlanResponse {
    plan: TrainingPlan;
    sessions: TrainingSession[];
}

export interface WorkoutProgressResponse {
    totalWorkouts: number;
    totalDuration: number;
    totalCalories: number;
    currentStreak: number;
    longestStreak: number;
    completedExercises: number;
    recentWorkouts: WorkoutLog[];
}
