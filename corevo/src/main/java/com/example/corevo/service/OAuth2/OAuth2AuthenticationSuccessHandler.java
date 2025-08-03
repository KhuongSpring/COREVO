package com.example.corevo.service.OAuth2;

import com.example.corevo.domain.entity.user.Role;
import com.example.corevo.domain.entity.user.User;
import com.example.corevo.repository.UserRepository;
import com.example.corevo.service.JwtService;
import com.example.corevo.service.UserService;
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
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.UUID;

@Slf4j
@Component
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class OAuth2AuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    JwtService jwtService;

    UserService userServicel;

    @NonFinal
    @Value("${jwt.access.expiration_time}")
    long ACCESS_TOKEN_EXPIRATION;

    @NonFinal
    @Value("${jwt.refresh.expiration_time}")
    long REFRESH_TOKEN_EXPIRATION;

    @NonFinal
    @Value("${app.oauth2.frontend-redirect-uri}")
    String frontendRedirectUri;

    public OAuth2AuthenticationSuccessHandler(JwtService jwtService, UserService userServicel) {
        this.jwtService = jwtService;
        this.userServicel = userServicel;
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

        User user = userServicel.findOrCreateUser(email, name, picture, firstName, lastName);

        String accessToken = jwtService.generateToken(user, ACCESS_TOKEN_EXPIRATION);
        String refreshToken = jwtService.generateToken(user, REFRESH_TOKEN_EXPIRATION);

        String encodedAccessToken = URLEncoder.encode(accessToken, StandardCharsets.UTF_8);
        String encodedRefreshToken = URLEncoder.encode(refreshToken, StandardCharsets.UTF_8);

        String redirectUrl = frontendRedirectUri
                + "?access_token=" + encodedAccessToken
                + "&refresh_token=" + encodedRefreshToken;


        response.sendRedirect(redirectUrl);
    }

}

