package com.example.corevo.service.impl;

import com.example.corevo.constant.*;
import com.example.corevo.domain.dto.pagination.*;
import com.example.corevo.domain.dto.request.admin.*;
import com.example.corevo.domain.dto.request.user.enter_personal_infomation.PersonalInformationRequestDto;
import com.example.corevo.domain.dto.request.user.enter_personal_infomation.UpdatePersonalInformationRequestDto;
import com.example.corevo.domain.dto.request.user.health.UpdateHealthRequestDto;
import com.example.corevo.domain.dto.request.user.health.UserHealthRequestDto;
import com.example.corevo.domain.dto.request.user.profile.ConfirmPasswordRequestDto;
import com.example.corevo.domain.dto.response.CommonResponseDto;
import com.example.corevo.domain.dto.response.training_plan.TrainingPlanResponseDto;
import com.example.corevo.domain.dto.response.user.*;
import com.example.corevo.domain.dto.response.user.health.UserHealthResponseDto;
import com.example.corevo.domain.entity.user.*;
import com.example.corevo.domain.mapper.TrainingPlanMapper;
import com.example.corevo.domain.mapper.UserMapper;
import com.example.corevo.domain.mapper.UserHealthMapper;
import com.example.corevo.exception.*;
import com.example.corevo.helper.PersonalInformationHelper;
import com.example.corevo.repository.*;
import com.example.corevo.service.UserService;
import com.example.corevo.service.HealthCalculationService;
import jakarta.transaction.Transactional;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class UserServiceImpl implements UserService {

    UserRepository userRepository;

    AddressRepository addressRepository;

    UserHealthRepository userHealthRepository;

    UserMapper userMapper;

    UserHealthMapper userHealthMapper;

    TrainingPlanMapper trainingPlanMapper;

    PasswordEncoder passwordEncoder;

    HealthCalculationService healthCalculationService;

    PersonalInformationHelper stringPersonalInformationHelper;

    @Override
    public UserResponseDto personalInformation(
            Authentication authentication,
            PersonalInformationRequestDto request
    ) {

        if (!userRepository.existsUserByUsername(authentication.getName()))
            throw new VsException(HttpStatus.NOT_FOUND, ErrorMessage.User.ERR_USER_NOT_EXISTED);

        if (userRepository.existsUsersByPhone(request.getPhone()))
            throw new VsException(HttpStatus.CONFLICT, ErrorMessage.User.ERR_PHONE_EXISTED);

        User user = userRepository.findByUsername(authentication.getName());

        String oldAddressId = null;
        if (user.getAddress() != null) {
            oldAddressId = user.getAddress().getId();
        }

        Address address = addressRepository
                .findByProvinceAndDistrict(request.getAddress().getProvince(), request.getAddress().getDistrict())
                .orElseGet(() -> {
                    Address newAddress = new Address();
                    newAddress.setProvince(request.getAddress().getProvince());
                    newAddress.setDistrict(request.getAddress().getDistrict());
                    return addressRepository.save(newAddress);
                });

        user.setPhone(request.getPhone());
        user.setBirth(request.getBirth());
        user.setNationality(request.getNationality());
        user.setAddress(address);

        userRepository.save(user);

        if (oldAddressId != null && !oldAddressId.equals(address.getId())) {
            long userCountWithOldAddress = userRepository.countByAddressId(oldAddressId);
            if (userCountWithOldAddress == 0) {
                addressRepository.deleteById(oldAddressId);
            }
        }

        return userMapper.userToUserResponseDto(user);
    }

    @Override
    public UserResponseDto uploadAvatar(
            Authentication authentication,
            String url
    ) {

        if (!userRepository.existsUserByUsername(authentication.getName()))
            throw new VsException(HttpStatus.NOT_FOUND, ErrorMessage.User.ERR_USER_NOT_EXISTED);

        User user = userRepository.findByUsername(authentication.getName());

        user.setLinkAvatar(url);

        userRepository.save(user);

        return userMapper.userToUserResponseDto(user);
    }

    @Override
    public PaginationResponseDto<UserResponseDto> getAllUsers(PaginationRequestDto request) {

        Pageable pageable = PageRequest.of(request.getPageNum(), request.getPageSize());

        Page<User> userPage = userRepository.findAll(pageable);

        List<UserResponseDto> userResponseDtos = userPage.getContent()
                .stream()
                .map(userMapper::userToUserResponseDto)
                .collect(Collectors.toList());

        PagingMeta pagingMeta = new PagingMeta(
                userPage.getTotalElements(),
                userPage.getTotalPages(),
                request.getPageNum() + 1,
                request.getPageSize(),
                null,
                null);

        return new PaginationResponseDto<>(pagingMeta, userResponseDtos);
    }

    @Override
    public UserResponseDto getUserById(String userId) {

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_USER_NOT_EXISTED));

        return userMapper.userToUserResponseDto(user);
    }

    @Override
    public UserResponseDto createUser(CreateUserRequestDto request) {

        if (userRepository.existsUserByEmail(request.getEmail())) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_EMAIL_EXISTED);
        }
        if (userRepository.existsUserByUsername(request.getUsername())) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_USERNAME_EXISTED);
        }
        if (userRepository.existsUsersByPhone(request.getPhone())) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_PHONE_EXISTED);
        }

        User user = userMapper.createUserRequestDtoToUser(request);

        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setCreatedAt(LocalDate.now());
        user.setIsLocked(CommonConstant.FALSE);

        return userMapper.userToUserResponseDto(userRepository.save(user));
    }

    @Override
    public UserResponseDto updateUser(String userId, UpdateUserRequestDto request) {

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_USER_NOT_EXISTED));

        if (request.getEmail() != null && !request.getEmail().equals(user.getEmail())) {
            if (userRepository.existsUserByEmail(request.getEmail())) {
                throw new VsException(HttpStatus.CONFLICT, ErrorMessage.User.ERR_EMAIL_EXISTED);
            }
        }

        if (request.getPhone() != null && !request.getPhone().equals(user.getPhone())) {
            if (userRepository.existsUsersByPhone(request.getPhone())) {
                throw new VsException(HttpStatus.CONFLICT, ErrorMessage.User.ERR_PHONE_EXISTED);
            }
        }

        userMapper.updateUserFromDto(request, user);

        User updatedUser = userRepository.save(user);

        return userMapper.userToUserResponseDto(updatedUser);
    }

    @Override
    public CommonResponseDto lockUser(String userId) {

        Optional<User> user = userRepository.findById(userId);

        checkLockUser(user);

        user.get().setIsLocked(CommonConstant.TRUE);

        userRepository.save(user.get());

        return new CommonResponseDto(HttpStatus.OK, SuccessMessage.User.LOCKED_SUCCESS);
    }

    @Override
    public CommonResponseDto unlockUser(String userId) {

        Optional<User> user = userRepository.findById(userId);

        checkUnlockUser(user);

        user.get().setIsLocked(CommonConstant.FALSE);

        userRepository.save(user.get());

        return new CommonResponseDto(HttpStatus.OK, SuccessMessage.User.UNLOCKED_SUCCESS);
    }

    @Override
    @Transactional
    public CommonResponseDto deleteUserAccount(String userId) {

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_USER_NOT_EXISTED));

        String addressId = null;

        if (user.getAddress() != null) {
            addressId = user.getAddress().getId();
        }

        userRepository.delete(user);

        if (addressId != null) {
            long userCountWithAddress = userRepository.countByAddressId(addressId);

            if (userCountWithAddress == 0) {
                addressRepository.deleteById(addressId);
            }
        }

        return new CommonResponseDto(HttpStatus.OK, SuccessMessage.User.DELETE_SUCCESS);
    }

    @Override
    @Transactional
    public AccountDeletionResponseDto deleteMyAccount(Authentication authentication) {

        String username = authentication.getName();

        User user = userRepository.findByUsername(username);

        if (user == null) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_USER_NOT_EXISTED);
        }

        if (Boolean.TRUE.equals(user.getIsDeleted())) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_ACCOUNT_ALREADY_DELETED);
        }

        Integer gracePeriodDays = CommonConstant.ACCOUNT_RECOVERY_DAYS;

        user.setIsDeleted(CommonConstant.TRUE);
        user.setDeletedAt(LocalDate.now());

        userRepository.save(user);

        return new AccountDeletionResponseDto(
                HttpStatus.OK,
                SuccessMessage.User.SOFT_DELETE_SUCCESS,
                user.getEmail(),
                gracePeriodDays,
                "corevo@gmail.com"
        );
    }

    @Override
    public UserResponseDto getMyProfile(Authentication authentication) {
        String username = authentication.getName();

        User user = userRepository.findByUsername(username);
        if (user == null) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_USER_NOT_EXISTED);
        }

        UserResponseDto userResponseDto = userMapper.userToUserResponseDto(user);

        if (user.getUserHealth() != null) {
            UserHealthResponseDto response = userHealthMapper.userHealthToUserHealthResponseDto(user.getUserHealth());
            userResponseDto.setUserHealth(response);
        }

        if (!user.getTrainingPlans().isEmpty()) {
            List<TrainingPlanResponseDto> listResponseDto = trainingPlanMapper.
                    listTrainingPlanToListTrainingPlanResponseDto(user.getTrainingPlans());
            userResponseDto.setTrainingPlans(listResponseDto);
        }

        return userResponseDto;
    }

    @Override
    @Transactional
    public UserResponseDto updateProfile(ConfirmPasswordRequestDto request, Authentication authentication) {
        String username = authentication.getName();

        User user = userRepository.findByUsername(username);
        if (user == null) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_USER_NOT_EXISTED);
        }

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_INCORRECT_PASSWORD_CONFIRMATION);
        }

        if (user.getPhone() == null || user.getBirth() == null ||
                user.getNationality() == null || user.getAddress() == null) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_PERSONAL_INFORMATION_NOT_COMPLETED);
        }

        if (request.getProfileData().getPersonalInformation() != null) {

            UpdatePersonalInformationRequestDto personalInfo = stringPersonalInformationHelper.handleEmptyStrings(
                    request.getProfileData().getPersonalInformation());

            if (personalInfo.getPhone() != null && !personalInfo.getPhone().equals(user.getPhone())) {
                if (userRepository.existsUsersByPhone(personalInfo.getPhone())) {
                    throw new VsException(HttpStatus.CONFLICT, ErrorMessage.User.ERR_PHONE_EXISTED);
                }
            }

            userMapper.updateUserFromPersonalInformationDto(personalInfo, user);

            if (personalInfo.getAddress() != null) {
                String oldAddressId = null;
                if (user.getAddress() != null) {
                    oldAddressId = user.getAddress().getId();
                }

                Address address = addressRepository
                        .findByProvinceAndDistrict(
                                personalInfo.getAddress().getProvince(),
                                personalInfo.getAddress().getDistrict())
                        .orElseGet(() -> {
                            Address newAddress = new Address();
                            newAddress.setProvince(personalInfo.getAddress().getProvince());
                            newAddress.setDistrict(personalInfo.getAddress().getDistrict());
                            return addressRepository.save(newAddress);
                        });

                user.setAddress(address);

                if (oldAddressId != null && !oldAddressId.equals(address.getId())) {
                    long userCountWithOldAddress = userRepository.countByAddressId(oldAddressId);
                    if (userCountWithOldAddress == 0) {
                        addressRepository.deleteById(oldAddressId);
                    }
                }
            }
        }

        if (request.getProfileData().getHealth() != null) {
            UserHealth userHealth = user.getUserHealth();

            UpdateHealthRequestDto healthDto = request.getProfileData().getHealth();

            if (userHealth == null) {
                throw new VsException(HttpStatus.NOT_FOUND, ErrorMessage.UserHealth.ERR_USER_HEALTH_NOT_FOUND);
            }

            userHealthMapper.updateUserHealthFromDto(healthDto, userHealth);

            calculateHealthData(userHealth);

            userHealthRepository.save(userHealth);
        }

        User updatedUser = userRepository.save(user);

        UserResponseDto userResponseDto = userMapper.userToUserResponseDto(updatedUser);

        if (updatedUser.getUserHealth() != null) {
            UserHealthResponseDto response = userHealthMapper.userHealthToUserHealthResponseDto(user.getUserHealth());
            userResponseDto.setUserHealth(response);
        }

        return userResponseDto;
    }


    private void calculateHealthData(UserHealth userHealth) {

        UserHealthRequestDto healthRequest = new UserHealthRequestDto();
        healthRequest.setGender(userHealth.getGender());
        healthRequest.setHeight(userHealth.getHeight());
        healthRequest.setWeight(userHealth.getWeight());
        healthRequest.setAge(userHealth.getAge());
        healthRequest.setActivityLevel(userHealth.getActivityLevel());

        double bmr = healthCalculationService.calculateBMR(healthRequest);
        int mhr = healthCalculationService.calculateMaximumHeartRate(healthRequest);
        double tdee = healthCalculationService.calculateTDEE(healthRequest);

        userHealth.setBasalMetabolicRate(bmr);
        userHealth.setMaximumHeartRate(mhr);
        userHealth.setTDEE(tdee);
    }

    private void checkLockUser(Optional<User> user) {
        if (user.isEmpty()) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_USER_NOT_EXISTED);
        } else {
            if (user.get().getIsLocked()) {
                throw new InvalidException((ErrorMessage.User.ERR_USER_IS_LOCKED));
            }
        }
    }

    private void checkUnlockUser(Optional<User> user) {
        if (user.isEmpty()) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_USER_NOT_EXISTED);
        } else {
            if (!user.get().getIsLocked()) {
                throw new InvalidException((ErrorMessage.User.ERR_USER_IS_NOT_LOCKED));
            }
        }
    }

    @Override
    public long countAllUser(){
        long count = userRepository.count();
        return count;
    }

}
