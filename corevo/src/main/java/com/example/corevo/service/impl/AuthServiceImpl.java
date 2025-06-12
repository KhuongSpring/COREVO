package com.example.corevo.service.impl;

import com.example.corevo.constant.ErrorMessage;
import com.example.corevo.domain.dto.request.LoginRequestDto;
import com.example.corevo.domain.dto.request.UserCreateRequestDto;
import com.example.corevo.domain.dto.response.LoginResponseDto;
import com.example.corevo.domain.dto.response.user.UserResponseDto;
import com.example.corevo.domain.entity.Role;
import com.example.corevo.domain.entity.User;
import com.example.corevo.exception.NotFoundException;
import com.example.corevo.exception.VsException;
import com.example.corevo.repository.UserRepository;
import com.example.corevo.service.AuthService;
import com.example.corevo.service.JwtService;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDate;

@Service
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class AuthServiceImpl implements AuthService {
    UserRepository userRepository;
    JwtService jwtService;
    ModelMapper modelMapper;

    @Override
    public LoginResponseDto authentication(LoginRequestDto request) {
        if (!userRepository.existsUserByUsername((request.getEmailOrUsername())))
            throw new NotFoundException(ErrorMessage.Auth.ERR_LOGIN_FAIL);

        User user = userRepository.findByUsername(request.getEmailOrUsername());
        PasswordEncoder passwordEncoder = new BCryptPasswordEncoder(10);
        boolean auth = passwordEncoder.matches(request.getPassword(), user.getPassword());

        if (!auth) throw new NotFoundException(ErrorMessage.Auth.ERR_LOGIN_FAIL);

        var token = jwtService.generateToken(request.getEmailOrUsername());
        return LoginResponseDto.builder()
                .accessToken(token)
                .id(user.getId())
                .build();
    }

    @Override
    public UserResponseDto register(UserCreateRequestDto request) {
        if (userRepository.existsUserByUsername(request.getUsername()))
            throw new VsException(HttpStatus.CONFLICT, ErrorMessage.User.ERR_USERNAME_EXISTED);
        if (userRepository.existsUserByEmail(request.getEmail()))
            throw new VsException(HttpStatus.CONFLICT, ErrorMessage.User.ERR_EMAIL_EXISTED);

        User user = modelMapper.map(request, User.class);

        PasswordEncoder passwordEncoder = new BCryptPasswordEncoder(10);
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setRole(Role.USER);
        user.setCreatedAt(LocalDate.now());
        userRepository.save(user);
        return modelMapper.map(user, UserResponseDto.class);
    }
}
