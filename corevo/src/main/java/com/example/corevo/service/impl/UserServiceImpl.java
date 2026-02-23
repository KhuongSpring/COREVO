package com.example.corevo.service.impl;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import com.example.corevo.constant.*;
import com.example.corevo.domain.dto.pagination.*;
import com.example.corevo.domain.dto.request.admin.*;
import com.example.corevo.domain.dto.request.user.enter_personal_infomation.PersonalInformationRequestDto;
import com.example.corevo.domain.dto.request.user.enter_personal_infomation.UpdatePersonalInformationRequestDto;
import com.example.corevo.domain.dto.request.user.health.UpdateHealthRequestDto;
import com.example.corevo.domain.dto.request.user.health.UserHealthRequestDto;
import com.example.corevo.domain.dto.request.user.profile.UpdateProfileRequestDto;
import com.example.corevo.domain.dto.response.CommonResponseDto;
import com.example.corevo.domain.dto.response.admin.DayCountResponseDto;
import com.example.corevo.domain.dto.response.admin.MonthCountResponseDto;
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
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;

import java.io.IOException;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.TextStyle;
import java.util.*;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
@RequiredArgsConstructor
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

    Cloudinary cloudinary;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public UserResponseDto personalInformation(UUID userId, PersonalInformationRequestDto request) {

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new VsException(
                        HttpStatus.UNAUTHORIZED,
                        ErrorMessage.User.ERR_USER_NOT_EXISTED));

        if (userRepository.existsUserByPhone(request.getPhone()))
            throw new VsException(HttpStatus.CONFLICT, ErrorMessage.User.ERR_PHONE_EXISTED);

        UUID oldAddressId = null;
        if (user.getAddress() != null) {
            oldAddressId = user.getAddress().getId();
        }

        Address address = findOrCreateAddress(
                request.getAddress().getProvince(),
                request.getAddress().getDistrict());

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

    private Address findOrCreateAddress(String province, String district) {
        return addressRepository
                .findByProvinceAndDistrict(province, district)
                .orElseGet(() -> {
                    Address newAddress = new Address();
                    newAddress.setProvince(province);
                    newAddress.setDistrict(district);
                    return addressRepository.save(newAddress);
                });
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public UserResponseDto uploadAvatar(UUID userId, MultipartFile file) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new VsException(
                        HttpStatus.UNAUTHORIZED,
                        ErrorMessage.User.ERR_USER_NOT_EXISTED));

        if (user.getAvatarPublicId() != null) {
            try {
                cloudinary.uploader().destroy(user.getAvatarPublicId(), ObjectUtils.emptyMap());
            } catch (IOException e) {
                throw new VsException(HttpStatus.INTERNAL_SERVER_ERROR, ErrorMessage.ERR_UPLOAD_IMAGE_FAIL);
            }
        }

        String imageUrl;
        String publicId;
        try {
            Map<?, ?> result = cloudinary.uploader().upload(file.getBytes(), ObjectUtils.emptyMap());
            imageUrl = (String) result.get("secure_url");
            publicId = (String) result.get("public_id");
        } catch (Exception e) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.ERR_UPLOAD_IMAGE_FAIL);
        }

        user.setLinkAvatar(imageUrl);
        user.setAvatarPublicId(publicId);

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
    public UserResponseDto getUserById(UUID userId) {

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_USER_NOT_EXISTED));

        return userMapper.userToUserResponseDto(user);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public UserResponseDto createUser(CreateUserRequestDto request) {

        if (userRepository.existsUserByEmail(request.getEmail())) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_EMAIL_EXISTED);
        }
        if (userRepository.existsUserByUsername(request.getUsername())) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_USERNAME_EXISTED);
        }
        if (userRepository.existsUserByPhone(request.getPhone())) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_PHONE_EXISTED);
        }

        User user = userMapper.createUserRequestDtoToUser(request);

        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setCreatedAt(com.example.corevo.utils.TimeUtil.today());
        user.setIsLocked(false);

        return userMapper.userToUserResponseDto(userRepository.save(user));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public UserResponseDto updateUser(UUID userId, UpdateUserRequestDto request) {

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_USER_NOT_EXISTED));

        if (request.getEmail() != null && !request.getEmail().equals(user.getEmail())) {
            if (userRepository.existsUserByEmail(request.getEmail())) {
                throw new VsException(HttpStatus.CONFLICT, ErrorMessage.User.ERR_EMAIL_EXISTED);
            }
        }

        if (request.getPhone() != null && !request.getPhone().equals(user.getPhone())) {
            if (userRepository.existsUserByPhone(request.getPhone())) {
                throw new VsException(HttpStatus.CONFLICT, ErrorMessage.User.ERR_PHONE_EXISTED);
            }
        }

        userMapper.updateUserFromDto(request, user);

        User updatedUser = userRepository.save(user);

        return userMapper.userToUserResponseDto(updatedUser);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public CommonResponseDto lockUser(UUID userId) {

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_USER_NOT_EXISTED));

        if (user.getIsLocked()) {
            throw new InvalidException((ErrorMessage.User.ERR_USER_IS_LOCKED));
        }

        user.setIsLocked(true);

        userRepository.save(user);

        return new CommonResponseDto(HttpStatus.OK, SuccessMessage.User.LOCKED_SUCCESS);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public CommonResponseDto unlockUser(UUID userId) {

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_USER_NOT_EXISTED));

        if (!user.getIsLocked()) {
            throw new InvalidException((ErrorMessage.User.ERR_USER_IS_NOT_LOCKED));
        }

        user.setIsLocked(false);

        userRepository.save(user);

        return new CommonResponseDto(HttpStatus.OK, SuccessMessage.User.UNLOCKED_SUCCESS);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public CommonResponseDto deleteUserAccount(UUID userId) {

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_USER_NOT_EXISTED));

        UUID addressId = null;

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
    @Transactional(rollbackFor = Exception.class)
    public AccountDeletionResponseDto deleteMyAccount(UUID userId) {

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new VsException(
                        HttpStatus.UNAUTHORIZED,
                        ErrorMessage.User.ERR_USER_NOT_EXISTED));

        if (Boolean.TRUE.equals(user.getIsDeleted())) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_ACCOUNT_ALREADY_DELETED);
        }

        Integer gracePeriodDays = CommonConstant.ACCOUNT_RECOVERY_DAYS;

        user.setIsDeleted(true);
        user.setDeletedAt(com.example.corevo.utils.TimeUtil.today());

        userRepository.save(user);

        return new AccountDeletionResponseDto(
                HttpStatus.OK,
                SuccessMessage.User.SOFT_DELETE_SUCCESS,
                user.getEmail(),
                gracePeriodDays,
                CommonConstant.ADMIN_EMAIL);
    }

    @Override
    public UserResponseDto getMyProfile(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new VsException(
                        HttpStatus.UNAUTHORIZED,
                        ErrorMessage.User.ERR_USER_NOT_EXISTED));

        UserResponseDto userResponseDto = userMapper.userToUserResponseDto(user);

        if (user.getUserHealth() != null) {
            UserHealthResponseDto response = userHealthMapper.userHealthToUserHealthResponseDto(user.getUserHealth());
            userResponseDto.setUserHealth(response);
        }

        if (!user.getTrainingPlans().isEmpty()) {
            List<TrainingPlanResponseDto> listResponseDto = trainingPlanMapper
                    .listTrainingPlanToListTrainingPlanResponseDto(user.getTrainingPlans());
            userResponseDto.setTrainingPlans(listResponseDto);
        }

        return userResponseDto;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public UserResponseDto updateProfile(UpdateProfileRequestDto request, UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new VsException(
                        HttpStatus.UNAUTHORIZED,
                        ErrorMessage.User.ERR_USER_NOT_EXISTED));

        if (request.getPersonalInformation() != null) {

            UpdatePersonalInformationRequestDto personalInfo = stringPersonalInformationHelper.handleEmptyStrings(
                    request.getPersonalInformation());

            if (personalInfo.getPhone() != null && !personalInfo.getPhone().equals(user.getPhone())) {
                if (userRepository.existsUserByPhone(personalInfo.getPhone())) {
                    throw new VsException(HttpStatus.CONFLICT, ErrorMessage.User.ERR_PHONE_EXISTED);
                }
            }

            userMapper.updateUserFromPersonalInformationDto(personalInfo, user);

            if (personalInfo.getAddress() != null) {
                UUID oldAddressId = null;
                if (user.getAddress() != null) {
                    oldAddressId = user.getAddress().getId();
                }

                Address address = findOrCreateAddress(
                        personalInfo.getAddress().getProvince(),
                        personalInfo.getAddress().getDistrict());

                user.setAddress(address);

                if (oldAddressId != null && !oldAddressId.equals(address.getId())) {
                    long userCountWithOldAddress = userRepository.countByAddressId(oldAddressId);
                    if (userCountWithOldAddress == 0) {
                        addressRepository.deleteById(oldAddressId);
                    }
                }
            }
        }

        if (request.getHealth() != null) {
            UserHealth userHealth = user.getUserHealth();

            UpdateHealthRequestDto healthDto = request.getHealth();

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

        if (!updatedUser.getTrainingPlans().isEmpty()) {
            List<TrainingPlanResponseDto> listResponseDto = trainingPlanMapper
                    .listTrainingPlanToListTrainingPlanResponseDto(user.getTrainingPlans());
            userResponseDto.setTrainingPlans(listResponseDto);
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

    @Override
    public PaginationResponseDto<UserResponseDto> searchUserByUsername(
            String searchSentence,
            PaginationRequestDto paginationRequestDto) {

        Pageable pageable = PageRequest.of(
                paginationRequestDto.getPageNum(),
                paginationRequestDto.getPageSize());

        Page<User> userPage = userRepository.findUserByUsernameContainingIgnoreCase(
                searchSentence,
                pageable);

        return searchUsers(userPage, paginationRequestDto);
    }

    @Override
    public PaginationResponseDto<UserResponseDto> searchUserByEmail(
            String searchSentence,
            PaginationRequestDto paginationRequestDto) {

        Pageable pageable = PageRequest.of(
                paginationRequestDto.getPageNum(),
                paginationRequestDto.getPageSize());

        Page<User> userPage = userRepository.findUserByEmailContainingIgnoreCase(
                searchSentence,
                pageable);

        return searchUsers(userPage, paginationRequestDto);
    }

    @Override
    public PaginationResponseDto<UserResponseDto> searchUserByPhone(
            String searchSentence,
            PaginationRequestDto paginationRequestDto) {

        Pageable pageable = PageRequest.of(
                paginationRequestDto.getPageNum(),
                paginationRequestDto.getPageSize());

        Page<User> userPage = userRepository.findUserByPhoneContaining(
                searchSentence,
                pageable);

        return searchUsers(userPage, paginationRequestDto);
    }

    private PaginationResponseDto<UserResponseDto> searchUsers(
            Page<User> userPage,
            PaginationRequestDto paginationRequestDto) {

        List<UserResponseDto> result = userPage.getContent()
                .stream()
                .map(userMapper::userToUserResponseDto)
                .filter(Objects::nonNull)
                .toList();
        PagingMeta pagingMeta = new PagingMeta(
                userPage.getTotalElements(),
                userPage.getTotalPages(),
                paginationRequestDto.getPageNum() + 1,
                paginationRequestDto.getPageSize(),
                null, null);
        return new PaginationResponseDto<>(pagingMeta, result);
    }

    @Override
    public List<DayCountResponseDto> getUserDayCounts() {
        LocalDate today = com.example.corevo.utils.TimeUtil.today();
        LocalDate startDate = today.minusDays(6);

        List<Object[]> results = userRepository.countUserByDay(startDate);

        Map<LocalDate, Long> countMap = new HashMap<LocalDate, Long>();
        for (Object[] row : results) {
            LocalDate day = ((java.sql.Date) row[0]).toLocalDate();
            Long count = (Long) row[1];
            countMap.put(day, count);
        }

        List<DayCountResponseDto> result = new ArrayList<>();
        for (int i = 0; i < 7; i++) {
            LocalDate day = startDate.plusDays(i);
            String dayName = day.getDayOfWeek().toString();
            Long count = countMap.getOrDefault(day, 0L);
            result.add(new DayCountResponseDto(dayName, count));
        }
        return result;
    }

    @Override
    public List<MonthCountResponseDto> getUserMonthCounts() {
        LocalDate today = com.example.corevo.utils.TimeUtil.today();
        LocalDate startDate = today.minusMonths(11).withDayOfMonth(1);

        List<Object[]> results = userRepository.countUserByMonth(startDate);

        Map<YearMonth, Long> countMap = new HashMap<>();
        for (Object[] row : results) {
            YearMonth month = YearMonth.parse((String) row[0]); // "2025-08"
            Long count = (Long) row[1];
            countMap.put(month, count);
        }

        List<MonthCountResponseDto> result = new ArrayList<>();
        for (int i = 0; i < 12; i++) {
            YearMonth month = YearMonth.from(startDate.plusMonths(i));
            Long count = countMap.getOrDefault(month, 0L);

            String formattedMonth = month.getMonth().getDisplayName(TextStyle.FULL, Locale.ENGLISH)
                    + " " + month.getYear(); // e.g., "August 2025"

            result.add(new MonthCountResponseDto(formattedMonth, count));
        }

        return result;
    }

}
