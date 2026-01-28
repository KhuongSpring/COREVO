/**
 * Training Service
 * Handles all training-related API calls
 */

import apiClient from './client';
import { ApiEndpoints } from '@/constants/ApiEndpoints';
import type {
    TrainingScheduleResultResponse,
    DailyProgressResponse,
    TrainingProgressResponse,
} from '@/types/training';

export const trainingService = {
    /**
     * Get training schedule by plan ID
     * Uses query parameter "planId" (camelCase)
     */
    async getTrainingScheduleById(planId: number): Promise<TrainingScheduleResultResponse> {
        const response = await apiClient.get(ApiEndpoints.trainingSchedule.getTrainingSchedule, {
            params: {
                planId: planId,
            },
        });
        return response.data;
    },

    /**
     * Get daily progress
     */
    async getDailyProgress(): Promise<DailyProgressResponse> {
        const response = await apiClient.get(ApiEndpoints.trainingProgress.getDailyProgress);
        return response.data;
    },

    /**
     * Get progress statistics for a specific month
     * Uses query parameters "year" and "month"
     */
    async getStatistic(year: number, month: number): Promise<TrainingProgressResponse> {
        const response = await apiClient.get(ApiEndpoints.trainingProgress.getStatistic, {
            params: {
                year: year,
                month: month,
            },
        });
        return response.data;
    },

    /**
     * Get weekly progress
     */
    async getWeeklyProgress(): Promise<any> {
        const response = await apiClient.get(ApiEndpoints.trainingProgress.getWeeklyProgress);
        return response.data;
    },

    /**
     * Complete an exercise
     */
    async completeExercise(exerciseId: number): Promise<any> {
        const response = await apiClient.post(ApiEndpoints.trainingProgress.completeExercise, {
            exerciseId,
        });
        return response.data;
    },
};
