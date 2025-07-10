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
import jakarta.transaction.Transactional;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Transactional
public class UserHealthServiceImpl implements UserHealthService {

    UserRepository userRepository;

    UserMapper userMapper;

    HealthCalculationService healthCalculationService;

    @Override
    public UserResponseDto healthInformation(
            Authentication authentication,
            UserHealthRequestDto request
    ) {

        if (!userRepository.existsUserByUsername(authentication.getName())) {
            throw new VsException(HttpStatus.NOT_FOUND, ErrorMessage.User.ERR_USER_NOT_EXISTED);
        }

        User user = userRepository.findByUsername(authentication.getName());

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
