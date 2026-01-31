/**
 * Training Image Helper
 * Utility functions to map training plan images based on goal and plan name
 * Migrated from Flutter TrainingDayImageData class
 */

const REST_DAY_ICON = require('@/assets/icons/training/rest_day_icon.png');

/**
 * Get list of training day images for a given plan
 */
export function getTrainingDayImages(planName: string, goal: string): any[] {
    switch (goal) {
        case 'Lose fat':
            switch (planName) {
                case 'Fat Burn Express':
                    return getLoseFatPlan1Images();
                case 'Shred and Burn':
                    return getLoseFatPlan2Images();
                case 'Bodyweigt Burn':
                    return getLoseFatPlan3Images();
            }
            break;
        case 'Gain weight':
            switch (planName) {
                case 'Muscle Mass Builder':
                    return getGainWeightPlan1Images();
                case 'Bodyweight Hypertrophy':
                    return getGainWeightPlan2Images();
            }
            break;
        case 'Gain muscle':
            switch (planName) {
                case 'Muscle Mass Builder':
                    return getGainMusclePlan1Images();
                case 'Body Control Muscle':
                    return getGainMusclePlan2Images();
                case 'Lean Muscle Assist':
                    return getGainMusclePlan3Images();
            }
            break;
        case 'Maintain Body':
            switch (planName) {
                case 'Lean and Fit':
                case 'Balanced Body':
                    return getMaintainBodyPlan1Images();
                case 'Steady Fit':
                    return getMaintainBodyPlan3Images();
            }
            break;
        case 'Increase endurance':
            switch (planName) {
                case 'Endurance Engine':
                    return getIncreaseEndurancePlan1Images();
                case 'Bodyweight Stamina':
                    return getIncreaseEndurancePlan2Images();
                case 'Strength-Endurance Hybrid':
                    return getIncreaseEndurancePlan3Images();
            }
            break;
        case 'Improve cardiovascular':
            switch (planName) {
                case 'Healthy Heart Routine':
                    return getImproveCardiovascularPlan1Images();
                case 'Cardio + Strength Circuit':
                    return getImproveCardiovascularPlan2Images();
                case 'Hearful Flow':
                    return getImproveCardiovascularPlan3Images();
            }
            break;
        case 'Stress relief/relaxation':
            switch (planName) {
                case 'Calm and Clarity':
                    return getStressReliefPlan1Images();
                case 'Mindful Movement':
                    return getStressReliefPlan2Images();
                case 'Reset and Recharge':
                    return getStressReliefPlan3Images();
            }
            break;
        case 'Increase height':
            switch (planName) {
                case 'Height Stretch Flow':
                    return getIncreaseHeightPlan1Images();
                case 'Jump and Stretch Combo':
                    return getIncreaseHeightPlan2Images();
                case 'Posture and Core Strength':
                    return getIncreaseHeightPlan3Images();
            }
            break;
    }
    return [];
}

/**
 * Get list of training day shape images for a given plan
 */
export function getTrainingDayShapeImages(planName: string, goal: string): any[] {
    switch (goal) {
        case 'Lose fat':
            switch (planName) {
                case 'Fat Burn Express':
                    return getLoseFatPlan1ShapeImages();
                case 'Shred and Burn':
                    return getLoseFatPlan2ShapeImages();
                case 'Bodyweigt Burn':
                    return getLoseFatPlan3ShapeImages();
            }
            break;
        case 'Gain weight':
            switch (planName) {
                case 'Muscle Mass Builder':
                    return getGainWeightPlan1ShapeImages();
                case 'Bodyweight Hypertrophy':
                    return getGainWeightPlan2ShapeImages();
            }
            break;
        case 'Gain muscle':
            switch (planName) {
                case 'Muscle Mass Builder':
                    return getGainMusclePlan1ShapeImages();
                case 'Body Control Muscle':
                    return getGainMusclePlan2ShapeImages();
                case 'Lean Muscle Assist':
                    return getGainMusclePlan3ShapeImages();
            }
            break;
        case 'Maintain Body':
            switch (planName) {
                case 'Lean and Fit':
                case 'Balanced Body':
                    return getMaintainBodyPlan1ShapeImages();
                case 'Steady Fit':
                    return getMaintainBodyPlan3ShapeImages();
            }
            break;
        case 'Increase endurance':
            switch (planName) {
                case 'Endurance Engine':
                    return getIncreaseEndurancePlan1ShapeImages();
                case 'Bodyweight Stamina':
                    return getIncreaseEndurancePlan2ShapeImages();
                case 'Strength-Endurance Hybrid':
                    return getIncreaseEndurancePlan3ShapeImages();
            }
            break;
        case 'Improve cardiovascular':
            switch (planName) {
                case 'Healthy Heart Routine':
                    return getImproveCardiovascularPlan1ShapeImages();
                case 'Cardio + Strength Circuit':
                    return getImproveCardiovascularPlan2ShapeImages();
                case 'Hearful Flow':
                    return getImproveCardiovascularPlan3ShapeImages();
            }
            break;
        case 'Stress relief/relaxation':
            switch (planName) {
                case 'Calm and Clarity':
                    return getStressReliefPlan1ShapeImages();
                case 'Mindful Movement':
                    return getStressReliefPlan2ShapeImages();
                case 'Reset and Recharge':
                    return getStressReliefPlan3ShapeImages();
            }
            break;
        case 'Increase height':
            switch (planName) {
                case 'Height Stretch Flow':
                    return getIncreaseHeightPlan1ShapeImages();
                case 'Jump and Stretch Combo':
                    return getIncreaseHeightPlan2ShapeImages();
                case 'Posture and Core Strength':
                    return getIncreaseHeightPlan3ShapeImages();
            }
            break;
    }
    return [];
}

// Gain Muscle - Training Day Images
function getGainMusclePlan1Images() {
    return [
        require('@/assets/images/training/training_day/gain_muscle/gain_muscle_plan_3_1.png'),
        require('@/assets/images/training/training_day/gain_muscle/gain_muscle_plan_3_2.png'),
        require('@/assets/images/training/training_day/gain_muscle/gain_muscle_plan_3_3.png'),
        REST_DAY_ICON,
        require('@/assets/images/training/training_day/gain_muscle/gain_muscle_plan_3_4.png'),
        require('@/assets/images/training/training_day/gain_muscle/gain_muscle_plan_3_5.png'),
        REST_DAY_ICON,
    ];
}

function getGainMusclePlan2Images() {
    return [
        require('@/assets/images/training/training_day/gain_muscle/gain_muscle_plan_1_1.png'),
        require('@/assets/images/training/training_day/gain_muscle/gain_muscle_plan_1_2.png'),
        require('@/assets/images/training/training_day/gain_muscle/gain_muscle_plan_1_3.png'),
        require('@/assets/images/training/training_day/gain_muscle/gain_muscle_plan_1_4.png'),
        require('@/assets/images/training/training_day/gain_muscle/gain_muscle_plan_1_5.png'),
        require('@/assets/images/training/training_day/gain_muscle/gain_muscle_plan_1_6.png'),
        REST_DAY_ICON,
    ];
}

function getGainMusclePlan3Images() {
    return [
        require('@/assets/images/training/training_day/gain_muscle/gain_muscle_plan_2_1.png'),
        require('@/assets/images/training/training_day/gain_muscle/gain_muscle_plan_2_2.png'),
        REST_DAY_ICON,
        require('@/assets/images/training/training_day/gain_muscle/gain_muscle_plan_2_3.png'),
        REST_DAY_ICON,
        require('@/assets/images/training/training_day/gain_muscle/gain_muscle_plan_2_4.png'),
        REST_DAY_ICON,
    ];
}

// Gain Muscle - Shape Images
function getGainMusclePlan1ShapeImages() {
    return [
        require('@/assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_3_1.png'),
        require('@/assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_3_2.png'),
        require('@/assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_3_3.png'),
        REST_DAY_ICON,
        require('@/assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_3_4.png'),
        require('@/assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_3_5.png'),
        REST_DAY_ICON,
    ];
}

function getGainMusclePlan2ShapeImages() {
    return [
        require('@/assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_1_1.png'),
        require('@/assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_1_2.png'),
        require('@/assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_1_3.png'),
        require('@/assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_1_4.png'),
        require('@/assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_1_5.png'),
        require('@/assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_1_5.png'),
    ];
}

function getGainMusclePlan3ShapeImages() {
    return [
        require('@/assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_2_1.png'),
        require('@/assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_2_2.png'),
        REST_DAY_ICON,
        require('@/assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_2_3.png'),
        REST_DAY_ICON,
        require('@/assets/images/training/training_day_shape/gain_muscle/gain_muscle_plan_2_4.png'),
        REST_DAY_ICON,
    ];
}

// Placeholder functions for other goals (Lose fat, Gain weight, etc.)
// These would follow the same pattern as above
function getLoseFatPlan1Images() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getLoseFatPlan2Images() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getLoseFatPlan3Images() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getGainWeightPlan1Images() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getGainWeightPlan2Images() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getMaintainBodyPlan1Images() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getMaintainBodyPlan3Images() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getIncreaseEndurancePlan1Images() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getIncreaseEndurancePlan2Images() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getIncreaseEndurancePlan3Images() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getImproveCardiovascularPlan1Images() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getImproveCardiovascularPlan2Images() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getImproveCardiovascularPlan3Images() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getStressReliefPlan1Images() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getStressReliefPlan2Images() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getStressReliefPlan3Images() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getIncreaseHeightPlan1Images() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getIncreaseHeightPlan2Images() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getIncreaseHeightPlan3Images() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }

function getLoseFatPlan1ShapeImages() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getLoseFatPlan2ShapeImages() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getLoseFatPlan3ShapeImages() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getGainWeightPlan1ShapeImages() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getGainWeightPlan2ShapeImages() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getMaintainBodyPlan1ShapeImages() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getMaintainBodyPlan3ShapeImages() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getIncreaseEndurancePlan1ShapeImages() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getIncreaseEndurancePlan2ShapeImages() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getIncreaseEndurancePlan3ShapeImages() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getImproveCardiovascularPlan1ShapeImages() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getImproveCardiovascularPlan2ShapeImages() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getImproveCardiovascularPlan3ShapeImages() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getStressReliefPlan1ShapeImages() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getStressReliefPlan2ShapeImages() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getStressReliefPlan3ShapeImages() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getIncreaseHeightPlan1ShapeImages() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getIncreaseHeightPlan2ShapeImages() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
function getIncreaseHeightPlan3ShapeImages() { return [REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON, REST_DAY_ICON]; }
