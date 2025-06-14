package com.example.corevo.service.impl;

import com.example.corevo.constant.ErrorMessage;
import com.example.corevo.domain.dto.request.user.health.UserHealthRequestDto;
import com.example.corevo.domain.dto.response.user.UserResponseDto;
import com.example.corevo.domain.entity.User;
import com.example.corevo.domain.entity.UserHealth;
import com.example.corevo.exception.VsException;
import com.example.corevo.repository.UserHealthRepository;
import com.example.corevo.repository.UserRepository;
import com.example.corevo.service.HealthCalculationService;
import com.example.corevo.service.UserHealthService;
import jakarta.transaction.Transactional;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Transactional
public class UserHealthServiceImpl implements UserHealthService {

    UserRepository userRepository;
    ModelMapper modelMapper;
    HealthCalculationService healthCalculationService;
    UserHealthRepository userHealthRepository;

    @Override
    public UserResponseDto healthInformation(UserHealthRequestDto request) {
        if (!userRepository.existsUserByUsername(request.getUsername()))
            throw new VsException(ErrorMessage.User.ERR_USER_NOT_EXISTED);

        if (userRepository.existsUsersByPhone(request.getPhone()))
            throw new VsException(HttpStatus.CONFLICT, ErrorMessage.User.ERR_PHONE_EXISTED);

        User user = userRepository.findByUsername(request.getUsername());

        UserHealth userHealth = userHealthRepository
                .findByUserUsername(request.getUsername())
                .orElseGet(() -> {
                    UserHealth newHealth = new UserHealth();
                    newHealth.setId(user.getId());  // vì dùng @MapsId
                    newHealth.setUser(user);
                    return newHealth;
                });

        userHealth.setGender(request.getGender());
        userHealth.setHeight(request.getHeight());
        userHealth.setWeight(request.getWeight());
        userHealth.setAge(request.getAge());
        userHealth.setActivityLevel(request.getActivityLevel());

        userHealth.setBasalMetabolicRate(healthCalculationService.calculateBMR(request));
        userHealth.setTDEE(healthCalculationService.calculateTDEE(request));
        userHealth.setMaximumHeartRate(healthCalculationService.calculateMaximumHeartRate(request));

        userHealthRepository.save(userHealth);

        return modelMapper.map(user, UserResponseDto.class);
    }
}
