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
    TrainingPlanResultResponse,
    TrainingPlanResponse,
    TrainingExerciseResponse,
    TrainingExercisePreviewLevel,
    DefaultResponse,
    ListDefaultResponse,
    TrainingDynamicSearchRequest,
    TrainingExercisePreview,
} from '@/types/training';

export const trainingService = {
    // ==================== Training Plans ====================

    /**
     * Get all training plans with pagination
     * @param page - Page number (1-indexed)
     * @param size - Number of items per page
     */
    async getAllTrainingPlan(pageNum: number, pageSize: number): Promise<TrainingPlanResultResponse> {
        const response = await apiClient.get(ApiEndpoints.trainingResource.getAllPlans, {
            params: { pageNum, pageSize },
        });
        return response.data;
    },

    /**
     * Get training plan by ID
     * @param id - Training plan ID
     */
    async getTrainingPlanById(id: number): Promise<TrainingPlanResponse> {
        const response = await apiClient.get(ApiEndpoints.trainingResource.getTrainingPlanById(id));
        return response.data;
    },

    /**
     * Get training plans by type
     * @param type - Training type (CARDIO, GYM, YOGA, CALISTHENIC)
     * @param pageNum - Page number (1-indexed)
     * @param pageSize - Number of items per page
     */
    async getTrainingPlanByType(
        type: string,
        pageNum: number,
        pageSize: number
    ): Promise<TrainingPlanResultResponse> {
        const response = await apiClient.get(ApiEndpoints.trainingPlanFlow.getTrainingPlanByType, {
            params: { type, pageNum, pageSize },
        });
        return response.data;
    },

    // ==================== Training Exercises ====================

    /**
     * Get exercise by ID
     * @param id - Exercise ID
     */
    async getExerciseById(id: number): Promise<TrainingExerciseResponse> {
        const response = await apiClient.get(ApiEndpoints.trainingExercise.getExercise(id));
        return response.data;
    },

    /**
     * Get exercises by target muscle
     * @param primaryMuscle - Target muscle (Chest, Back, Shoulders, etc.)
     * @param pageNum - Page number (1-indexed)
     * @param pageSize - Number of items per page
     */
    async getTrainingExerciseByTargetMuscle(
        primaryMuscle: string,
        pageNum: number,
        pageSize: number
    ): Promise<ListDefaultResponse<TrainingExercisePreviewLevel>> {
        const response = await apiClient.get(
            ApiEndpoints.trainingExercise.getExerciseByPrimaryMuscle,
            {
                params: { primaryMuscle, pageNum, pageSize },
            }
        );
        return response.data;
    },

    /**
     * Get exercises by type
     * @param type - Training type (Cardio, Yoga, Calisthenic)
     * @param pageNum - Page number (1-indexed)
     * @param pageSize - Number of items per page
     */
    async getTrainingExerciseByType(
        type: string,
        pageNum: number,
        pageSize: number
    ): Promise<ListDefaultResponse<TrainingExercisePreviewLevel>> {
        const response = await apiClient.get(ApiEndpoints.trainingExercise.getExerciseByType, {
            params: { type, pageNum, pageSize },
        });
        return response.data;
    },

    // ==================== Training Schedule ====================

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

    // ==================== Search ====================

    /**
     * Dynamic search for training plans
     * @param request - Search criteria (level, type, equipment, location, muscle, goal)
     */
    async searchDynamicTrainingPlan(
        request: TrainingDynamicSearchRequest
    ): Promise<DefaultResponse<number[]>> {
        const response = await apiClient.post(
            ApiEndpoints.trainingExercise.searchDynamicTrainingPlan,
            request
        );
        return response.data;
    },

    /**
     * Dynamic search for training exercises
     * @param request - Search criteria (level, type, equipment, location, muscle, goal)
     */
    async searchDynamicTrainingExercise(
        request: TrainingDynamicSearchRequest
    ): Promise<ListDefaultResponse<TrainingExercisePreview>> {
        const response = await apiClient.post(
            ApiEndpoints.trainingExercise.searchDynamicTrainingExercise,
            request
        );
        return response.data;
    },

    // ==================== Progress ====================

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
