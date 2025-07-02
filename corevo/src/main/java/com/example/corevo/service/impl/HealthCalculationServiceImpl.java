package com.example.corevo.service.impl;

import org.springframework.stereotype.Service;
import com.example.corevo.domain.dto.request.user.health.UserHealthRequestDto;
import com.example.corevo.domain.entity.user.Gender;
import com.example.corevo.service.HealthCalculationService;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.experimental.FieldDefaults;

@Service
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class HealthCalculationServiceImpl implements HealthCalculationService {

    /**
     * Tính BMR (Basal Metabolic Rate) theo công thức Mifflin-St Jeor
     * Nguồn công thức: https://www.sciencedirect.com/science/article/abs/pii/S0002916523166986?via%3Dihub
     * Nam: BMR = (10 × weight) + (6.25 × height) - (5 × age) + 5
     * Nữ: BMR = (10 × weight) + (6.25 × height) - (5 × age) - 161
     */
    @Override
    public double calculateBMR(UserHealthRequestDto request) {

        if (request.getGender() == Gender.MALE) {
            return (10 * request.getWeight()) +
                    (6.25 * request.getHeight()) - (5 * request.getAge()) + 5;
        } else {
            return (10 * request.getWeight()) +
                    (6.25 * request.getHeight()) - (5 * request.getAge()) - 161;
        }
    }

    /**
     * Tính Maximum Heart Rate theo công thức
     * MHR = 220 - age
     */
    @Override
    public int calculateMaximumHeartRate(UserHealthRequestDto request) {

        return 220 - request.getAge();
    }

    /**
     * Tính TDEE (Total Daily Energy Expenditure)
     * TDEE = BMR × Activity Level Multiplier
     */
    @Override
    public double calculateTDEE(UserHealthRequestDto request) {

        double bmr = calculateBMR(request);
        return bmr * request.getActivityLevel().getMultiplier();
    }

}
