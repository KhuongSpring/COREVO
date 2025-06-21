package com.example.corevo.service.impl;

import com.example.corevo.constant.ErrorMessage;
import com.example.corevo.domain.dto.request.user.enter_personal_infomation.PersonalInformationRequestDto;
import com.example.corevo.domain.dto.response.user.UserResponseDto;
import com.example.corevo.domain.entity.Address;
import com.example.corevo.domain.entity.User;
import com.example.corevo.exception.VsException;
import com.example.corevo.repository.AddressRepository;
import com.example.corevo.repository.UserRepository;
import com.example.corevo.service.UserService;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class UserServiceImpl implements UserService {
    UserRepository userRepository;
    AddressRepository addressRepository;
    ModelMapper modelMapper;

    @Override
    public UserResponseDto personalInformation(PersonalInformationRequestDto request) {
        if (!userRepository.existsUserByUsername(request.getUsername()))
            throw new VsException(HttpStatus.NOT_FOUND, ErrorMessage.User.ERR_USER_NOT_EXISTED);

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

        return modelMapper.map(user, UserResponseDto.class);

    }

    @Override
    public UserResponseDto uploadAvatar(String id, String url) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new VsException(HttpStatus.NOT_FOUND, ErrorMessage.User.ERR_USER_NOT_EXISTED));

        user.setLinkAvatar(url);
        userRepository.save(user);

        return modelMapper.map(user, UserResponseDto.class);
    }
}
