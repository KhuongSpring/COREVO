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
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.nimbusds.jwt.SignedJWT;
import lombok.*;
import lombok.experimental.FieldDefaults;
import lombok.experimental.NonFinal;
import lombok.extern.java.Log;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.text.ParseException;
import java.time.*;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@Service
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class AuthServiceImpl implements AuthService {

    UserRepository userRepository;

    InvalidatedTokenRepository invalidatedTokenRepository;

    AuthMapper authMapper;

    JwtService jwtService;

    EmailService emailService;

    UserDetailsServiceImpl userDetailsService;

    Map<String, PendingRegistrationRequestDto> pendingRegisterMap = new ConcurrentHashMap<>();

    Map<String, PendingResetPasswordRequestDto> pendingResetPasswordMap = new ConcurrentHashMap<>();

    Map<String, PendingRecoveryRequestDto> pendingRecoveryMap = new ConcurrentHashMap<>();

    @NonFinal
    @Value("${jwt.access.expiration_time}")
    long ACCESS_TOKEN_EXPIRATION;

    @NonFinal
    @Value("${jwt.refresh.expiration_time}")
    long REFRESH_TOKEN_EXPIRATION;

    @NonFinal
    @Value("${spring.security.oauth2.client.registration.google.client-id}")
    String GOOGLE_CLIENT_ID;

    public AuthServiceImpl(
            UserRepository userRepository,
            InvalidatedTokenRepository invalidatedTokenRepository,
            JwtService jwtService,
            AuthMapper authMapper,
            EmailService emailService,
            UserDetailsServiceImpl userDetailsService
    ) {
        this.userRepository = userRepository;
        this.invalidatedTokenRepository = invalidatedTokenRepository;
        this.jwtService = jwtService;
        this.authMapper = authMapper;
        this.emailService = emailService;
        this.userDetailsService = userDetailsService;
    }

    @Override
    public LoginResponseDto authentication(LoginRequestDto request) {

        if (!userRepository.existsUserByUsername((request.getUsername())))
            throw new VsException(HttpStatus.UNAUTHORIZED, ErrorMessage.Auth.ERR_INCORRECT_USERNAME);

        User user = userRepository.findByUsername(request.getUsername());

        if (Boolean.TRUE.equals(user.getIsDeleted())) {
            LocalDate expiredDate = user.getDeletedAt().plusDays(CommonConstant.ACCOUNT_RECOVERY_DAYS);
            if (LocalDate.now().isBefore(expiredDate)) {
                long daysSinceDeleted = ChronoUnit.DAYS.between(LocalDate.now(), expiredDate);

                return LoginResponseDto.builder()
                        .status(HttpStatus.UNAUTHORIZED)
                        .message(ErrorMessage.Auth.ERR_LOGIN_FAIL)
                        .isDeleted(CommonConstant.TRUE)
                        .canRecovery(CommonConstant.TRUE)
                        .dayRecoveryRemaining(daysSinceDeleted)
                        .build();
            } else {
                return LoginResponseDto.builder()
                        .status(HttpStatus.UNAUTHORIZED)
                        .message(ErrorMessage.Auth.ERR_LOGIN_FAIL)
                        .isDeleted(CommonConstant.TRUE)
                        .canRecovery(CommonConstant.FALSE)
                        .dayRecoveryRemaining(0)
                        .build();
            }
        }

        if (Boolean.TRUE.equals(user.getIsLocked())) {
            return LoginResponseDto.builder()
                    .status(HttpStatus.UNAUTHORIZED)
                    .message(ErrorMessage.Auth.ERR_ACCOUNT_LOCKED)
                    .build();
        }

        PasswordEncoder passwordEncoder = new BCryptPasswordEncoder(10);

        boolean auth = passwordEncoder.matches(request.getPassword(), user.getPassword());

        if (!auth)
            throw new VsException(HttpStatus.UNAUTHORIZED, ErrorMessage.Auth.ERR_LOGIN_FAIL);

        var accessToken = jwtService.generateToken(user, ACCESS_TOKEN_EXPIRATION);
        var refreshToken = jwtService.generateToken(user, REFRESH_TOKEN_EXPIRATION);

        return LoginResponseDto.builder()
                .status(HttpStatus.OK)
                .message(SuccessMessage.Auth.LOGIN_SUCCESS)
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .id(user.getId())
                .isDeleted(CommonConstant.FALSE)
                .tokenType(CommonConstant.BEARER_TOKEN)
                .build();
    }

    @Override
    public LoginResponseDto loginWithGoogle(OAuth2GoogleRequestDto request) throws GeneralSecurityException, IOException {
        GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier
                .Builder(new NetHttpTransport(), new JacksonFactory())
                .setAudience(Collections.singletonList(GOOGLE_CLIENT_ID))
                .build();

        GoogleIdToken token = verifier.verify(request.getIdToken());

        if (token != null) {
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
                newUser.setCreatedAt(LocalDate.now());

                return userRepository.save(newUser);
            });

            if (Boolean.TRUE.equals(user.getIsDeleted())) {
                LocalDate expiredDate = user.getDeletedAt().plusDays(CommonConstant.ACCOUNT_RECOVERY_DAYS);
                if (LocalDate.now().isBefore(expiredDate)) {
                    long daysSinceDeleted = ChronoUnit.DAYS.between(LocalDate.now(), expiredDate);

                    return LoginResponseDto.builder()
                            .status(HttpStatus.UNAUTHORIZED)
                            .message(ErrorMessage.Auth.ERR_LOGIN_FAIL)
                            .isDeleted(CommonConstant.TRUE)
                            .canRecovery(CommonConstant.TRUE)
                            .dayRecoveryRemaining(daysSinceDeleted)
                            .build();
                } else {
                    return LoginResponseDto.builder()
                            .status(HttpStatus.UNAUTHORIZED)
                            .message(ErrorMessage.Auth.ERR_LOGIN_FAIL)
                            .isDeleted(CommonConstant.TRUE)
                            .canRecovery(CommonConstant.FALSE)
                            .dayRecoveryRemaining(0)
                            .build();
                }
            }

            if (Boolean.TRUE.equals(user.getIsLocked())) {
                return LoginResponseDto.builder()
                        .status(HttpStatus.UNAUTHORIZED)
                        .message(ErrorMessage.Auth.ERR_ACCOUNT_LOCKED)
                        .build();
            }

            String accessToken = jwtService.generateToken(user, ACCESS_TOKEN_EXPIRATION);
            String refreshToken = jwtService.generateToken(user, REFRESH_TOKEN_EXPIRATION);

            return LoginResponseDto.builder()
                    .status(HttpStatus.OK)
                    .message(SuccessMessage.Auth.LOGIN_SUCCESS)
                    .accessToken(accessToken)
                    .refreshToken(refreshToken)
                    .id(user.getId())
                    .isDeleted(CommonConstant.FALSE)
                    .tokenType(CommonConstant.BEARER_TOKEN)
                    .build();
        } else {
            return LoginResponseDto.builder()
                    .status(HttpStatus.UNAUTHORIZED)
                    .message(ErrorMessage.Auth.ERR_LOGIN_FAIL)
                    .isDeleted(CommonConstant.FALSE)
                    .build();
        }
    }

    @Override
    public CommonResponseDto logout(LogoutRequestDto request) {
        String JWTID = null;
        Date expirationTime = null;

        try {
            SignedJWT signedJWT = SignedJWT.parse(request.getToken());

            JWTID = signedJWT.getJWTClaimsSet().getJWTID();
            expirationTime = signedJWT.getJWTClaimsSet().getExpirationTime();

            invalidatedTokenRepository.save(new InvalidatedToken(JWTID, expirationTime));

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
    public UserResponseDto verifyOtpToRegister(VerifyOtpRequestDto request) {

        PendingRegistrationRequestDto pending = pendingRegisterMap.get(request.getEmail());

        if (pending == null)
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_EMAIL_NOT_EXISTED);

        if (pending.isExpired())
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.Auth.ERR_OTP_EXPIRED_OR_NOT_FOUND);

        if (!pending.getOtp().equals(request.getOtp()))
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.Auth.ERR_OTP_INVALID);

        RegisterRequestDto req = pending.getRequest();

        User user = authMapper.registerRequestDtoToUser(req);

        PasswordEncoder passwordEncoder = new BCryptPasswordEncoder(10);

        user.setPassword(passwordEncoder.encode(req.getPassword()));
        user.setRole(Role.USER);
        user.setCreatedAt(LocalDate.now());
        user.setIsLocked(false);
        user.setCreatedAt(LocalDate.now());

        userRepository.save(user);

        pendingRegisterMap.remove(request.getEmail());

        return authMapper.userToUserResponseDto(user);
    }

    @Override
    public void forgotPassword(ForgotPasswordRequestDto request) {

        if (!userRepository.existsUserByEmail(request.getEmail()))
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_EMAIL_NOT_EXISTED);

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
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_EMAIL_NOT_EXISTED);

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
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_EMAIL_NOT_EXISTED);

        if (!request.getNewPassword().equals(request.getReEnterPassword()))
            throw new VsException(HttpStatus.UNPROCESSABLE_ENTITY, ErrorMessage.User.ERR_RE_ENTER_PASSWORD_NOT_MATCH);

        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_USER_NOT_EXISTED));

        PasswordEncoder passwordEncoder = new BCryptPasswordEncoder(10);

        if (passwordEncoder.matches(request.getNewPassword(), user.getPassword()))
            throw new VsException(HttpStatus.CONFLICT, ErrorMessage.User.ERR_DUPLICATE_OLD_PASSWORD);

        user.setPassword(passwordEncoder.encode(request.getNewPassword()));

        userRepository.save(user);

        pendingResetPasswordMap.remove(request.getEmail());

        return authMapper.userToUserResponseDto(user);
    }

    @Override
    public CommonResponseDto sendEmailRecoveryOtp(RecoveryRequestDto request) {

        User deletedUser = userRepository.findDeletedUserByEmail(request.getEmail())
                .orElseThrow(() -> new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_ACCOUNT_NOT_DELETED));

        LocalDate expiredDate = deletedUser.getDeletedAt().plusDays(CommonConstant.ACCOUNT_RECOVERY_DAYS);

        if (LocalDate.now().isAfter(expiredDate)) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_ACCOUNT_RECOVERY_EXPIRED);
        }

        String otp = generateOtp();

        PendingRecoveryRequestDto pendingRecoveryRequest = new PendingRecoveryRequestDto();

        pendingRecoveryRequest.setRequest(request);
        pendingRecoveryRequest.setOtp(otp);
        pendingRecoveryRequest.setExpireAt(LocalDateTime.now().plusMinutes(5));

        pendingRecoveryMap.put(request.getEmail(), pendingRecoveryRequest);

        emailService.sendOtpEmail(request.getEmail(), otp);

        return new CommonResponseDto(HttpStatus.OK, SuccessMessage.Auth.SUCCESS_SEND_OTP);
    }

    @Override
    public boolean verifyOtpToRecovery(VerifyOtpRequestDto request) {

        PendingRecoveryRequestDto pending = pendingRecoveryMap.get(request.getEmail());

        if (pending == null)
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_EMAIL_NOT_EXISTED);

        if (pending.isExpired())
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.Auth.ERR_OTP_EXPIRED_OR_NOT_FOUND);

        if (!pending.getOtp().equals(request.getOtp()))
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.Auth.ERR_OTP_INVALID);

        return true;
    }

    @Override
    public CommonResponseDto recoverAccount(VerifyOtpRequestDto request) {

        if (!verifyOtpToRecovery(request)) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.Auth.ERR_OTP_INVALID);
        }

        User deletedUser = userRepository.findDeletedUserByEmail(request.getEmail())
                .orElseThrow(() -> new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_ACCOUNT_NOT_DELETED));

        LocalDate expiredDate = deletedUser.getDeletedAt().plusDays(CommonConstant.ACCOUNT_RECOVERY_DAYS);

        if (LocalDate.now().isAfter(expiredDate)) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.User.ERR_ACCOUNT_RECOVERY_EXPIRED);
        }

        deletedUser.setIsDeleted(CommonConstant.FALSE);
        deletedUser.setDeletedAt(null);

        userRepository.save(deletedUser);

        pendingRecoveryMap.remove(request.getEmail());

        return new CommonResponseDto(HttpStatus.OK, SuccessMessage.User.RECOVERY_SUCCESS);
    }

    @Override
    public String generateOtp() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }
}
