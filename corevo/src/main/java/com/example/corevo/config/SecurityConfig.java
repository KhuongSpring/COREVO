package com.example.corevo.config;

import com.example.corevo.constant.RoleConstant;
import com.example.corevo.security.JwtAuthenticationFilter;
import com.example.corevo.service.OAuth2.CustomOAuth2UserService;
import com.example.corevo.service.OAuth2.OAuth2AuthenticationSuccessHandler;
import com.example.corevo.service.OAuth2.OAuth2PkceAuthorizationRequestResolver;
import lombok.AccessLevel;
import lombok.experimental.FieldDefaults;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.client.registration.InMemoryClientRegistrationRepository;
import org.springframework.security.oauth2.client.web.OAuth2AuthorizationRequestRedirectFilter;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
@FieldDefaults(level = AccessLevel.PRIVATE)
public class SecurityConfig {
    @Value("${security.public-endpoints}")
    String[] PUBLIC_END_POINT;

    @Value("${security.user-endpoints}")
    String[] USER_END_POINT;

    @Value("${security.admin-endpoints}")
    String[] ADMIN_END_POINT;

    @Value("${security.swagger-endpoints}")
    String[] OPEN_API;

    final JwtAuthenticationFilter jwtAuthenticationFilter;

    final CustomOAuth2UserService customOAuth2UserService;

    final OAuth2AuthenticationSuccessHandler oAuth2AuthenticationSuccessHandler;

    public SecurityConfig(
            JwtAuthenticationFilter jwtAuthenticationFilter,
            CustomOAuth2UserService customOAuth2UserService,
            OAuth2AuthenticationSuccessHandler oAuth2AuthenticationSuccessHandler
    ) {
        this.jwtAuthenticationFilter = jwtAuthenticationFilter;
        this.customOAuth2UserService = customOAuth2UserService;
        this.oAuth2AuthenticationSuccessHandler = oAuth2AuthenticationSuccessHandler;
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http, InMemoryClientRegistrationRepository clientRegistrationRepository) throws Exception {
        http.cors(Customizer.withDefaults());

        http.csrf(AbstractHttpConfigurer::disable);

        http.authorizeHttpRequests(request -> request
                .requestMatchers(PUBLIC_END_POINT).permitAll()
                .requestMatchers(USER_END_POINT).hasAuthority(RoleConstant.USER)
                .requestMatchers(ADMIN_END_POINT).hasAuthority(RoleConstant.ADMIN)
                .requestMatchers(OPEN_API).permitAll()
                .anyRequest().authenticated());

        OAuth2PkceAuthorizationRequestResolver pkceResolver =
                new OAuth2PkceAuthorizationRequestResolver(
                        clientRegistrationRepository,
                        OAuth2AuthorizationRequestRedirectFilter.DEFAULT_AUTHORIZATION_REQUEST_BASE_URI
                );

        http.oauth2Login(oauth2 -> oauth2
                .authorizationEndpoint(authorizationEndpointConfig -> authorizationEndpointConfig
                        .authorizationRequestResolver(pkceResolver))
                .userInfoEndpoint(userInfo -> userInfo.userService(customOAuth2UserService))
                .successHandler(oAuth2AuthenticationSuccessHandler)
        );

        http.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        http.sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS));

        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
