package com.example.corevo.service.impl;

import com.example.corevo.constant.ErrorMessage;
import com.example.corevo.domain.dto.request.user.health.UserHealthRequestDto;
import com.example.corevo.domain.dto.response.user.UserResponseDto;
import com.example.corevo.domain.entity.user.User;
import com.example.corevo.domain.entity.user.UserHealth;
import com.example.corevo.domain.mapper.UserMapper;
import com.example.corevo.exception.VsException;
import com.example.corevo.repository.UserRepository;
import com.example.corevo.service.HealthCalculationService;
import com.example.corevo.service.UserHealthService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class UserHealthServiceImpl implements UserHealthService {

    UserRepository userRepository;

    UserMapper userMapper;

    HealthCalculationService healthCalculationService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public UserResponseDto healthInformation(
            Authentication authentication,
            UserHealthRequestDto request) {

        User user = userRepository.findByUsername(authentication.getName())
                .orElseThrow(() -> new VsException(
                        HttpStatus.UNAUTHORIZED,
                        ErrorMessage.User.ERR_USER_NOT_EXISTED));

        UserHealth userHealth = user.getUserHealth();
        if (userHealth == null) {
            userHealth = new UserHealth();
            userHealth.setUser(user);
            user.setUserHealth(userHealth);
        }

        userHealth.setGender(request.getGender());
        userHealth.setHeight(request.getHeight());
        userHealth.setWeight(request.getWeight());
        userHealth.setAge(request.getAge());
        userHealth.setActivityLevel(request.getActivityLevel());

        userHealth.setBasalMetabolicRate(healthCalculationService.calculateBMR(request));
        userHealth.setTDEE(healthCalculationService.calculateTDEE(request));
        userHealth.setMaximumHeartRate(healthCalculationService.calculateMaximumHeartRate(request));
        userRepository.save(user);

        return userMapper.userToUserResponseDto(user);
    }

}
