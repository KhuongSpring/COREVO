package com.example.corevo.service.OAuth2;

import com.example.corevo.domain.entity.user.Role;
import com.example.corevo.domain.entity.user.User;
import com.example.corevo.repository.UserRepository;
import com.example.corevo.service.JwtService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.AccessLevel;
import lombok.experimental.FieldDefaults;
import lombok.experimental.NonFinal;
import jakarta.servlet.http.Cookie;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.time.LocalDate;
import java.util.UUID;

@Slf4j
@Component
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class OAuth2AuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    JwtService jwtService;

    UserRepository userRepository;

    @NonFinal
    @Value("${jwt.access.expiration_time}")
    long ACCESS_TOKEN_EXPIRATION;

    @NonFinal
    @Value("${jwt.refresh.expiration_time}")
    long REFRESH_TOKEN_EXPIRATION;

    @NonFinal
    @Value("${app.oauth2.frontend-redirect-uri}")
    String frontendRedirectUri;

    public OAuth2AuthenticationSuccessHandler(JwtService jwtService, UserRepository userRepository) {
        this.jwtService = jwtService;
        this.userRepository = userRepository;
    }

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request,
                                        HttpServletResponse response,
                                        Authentication authentication) throws IOException {
        OAuth2User oAuth2User = (OAuth2User) authentication.getPrincipal();

        String email = oAuth2User.getAttribute("email");
        String name = oAuth2User.getAttribute("name");
        String picture = oAuth2User.getAttribute("picture");
        String firstName = oAuth2User.getAttribute("given_name");
        String lastName = oAuth2User.getAttribute("family_name");

        User user = findOrCreateUser(email, name, picture, firstName, lastName);

        String token = jwtService.generateToken(user, ACCESS_TOKEN_EXPIRATION);

        Cookie cookie = new Cookie("access_token", token);
        cookie.setHttpOnly(true);
        cookie.setSecure(true);
        cookie.setPath("/");
        cookie.setMaxAge((int) ACCESS_TOKEN_EXPIRATION / 1000);

        response.addCookie(cookie);

        response.sendRedirect(frontendRedirectUri);
    }

    private User findOrCreateUser(String email, String name, String picture, String firstName, String lastName) {
        return userRepository.findByEmail(email).orElseGet(() -> {
            log.info("Creating new user for email: {}", email);

            User newUser = new User();
            newUser.setUsername(name);
            newUser.setPassword(UUID.randomUUID().toString());
            newUser.setEmail(email);
            newUser.setFirstName(firstName);
            newUser.setLastName(lastName);
            newUser.setLinkAvatar(picture);
            newUser.setProvider("GOOGLE");
            newUser.setRole(Role.USER);
            newUser.setIsLocked(false);
            newUser.setCreatedAt(LocalDate.now());

            User savedUser = userRepository.save(newUser);
            log.info("Created new user w id {} and email {}", savedUser.getId(), email);
            return savedUser;
        });
    }
}

