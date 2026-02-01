/**
 * Nutrition Types
 * TypeScript interfaces for nutrition and meal tracking
 */

export interface MealPlan {
    id: string;
    userId: string;
    name: string;
    goal: NutritionGoal;
    dailyCalories: number;
    macros: MacroNutrients;
    startDate: string;
    endDate?: string;
    isActive: boolean;
    meals: Meal[];
    createdAt: string;
    updatedAt: string;
}

export interface Meal {
    id: string;
    planId: string;
    name: string;
    type: MealType;
    time: string;
    foods: FoodItem[];
    totalCalories: number;
    totalMacros: MacroNutrients;
}

export interface FoodItem {
    id: string;
    mealId: string;
    food: Food;
    quantity: number;
    unit: MeasurementUnit;
    calories: number;
    macros: MacroNutrients;
}

export interface Food {
    id: string;
    name: string;
    nameVi: string;
    category: FoodCategory;
    servingSize: number;
    servingUnit: MeasurementUnit;
    calories: number;
    protein: number;
    carbs: number;
    fat: number;
    fiber?: number;
    sugar?: number;
    sodium?: number;
    imageUrl?: string;
}

export interface MacroNutrients {
    protein: number;
    carbs: number;
    fat: number;
    calories: number;
}

export interface NutritionLog {
    id: string;
    userId: string;
    date: string;
    meals: Meal[];
    waterIntake: number;
    totalCalories: number;
    totalMacros: MacroNutrients;
    notes?: string;
}

export interface WaterLog {
    id: string;
    userId: string;
    date: string;
    amount: number;
    unit: 'ML' | 'L';
    loggedAt: string;
}

// Enums
export type NutritionGoal =
    | 'WEIGHT_LOSS'
    | 'MUSCLE_GAIN'
    | 'MAINTENANCE'
    | 'CUTTING'
    | 'BULKING';

export type MealType =
    | 'BREAKFAST'
    | 'LUNCH'
    | 'DINNER'
    | 'SNACK'
    | 'PRE_WORKOUT'
    | 'POST_WORKOUT';

export type FoodCategory =
    | 'PROTEIN'
    | 'CARBS'
    | 'VEGETABLES'
    | 'FRUITS'
    | 'DAIRY'
    | 'FATS'
    | 'BEVERAGES'
    | 'SNACKS'
    | 'SUPPLEMENTS';

export type MeasurementUnit =
    | 'GRAM'
    | 'KILOGRAM'
    | 'ML'
    | 'L'
    | 'PIECE'
    | 'CUP'
    | 'TABLESPOON'
    | 'TEASPOON'
    | 'OUNCE';

// API Request/Response Types
export interface CreateMealPlanRequest {
    goal: NutritionGoal;
    dailyCalories: number;
    proteinPercent: number;
    carbsPercent: number;
    fatPercent: number;
}

export interface LogMealRequest {
    date: string;
    mealType: MealType;
    foods: {
        foodId: string;
        quantity: number;
        unit: MeasurementUnit;
    }[];
}

export interface NutritionStatsResponse {
    totalDays: number;
    averageCalories: number;
    averageMacros: MacroNutrients;
    streak: number;
    calorieGoalMet: number;
    waterGoalMet: number;
}
