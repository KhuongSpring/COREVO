/**
 * API Endpoints Configuration
 * Migrated from Flutter api_endpoint.dart
 */

// Base URL - Update this based on your environment
// const BASE_URL = 'http://192.168.1.8:8080'; // Cty
const BASE_URL = 'http://192.168.1.23:8080'; // Cty 2 (AI)

// const BASE_URL = 'http://192.168.50.240:8080'; // Nha
// const BASE_URL = 'http://172.20.10.3:8080'; // Iphone share wf
// const BASE_URL = 'http://localhost:8080'; // iOS simulator
// const BASE_URL = 'http://146.190.101.127:8080'; // Production

// API Version  
const VERSION = `${BASE_URL}/api/v1`;

// Base Endpoints
const USER_ENDPOINT = `${VERSION}/user`;
const USER_HEALTH_ENDPOINT = `${VERSION}/user-health`;
const TRAINING_PROGRESS = `${VERSION}/training/progress`;
const TRAINING_EXERCISE = `${VERSION}/training/exercise`;
const TRAINING_PLAN_FLOW = `${VERSION}/training-plan`;
const AUTH = `${VERSION}/auth`;
const TRAINING_SCHEDULE = `${VERSION}/training/schedule`;
const TRAINING_RESOURCE = `${VERSION}/training/resource`;
const POLICY = `${VERSION}/policy`;

export const ApiEndpoints = {
    // Base
    baseUrl: BASE_URL,
    version: VERSION,

    // User Endpoints
    user: {
        updateProfile: `${USER_ENDPOINT}/update-profile`,
        uploadAvatar: `${USER_ENDPOINT}/upload-avatar`,
        fillPersonalInformation: `${USER_ENDPOINT}/personal-information`,
        getProfile: `${USER_ENDPOINT}/profile`,
        deleteMyAccount: `${USER_ENDPOINT}/delete-my-account`,
    },

    // User Health Endpoints
    userHealth: {
        fillHealthInformation: `${USER_HEALTH_ENDPOINT}/health-information`,
    },

    // Training Progress Endpoints
    trainingProgress: {
        completeExercise: `${TRAINING_PROGRESS}/complete`,
        getWeeklyProgress: `${TRAINING_PROGRESS}/weekly`,
        getStatistic: `${TRAINING_PROGRESS}/statistic`,
        getDailyProgress: `${TRAINING_PROGRESS}/daily`,
    },

    // Training Exercise Endpoints
    trainingExercise: {
        search: `${TRAINING_EXERCISE}/search`,
        getExercise: (id: number) => `${TRAINING_EXERCISE}/${id}`,
        getExerciseByType: `${TRAINING_EXERCISE}/type`,
        getExerciseByPrimaryMuscle: `${TRAINING_EXERCISE}/target-muscle`,
        getExerciseByGoal: `${TRAINING_EXERCISE}/goal`,
        searchDynamicTrainingPlan: `${TRAINING_EXERCISE}/search/training-plan`,
        searchDynamicTrainingExercise: `${TRAINING_EXERCISE}/search/training-exercise`,
    },

    // Training Plan Flow Endpoints
    trainingPlanFlow: {
        flowStep: `${TRAINING_PLAN_FLOW}/step`,
        reset: `${TRAINING_PLAN_FLOW}/reset`,
        getTrainingPlanByType: TRAINING_PLAN_FLOW,
    },

    // Auth Endpoints
    auth: {
        login: `${AUTH}/login`,
        register: `${AUTH}/register`,
        logout: `${AUTH}/logout`,
        refreshToken: `${AUTH}/refresh`,
        verifyOtp: `${AUTH}/verify-otp`,
        verifyOtpResetPassword: `${AUTH}/verify-otp-to-reset-password`,
        verifyOtpRecovery: `${AUTH}/verify-opt-to-recovery`,
        resetPassword: `${AUTH}/reset-password`,
        forgotPassword: `${AUTH}/forgot-password`,
        accountRecovery: `${AUTH}/account-recovery`,
        recoverAccount: `${AUTH}/recover-account`,
        loginWithGoogle: `${AUTH}/google`,
    },

    // Training Schedule Endpoints
    trainingSchedule: {
        getTrainingSchedule: TRAINING_SCHEDULE,
    },

    // Training Resource Endpoints
    trainingResource: {
        getAllTypes: `${TRAINING_RESOURCE}/types`,
        getAllTargetMuscles: `${TRAINING_RESOURCE}/target-muscles`,
        getAllPlans: `${TRAINING_RESOURCE}/plans`,
        getAllLocations: `${TRAINING_RESOURCE}/locations`,
        getAllLevels: `${TRAINING_RESOURCE}/levels`,
        getAllGoals: `${TRAINING_RESOURCE}/goals`,
        getAllEquipments: `${TRAINING_RESOURCE}/equipments`,
        getTypeById: (id: number) => `${TRAINING_RESOURCE}/types/${id}`,
        getTargetMuscleById: (id: number) => `${TRAINING_RESOURCE}/target-muscles/${id}`,
        getTrainingPlanById: (id: number) => `${TRAINING_RESOURCE}/plans/${id}`,
        getLocationById: (id: number) => `${TRAINING_RESOURCE}/locations/${id}`,
        getLevelById: (id: number) => `${TRAINING_RESOURCE}/levels/${id}`,
        getGoalById: (id: number) => `${TRAINING_RESOURCE}/goals/${id}`,
        getEquipmentById: (id: number) => `${TRAINING_RESOURCE}/equipments/${id}`,
    },

    // Policy Endpoints
    policy: {
        getTerms: `${POLICY}/terms`,
        getPrivacy: `${POLICY}/privacy`,
    },
} as const;
