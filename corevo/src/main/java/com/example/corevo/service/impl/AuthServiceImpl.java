package com.example.corevo.service.impl;

import com.example.corevo.constant.ErrorMessage;
import com.example.corevo.domain.dto.request.auth.ForgotPasswordRequestDto;
import com.example.corevo.domain.dto.request.auth.LoginRequestDto;
import com.example.corevo.domain.dto.request.auth.RegisterRequestDto;
import com.example.corevo.domain.dto.request.auth.ResetPasswordRequestDto;
import com.example.corevo.domain.dto.request.auth.otp.PendingRegistrationRequestDto;
import com.example.corevo.domain.dto.request.auth.otp.PendingResetPasswordRequestDto;
import com.example.corevo.domain.dto.request.auth.otp.VerifyOtpRequestDto;
import com.example.corevo.domain.dto.response.auth.LoginResponseDto;
import com.example.corevo.domain.dto.response.user.UserResponseDto;
import com.example.corevo.domain.entity.Role;
import com.example.corevo.domain.entity.User;
import com.example.corevo.exception.VsException;
import com.example.corevo.repository.UserRepository;
import com.example.corevo.service.AuthService;
import com.example.corevo.service.EmailService;
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
import java.time.LocalDateTime;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

@Service
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class AuthServiceImpl implements AuthService {
    UserRepository userRepository;
    JwtService jwtService;
    ModelMapper modelMapper;
    EmailService emailService;

    Map<String, PendingRegistrationRequestDto> pendingRegisterMap = new ConcurrentHashMap<>();
    Map<String, PendingResetPasswordRequestDto> pendingResetPasswordMap = new ConcurrentHashMap<>();

    @Override
    public LoginResponseDto authentication(LoginRequestDto request) {
        if (!userRepository.existsUserByUsername((request.getUsername())))
            throw new VsException(HttpStatus.UNAUTHORIZED, ErrorMessage.Auth.ERR_INCORRECT_USERNAME);

        User user = userRepository.findByUsername(request.getUsername());
        PasswordEncoder passwordEncoder = new BCryptPasswordEncoder(10);
        boolean auth = passwordEncoder.matches(request.getPassword(), user.getPassword());

        if (!auth) throw new VsException(HttpStatus.UNAUTHORIZED, ErrorMessage.Auth.ERR_LOGIN_FAIL);

        var token = jwtService.generateToken(request.getUsername());
        return LoginResponseDto.builder()
                .accessToken(token)
                .id(user.getId())
                .build();
    }

    @Override
    public void register(RegisterRequestDto request) {
        if (userRepository.existsUserByUsername(request.getUsername()))
            throw new VsException(HttpStatus.CONFLICT, ErrorMessage.User.ERR_USERNAME_EXISTED);
        if (userRepository.existsUserByEmail(request.getEmail()))
            throw new VsException(HttpStatus.CONFLICT, ErrorMessage.User.ERR_EMAIL_EXISTED);

        String otp = generateOtp();
        PendingRegistrationRequestDto pending = new PendingRegistrationRequestDto();
        pending.setRequest(request);
        pending.setOtp(otp);
        pending.setExpireAt(LocalDateTime.now().plusMinutes(5));

        pendingRegisterMap.put(request.getEmail(), pending);

        emailService.sendOtpEmail(request.getEmail(), otp);
    }

    @Override
    public UserResponseDto verifyOtpToRegister(VerifyOtpRequestDto request){
        PendingRegistrationRequestDto pending = pendingRegisterMap.get(request.getEmail());
        if (pending == null)
            throw new VsException(HttpStatus.CONFLICT, ErrorMessage.User.ERR_EMAIL_NOT_EXISTED);
        if (pending.isExpired())
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.Auth.ERR_OTP_EXPIRED_OR_NOT_FOUND);
        if (!pending.getOtp().equals(request.getOtp()))
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.Auth.ERR_OTP_INVALID);

        RegisterRequestDto req = pending.getRequest();
        User user = modelMapper.map(req, User.class);

        PasswordEncoder passwordEncoder = new BCryptPasswordEncoder(10);
        user.setPassword(passwordEncoder.encode(req.getPassword()));
        user.setRole(Role.USER);
        user.setCreatedAt(LocalDate.now());
        userRepository.save(user);
        pendingRegisterMap.remove(request.getEmail());

        return modelMapper.map(user, UserResponseDto.class);
    }

    @Override
    public void forgotPassword(ForgotPasswordRequestDto request) {
        if (!userRepository.existsUserByEmail(request.getEmail()))
            throw new VsException(HttpStatus.CONFLICT, ErrorMessage.User.ERR_EMAIL_NOT_EXISTED);

        String otp = generateOtp();
        PendingResetPasswordRequestDto pending = new PendingResetPasswordRequestDto();
        pending.setRequest(request);
        pending.setOtp(otp);
        pending.setExpireAt(LocalDateTime.now().plusMinutes(5));
        pendingResetPasswordMap.put(request.getEmail(), pending);

        emailService.sendOtpEmail(request.getEmail(), otp);
    }

    @Override
    public boolean verifyOtpToResetPassword(VerifyOtpRequestDto request) {
        PendingResetPasswordRequestDto pending = pendingResetPasswordMap.get(request.getEmail());
        if (pending == null)
            throw new VsException(HttpStatus.CONFLICT, ErrorMessage.User.ERR_EMAIL_NOT_EXISTED);
        if (pending.isExpired())
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.Auth.ERR_OTP_EXPIRED_OR_NOT_FOUND);
        if (!pending.getOtp().equals(request.getOtp()))
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.Auth.ERR_OTP_INVALID);

        return pendingResetPasswordMap.containsKey(request.getEmail())
                && pendingResetPasswordMap.get(request.getEmail()).getOtp().equals(request.getOtp());
    }

    @Override
    public UserResponseDto resetPassword(ResetPasswordRequestDto request) {
        if (!userRepository.existsUserByEmail(request.getEmail()))
            throw new VsException(HttpStatus.CONFLICT, ErrorMessage.User.ERR_EMAIL_NOT_EXISTED);

        if (!request.getNewPassword().equals(request.getReEnterPassword()))
            throw new VsException(HttpStatus.UNPROCESSABLE_ENTITY, ErrorMessage.User.ERR_RE_ENTER_PASSWORD_NOT_MATCH);

        User user = userRepository.findByEmail(request.getEmail());
        PasswordEncoder passwordEncoder = new BCryptPasswordEncoder(10);

        if (passwordEncoder.matches(request.getNewPassword(), user.getPassword()))
            throw new VsException(HttpStatus.CONFLICT, ErrorMessage.User.ERR_DUPLICATE_OLD_PASSWORD);

        user.setPassword(passwordEncoder.encode(request.getNewPassword()));

        userRepository.save(user);

        pendingResetPasswordMap.remove(request.getEmail());
        return modelMapper.map(user, UserResponseDto.class);
    }

    @Override
    public String generateOtp() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }
}
