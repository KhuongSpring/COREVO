/**
 * Exercise Progress Types
 * Types for tracking exercise set completion and daily progress
 */

export interface ExerciseSetProgress {
    exerciseId: number;
    totalSets: number;
    setCompleted: boolean[];
}

export interface DailyProgressData {
    completions: Record<string, boolean>;
}
