/**
 * Training Models - Complete
 * Comprehensive training system types migrated from Flutter
 * Includes: Plans, Exercises, Schedules, Progress, Flow
 */

// ==================== Training Plan ====================

export interface TrainingPlan {
    id: number;
    name: string;
    description: string;
    aim: string;
    goals: string;
    type: string;
    duration: string;
    frequency: string;
    levelIds: number[];
    locationIds: number[];
    equipmentIds: number[];
}

export interface TrainingPlanResponse {
    status: string;
    data: TrainingPlan;
}

export interface TrainingPlanListResponse {
    status: string;
    data: TrainingPlan[];
}

// ==================== Training Exercise ====================

export interface TrainingExercise {
    name: string;
    levelIds: number[];
    typeIds: number[];
    primaryMuscleIds: number[];
    secondaryMuscleIds: number[];
    equipmentIds: number[];
    locationIds: number[];
    minSet?: number;
    maxSet?: number;
    minRep?: number;
    maxRep?: number;
    minDuration?: number;
    maxDuration?: number;
    goalIds: number[];
    imageURL: string;
    description: string;
}

export interface TrainingExerciseResponse {
    status: string;
    data: TrainingExercise;
}

// Exercise Preview (for level-based search)
export interface TrainingExercisePreviewLevel {
    level: string;
    exercises: string[];
}

export interface TrainingExercisePreview {
    day: string;
    exercises: TrainingExercisePreviewLevel[];
}

// ==================== Training Schedule ====================

export interface TrainingScheduleExercise {
    name: string;
    sets?: number;
    reps?: number;
    duration?: number;
    restTime?: number;
}

export interface TrainingScheduleExerciseGroup {
    warmup: TrainingScheduleExercise[];
    mainExercises: TrainingScheduleExercise[];
    cooldown: TrainingScheduleExercise[];
}

export interface TrainingSchedule {
    dayOfWeek: string;
    name: string;
    duration?: string;
    location?: string;
    description: string;
    exerciseGroups?: TrainingScheduleExerciseGroup;
}

export interface TrainingScheduleResponse {
    status: string;
    data: TrainingSchedule;
}

export interface TrainingScheduleListResponse {
    status: string;
    data: TrainingSchedule[];
}

// ==================== Training Flow ====================

export interface TrainingFlowRequest {
    currentStep?: string;
    selectedValue: string[];
    selectedValues: Record<string, string[]>;
}

export interface TrainingFlowResponse {
    nextStep?: string;
    selectedValues: Record<string, string[]>;
    trainingPlans?: TrainingPlan[];
    options: string[];
    finalStep: boolean;
}

export interface TrainingFlowApiResponse {
    status: string;
    data: TrainingFlowResponse;
}

// ==================== Training Progress & Results ====================

export interface ExerciseSetProgress {
    setNumber: number;
    reps?: number;
    weight?: number;
    duration?: number;
    completed: boolean;
}

export interface TrainingPlanResult {
    planId: number;
    completedSessions: number;
    totalSessions: number;
    completionPercentage: number;
    startDate: string;
    lastCompletedDate?: string;
}

export interface TrainingScheduleResult {
    scheduleId: number;
    dayOfWeek: string;
    completedExercises: number;
    totalExercises: number;
    completionPercentage: number;
    completedAt?: string;
}

export interface TrainingProgressStatistic {
    totalWorkouts: number;
    totalDuration: number; // in minutes
    totalCaloriesBurned: number;
    currentStreak: number; // days
    longestStreak: number; // days
    averageWorkoutDuration: number; // in minutes
    mostActiveDay: string;
    completionRate: number; // percentage
    currentMonthCompletions?: number[]; // days of month with completed workouts
}

export interface TrainingProgressResponse {
    status: string;
    data: TrainingProgressStatistic;
}

// ==================== Training Dynamic Search ====================

export interface TrainingDynamicSearchRequest {
    level?: string;
    type?: string;
    equipment?: string;
    location?: string;
    muscle?: string;
    goal?: string;
}

export interface TrainingDynamicSearchResponse {
    status: string;
    data: TrainingPlan[];
}

// ==================== Enums & Constants ====================

export enum TrainingLevel {
    BEGINNER = 'BEGINNER',
    INTERMEDIATE = 'INTERMEDIATE',
    ADVANCED = 'ADVANCED',
}

export enum TrainingType {
    YOGA = 'YOGA',
    CALISTHENIC = 'CALISTHENIC',
    GYM = 'GYM',
    CARDIO = 'CARDIO',
}

export enum TrainingLocation {
    HOME = 'HOME',
    OUTSIDE = 'OUTSIDE',
    GYM = 'GYM',
    ANYWHERE = 'ANYWHERE',
}

export enum TrainingDuration {
    DURATION_30 = '30',
    DURATION_45 = '45',
    DURATION_60 = '60',
    DURATION_90 = '90',
}

export enum TrainingFrequency {
    ONCE = '1',
    TWICE = '2',
    THREE_TIMES = '3',
    FOUR_TIMES = '4',
    FIVE_TIMES = '5',
}

export enum DayOfWeek {
    MONDAY = 'MONDAY',
    TUESDAY = 'TUESDAY',
    WEDNESDAY = 'WEDNESDAY',
    THURSDAY = 'THURSDAY',
    FRIDAY = 'FRIDAY',
    SATURDAY = 'SATURDAY',
    SUNDAY = 'SUNDAY',
}

export enum MuscleGroup {
    ABS = 'ABS',
    BACK = 'BACK',
    BICEP = 'BICEP',
    CHEST = 'CHEST',
    GLUTE = 'GLUTE',
    HAMSTRING = 'HAMSTRING',
    QUAD = 'QUAD',
    SHOULDERS = 'SHOULDERS',
    TRICEP = 'TRICEP',
}

export enum TrainingGoal {
    BUILD_MUSCLE = 'BUILD_MUSCLE',
    LOSE_WEIGHT = 'LOSE_WEIGHT',
    STAY_FIT = 'STAY_FIT',
    INCREASE_STRENGTH = 'INCREASE_STRENGTH',
    IMPROVE_ENDURANCE = 'IMPROVE_ENDURANCE',
    FLEXIBILITY = 'FLEXIBILITY',
}

// ==================== Common Response Wrapper ====================

export interface DefaultResponse<T> {
    status: string;
    message?: string;
    data?: T;
}

export interface ListDefaultResponse<T> {
    status: string;
    message?: string;
    data: T[];
    totalPages?: number;
    currentPage?: number;
    totalItems?: number;
}
