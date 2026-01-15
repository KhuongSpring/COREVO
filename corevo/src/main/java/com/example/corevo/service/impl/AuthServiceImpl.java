package com.example.corevo.service.impl;

import com.example.corevo.constant.*;
import com.example.corevo.domain.dto.request.auth.*;
import com.example.corevo.domain.dto.request.auth.otp.*;
import com.example.corevo.domain.dto.response.*;
import com.example.corevo.domain.dto.response.auth.*;
import com.example.corevo.domain.dto.response.user.*;
import com.example.corevo.domain.entity.InvalidatedToken;
import com.example.corevo.domain.entity.user.*;
import com.example.corevo.domain.mapper.AuthMapper;
import com.example.corevo.exception.VsException;
import com.example.corevo.repository.InvalidatedTokenRepository;
import com.example.corevo.repository.UserRepository;
import com.example.corevo.security.UserDetailsServiceImpl;
import com.example.corevo.service.*;
import com.example.corevo.utils.TimeUtil;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.nimbusds.jwt.SignedJWT;
import lombok.*;
import lombok.experimental.FieldDefaults;
import lombok.experimental.NonFinal;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.text.ParseException;
import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class AuthServiceImpl implements AuthService {

    UserRepository userRepository;
    InvalidatedTokenRepository invalidatedTokenRepository;
    AuthMapper authMapper;
    JwtService jwtService;
    EmailService emailService;
    UserDetailsServiceImpl userDetailsService;

    // New injected services
    OtpService otpService;
    AccountValidationService accountValidationService;
    PasswordEncoder passwordEncoder;

    ObjectMapper objectMapper;

    @NonFinal
    @Value("${jwt.access.expiration_time}")
    long ACCESS_TOKEN_EXPIRATION;

    @NonFinal
    @Value("${jwt.refresh.expiration_time}")
    long REFRESH_TOKEN_EXPIRATION;

    @NonFinal
    @Value("${spring.security.oauth2.client.registration.google.client-id}")
    String GOOGLE_CLIENT_ID;

    @Override
    public LoginResponseDto authentication(LoginRequestDto request) {
        if (!userRepository.existsUserByUsername(request.getUsername())) {
            throw new VsException(HttpStatus.UNAUTHORIZED, ErrorMessage.Auth.ERR_INCORRECT_USERNAME);
        }

        User user = userRepository.findByUsername(request.getUsername());

        // Check account status (deleted or locked)
        if (accountValidationService.isAccountDeleted(user) || accountValidationService.isAccountLocked(user)) {
            return accountValidationService.buildAccountStatusResponse(user);
        }

        // Validate password
        boolean auth = passwordEncoder.matches(request.getPassword(), user.getPassword());
        if (!auth) {
            throw new VsException(HttpStatus.UNAUTHORIZED, ErrorMessage.Auth.ERR_LOGIN_FAIL);
        }

        // Generate tokens
        String accessToken = jwtService.generateToken(user, ACCESS_TOKEN_EXPIRATION);
        String refreshToken = jwtService.generateToken(user, REFRESH_TOKEN_EXPIRATION);

        return LoginResponseDto.builder()
                .status(HttpStatus.OK)
                .message(SuccessMessage.Auth.LOGIN_SUCCESS)
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .id(user.getId())
                .isDeleted(false)
                .tokenType(CommonConstant.BEARER_TOKEN)
                .build();
    }

    @Override
    public LoginResponseDto loginWithGoogle(OAuth2GoogleRequestDto request) {
        try {
            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(new NetHttpTransport(),
                    new JacksonFactory())
                    .setAudience(Collections.singletonList(GOOGLE_CLIENT_ID))
                    .build();

            GoogleIdToken token = verifier.verify(request.getIdToken());

            if (token == null) {
                return LoginResponseDto.builder()
                        .status(HttpStatus.UNAUTHORIZED)
                        .message(ErrorMessage.Auth.ERR_LOGIN_FAIL)
                        .isDeleted(false)
                        .build();
            }

            GoogleIdToken.Payload payload = token.getPayload();

            String email = payload.getEmail();
            String firstName = (String) payload.get("given_name");
            String lastName = (String) payload.get("family_name");
            String username = email.split("@")[0];
            String picture = (String) payload.get("picture");

            User user = userRepository.findByEmail(email).orElseGet(() -> {
                User newUser = new User();
                newUser.setUsername(username);
                newUser.setFirstName(firstName);
                newUser.setLastName(lastName);
                newUser.setPassword(UUID.randomUUID().toString());
                newUser.setEmail(email);
                newUser.setLinkAvatar(picture);
                newUser.setProvider("GOOGLE");
                newUser.setRole(Role.USER);
                newUser.setIsLocked(false);
                newUser.setCreatedAt(TimeUtil.today());

                return userRepository.save(newUser);
            });

            // Check account status
            if (accountValidationService.isAccountDeleted(user) || accountValidationService.isAccountLocked(user)) {
                return accountValidationService.buildAccountStatusResponse(user);
            }

            String accessToken = jwtService.generateToken(user, ACCESS_TOKEN_EXPIRATION);
            String refreshToken = jwtService.generateToken(user, REFRESH_TOKEN_EXPIRATION);

            return LoginResponseDto.builder()
                    .status(HttpStatus.OK)
                    .message(SuccessMessage.Auth.LOGIN_SUCCESS)
                    .accessToken(accessToken)
                    .refreshToken(refreshToken)
                    .id(user.getId())
                    .isDeleted(false)
                    .tokenType(CommonConstant.BEARER_TOKEN)
                    .build();
        } catch (Exception e) {
            log.error("Google OAuth2 login failed", e);
            throw new VsException(HttpStatus.UNAUTHORIZED, ErrorMessage.Auth.ERR_LOGIN_FAIL);
        }
    }

    @Override
    public CommonResponseDto logout(LogoutRequestDto request) {
        try {
            SignedJWT signedJWT = SignedJWT.parse(request.getToken());

            String jwtId = signedJWT.getJWTClaimsSet().getJWTID();
            Date expirationTime = signedJWT.getJWTClaimsSet().getExpirationTime();

            invalidatedTokenRepository.save(new InvalidatedToken(jwtId, expirationTime));

            return new CommonResponseDto(HttpStatus.OK, SuccessMessage.Auth.LOGOUT_SUCCESS);
        } catch (ParseException e) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.Auth.ERR_GET_TOKEN_CLAIM_SET_FAIL);
        }
    }

    @Override
    public TokenRefreshResponseDto refresh(TokenRefreshRequestDto request) {
        String refreshToken = request.getRefreshToken();
        String username = jwtService.extractUsername(refreshToken);

        UserDetails userDetails = userDetailsService.loadUserByUsername(username);

        if (!jwtService.isTokenExpired(refreshToken)) {
            throw new VsException(HttpStatus.UNAUTHORIZED, ErrorMessage.Auth.EXPIRED_REFRESH_TOKEN);
        }

        if (!jwtService.isTokenValid(refreshToken, userDetails)) {
            throw new VsException(HttpStatus.UNAUTHORIZED, ErrorMessage.Auth.INVALID_REFRESH_TOKEN);
        }

        User user = userRepository.findByUsername(username);

        return TokenRefreshResponseDto.builder()
                .tokenType(CommonConstant.BEARER_TOKEN)
                .accessToken(jwtService.generateToken(user, ACCESS_TOKEN_EXPIRATION))
                .refreshToken(refreshToken)
                .build();
    }

    @Override
    public void register(RegisterRequestDto request) {
        if (userRepository.existsUserByUsername(request.getUsername())) {
            throw new VsException(HttpStatus.CONFLICT, ErrorMessage.User.ERR_USERNAME_EXISTED);
        }

        if (userRepository.existsUserByEmail(request.getEmail())) {
            throw new VsException(HttpStatus.CONFLICT, ErrorMessage.User.ERR_EMAIL_EXISTED);
        }

        String otp = otpService.generateOtp();

        // Store request data as JSON along with OTP
        try {
            String requestJson = objectMapper.writeValueAsString(request);
            otpService.storeOtp(request.getEmail(), otp, OtpType.REGISTRATION, requestJson);
        } catch (JsonProcessingException e) {
            log.error("Failed to serialize registration request", e);
            throw new VsException(HttpStatus.INTERNAL_SERVER_ERROR, ErrorMessage.ERR_EXCEPTION_GENERAL);
        }

        emailService.sendOtpEmail(request.getEmail(), otp);
    }

    @Override
    public UserResponseDto verifyOtpToRegister(VerifyOtpRequestDto request) {
        if (!otpService.validateOtp(request.getEmail(), request.getOtp(), OtpType.REGISTRATION)) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.Auth.ERR_OTP_INVALID);
        }

        String requestData = otpService.getOtpData(request.getEmail(), OtpType.REGISTRATION);
        if (requestData == null) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.Auth.ERR_OTP_EXPIRED_OR_NOT_FOUND);
        }

        RegisterRequestDto registerRequest;
        try {
            registerRequest = objectMapper.readValue(requestData, RegisterRequestDto.class);
        } catch (JsonProcessingException e) {
            log.error("Failed to deserialize registration request", e);
            throw new VsException(HttpStatus.INTERNAL_SERVER_ERROR, ErrorMessage.ERR_EXCEPTION_GENERAL);
        }

        User user = authMapper.registerRequestDtoToUser(registerRequest);
        user.setPassword(passwordEncoder.encode(registerRequest.getPassword()));
        user.setRole(Role.USER);
        user.setCreatedAt(TimeUtil.today());
        user.setIsLocked(false);

        userRepository.save(user);

        otpService.clearOtp(request.getEmail(), OtpType.REGISTRATION);

        return authMapper.userToUserResponseDto(user);
    }

    @Override
    public void forgotPassword(ForgotPasswordRequestDto request) {
        if (!userRepository.existsUserByEmail(request.getEmail())) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_EMAIL_NOT_EXISTED);
        }

        String otp = otpService.generateOtp();

        try {
            String requestJson = objectMapper.writeValueAsString(request);
            otpService.storeOtp(request.getEmail(), otp, OtpType.PASSWORD_RESET, requestJson);
        } catch (JsonProcessingException e) {
            log.error("Failed to serialize forgot password request", e);
            throw new VsException(HttpStatus.INTERNAL_SERVER_ERROR, ErrorMessage.ERR_EXCEPTION_GENERAL);
        }

        emailService.sendOtpEmail(request.getEmail(), otp);
    }

    @Override
    public boolean verifyOtpToResetPassword(VerifyOtpRequestDto request) {
        return otpService.validateOtp(request.getEmail(), request.getOtp(), OtpType.PASSWORD_RESET);
    }

    @Override
    public UserResponseDto resetPassword(ResetPasswordRequestDto request) {
        if (!userRepository.existsUserByEmail(request.getEmail())) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_EMAIL_NOT_EXISTED);
        }

        if (!request.getNewPassword().equals(request.getReEnterPassword())) {
            throw new VsException(HttpStatus.UNPROCESSABLE_ENTITY, ErrorMessage.User.ERR_RE_ENTER_PASSWORD_NOT_MATCH);
        }

        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_USER_NOT_EXISTED));

        if (passwordEncoder.matches(request.getNewPassword(), user.getPassword())) {
            throw new VsException(HttpStatus.CONFLICT, ErrorMessage.User.ERR_DUPLICATE_OLD_PASSWORD);
        }

        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        userRepository.save(user);

        otpService.clearOtp(request.getEmail(), OtpType.PASSWORD_RESET);

        return authMapper.userToUserResponseDto(user);
    }

    @Override
    public CommonResponseDto sendEmailRecoveryOtp(RecoveryRequestDto request) {
        User deletedUser = userRepository.findDeletedUserByEmail(request.getEmail())
                .orElseThrow(() -> new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_ACCOUNT_NOT_DELETED));

        if (!accountValidationService.canRecoverAccount(deletedUser)) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_ACCOUNT_RECOVERY_EXPIRED);
        }

        String otp = otpService.generateOtp();

        try {
            String requestJson = objectMapper.writeValueAsString(request);
            otpService.storeOtp(request.getEmail(), otp, OtpType.ACCOUNT_RECOVERY, requestJson);
        } catch (JsonProcessingException e) {
            log.error("Failed to serialize recovery request", e);
            throw new VsException(HttpStatus.INTERNAL_SERVER_ERROR, ErrorMessage.ERR_EXCEPTION_GENERAL);
        }

        emailService.sendOtpEmail(request.getEmail(), otp);

        return new CommonResponseDto(HttpStatus.OK, SuccessMessage.Auth.SUCCESS_SEND_OTP);
    }

    @Override
    public boolean verifyOtpToRecovery(VerifyOtpRequestDto request) {
        return otpService.validateOtp(request.getEmail(), request.getOtp(), OtpType.ACCOUNT_RECOVERY);
    }

    @Override
    public CommonResponseDto recoverAccount(VerifyOtpRequestDto request) {
        if (!verifyOtpToRecovery(request)) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.Auth.ERR_OTP_INVALID);
        }

        User deletedUser = userRepository.findDeletedUserByEmail(request.getEmail())
                .orElseThrow(() -> new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_ACCOUNT_NOT_DELETED));

        if (!accountValidationService.canRecoverAccount(deletedUser)) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_ACCOUNT_RECOVERY_EXPIRED);
        }

        deletedUser.setIsDeleted(false);
        deletedUser.setDeletedAt(null);

        userRepository.save(deletedUser);

        otpService.clearOtp(request.getEmail(), OtpType.ACCOUNT_RECOVERY);

        return new CommonResponseDto(HttpStatus.OK, SuccessMessage.User.RECOVERY_SUCCESS);
    }

    @Override
    public String generateOtp() {
        return otpService.generateOtp();
    }
}
