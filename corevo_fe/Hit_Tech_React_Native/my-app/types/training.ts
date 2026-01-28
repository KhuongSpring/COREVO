/**
 * Training Types
 * Training plan, schedule, and progress-related types
 * Migrated from Flutter training models - Exact match
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

export interface TrainingPlanResultResponse {
    status: string;
    data: {
        items: TrainingPlan[];
    };
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

// Exercise Preview (simplified view)
export interface TrainingExercisePreview {
    id: number;
    name: string;
    imageURL: string;
    description: string;
    levelName: string;
}

export interface TrainingExercisePreviewLevel {
    levelName: string;
    exercises: TrainingExercisePreview[];
}

// ==================== Training Schedule ====================

// Individual exercise in a schedule
export interface TrainingScheduleExercise {
    exerciseId: number;
    duration: string;
}

// Exercise group (contains list of exercises + note)
export interface TrainingScheduleExerciseGroup {
    note?: string;
    exercises: TrainingScheduleExercise[];
}

// Daily training schedule
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

// Schedule result (7 days)
export interface TrainingScheduleResultResponse {
    status: string;
    data: {
        userId: number | null;
        trainingPlanId: number;
        days: TrainingSchedule[];
    };
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

// ==================== Training Progress & Statistics ====================

// Progress statistic (monthly view)
export interface TrainingProgressStatistic {
    month: string;
    year: number;
    currentMonthCompletions: boolean[]; // Array of booleans for each day
    currentStreak: number;
    longestStreak: number;
}

export interface TrainingProgressResponse {
    status: string;
    data: TrainingProgressStatistic;
}

// Daily progress
export interface DailyProgressData {
    percentage: number;
    completedExercises?: number;
    totalExercises?: number;
}

export interface DailyProgressResponse {
    status: string;
    data: DailyProgressData;
}

// ==================== Training Plan & Schedule Results ====================

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
