package com.example.corevo.service.impl;

import com.example.corevo.constant.CommonConstant;
import com.example.corevo.constant.ErrorMessage;
import com.example.corevo.constant.SuccessMessage;
import com.example.corevo.domain.dto.pagination.PaginationRequestDto;
import com.example.corevo.domain.dto.pagination.PaginationResponseDto;
import com.example.corevo.domain.dto.pagination.PagingMeta;
import com.example.corevo.domain.dto.request.admin.CreateUserRequestDto;
import com.example.corevo.domain.dto.request.admin.UpdateUserRequestDto;
import com.example.corevo.domain.dto.request.user.enter_personal_infomation.PersonalInformationRequestDto;
import com.example.corevo.domain.dto.response.CommonResponseDto;
import com.example.corevo.domain.dto.response.user.UserResponseDto;
import com.example.corevo.domain.entity.user.Address;
import com.example.corevo.domain.entity.user.User;
import com.example.corevo.domain.mapper.UserMapper;
import com.example.corevo.exception.InvalidException;
import com.example.corevo.exception.VsException;
import com.example.corevo.repository.AddressRepository;
import com.example.corevo.repository.UserRepository;
import com.example.corevo.service.UserService;
import jakarta.transaction.Transactional;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class UserServiceImpl implements UserService {
    UserRepository userRepository;
    AddressRepository addressRepository;
    UserMapper userMapper;
    PasswordEncoder passwordEncoder;

    @Override
    public UserResponseDto personalInformation(PersonalInformationRequestDto request) {
        if (!userRepository.existsUserByUsername(request.getUsername()))
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_USER_NOT_EXISTED);

        if (userRepository.existsUsersByPhone(request.getPhone()))
            throw new VsException(HttpStatus.CONFLICT, ErrorMessage.User.ERR_PHONE_EXISTED);

        User user = userRepository.findByUsername(request.getUsername());
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

        return userMapper.userToUserResponseDto(user);

    }

    @Override
    public UserResponseDto uploadAvatar(String id, String url) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_USER_NOT_EXISTED));
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
            throw new VsException(HttpStatus.CONFLICT, ErrorMessage.User.ERR_EMAIL_EXISTED);
        }
        if (userRepository.existsUserByUsername(request.getUsername())) {
            throw new VsException(HttpStatus.CONFLICT, ErrorMessage.User.ERR_USERNAME_EXISTED);
        }
        if (userRepository.existsUsersByPhone(request.getPhone())) {
            throw new VsException(HttpStatus.CONFLICT, ErrorMessage.User.ERR_PHONE_EXISTED);
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
        userMapper.updateUserFromDto(request, user);
        User updatedUser = userRepository.save(user);
        return userMapper.userToUserResponseDto(updatedUser);
    }

    @Override
    @Transactional
    public CommonResponseDto deleteUserPermanently(String userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_USER_NOT_EXISTED));
        Address userAddress = user.getAddress();
        userRepository.delete(user);
        if (userAddress != null && !userRepository.existsByAddress(userAddress)) {
            addressRepository.delete(userAddress);
        }
        return new CommonResponseDto(CommonConstant.TRUE, SuccessMessage.User.DELETE_SUCCESS);
    }

    @Override
    public CommonResponseDto lockUser(String userId) {
        Optional<User> user = userRepository.findById(userId);
        checkLockUser(user, userId);
        user.get().setIsLocked(CommonConstant.TRUE);
        userRepository.save(user.get());
        return new CommonResponseDto(CommonConstant.TRUE, SuccessMessage.User.LOCKED_SUCCESS);
    }

    @Override
    public CommonResponseDto unlockUser(String userId) {
        Optional<User> user = userRepository.findById(userId);
        checkUnlockUser(user, userId);
        user.get().setIsLocked(CommonConstant.FALSE);
        userRepository.save(user.get());
        return new CommonResponseDto(CommonConstant.TRUE, SuccessMessage.User.UNLOCKED_SUCCESS);
    }

    private void checkLockUser(Optional<User> user, String userId) {
        if (user.isEmpty()) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_USER_NOT_EXISTED);
        } else {
            if (user.get().getIsLocked()) {
                throw new InvalidException((ErrorMessage.User.ERR_USER_IS_LOCKED));
            }
        }
    }

    private void checkUnlockUser(Optional<User> user, String userId) {
        if (user.isEmpty()) {
            throw new VsException(HttpStatus.NOT_FOUND, ErrorMessage.User.ERR_USER_NOT_EXISTED);
        } else {
            if (!user.get().getIsLocked()) {
                throw new InvalidException((ErrorMessage.User.ERR_USER_IS_NOT_LOCKED));
            }
        }
    }
}
