package com.example.corevo.service.OAuth2;

import jakarta.servlet.http.HttpServletRequest;
import lombok.AccessLevel;
import lombok.experimental.FieldDefaults;
import lombok.experimental.NonFinal;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.security.oauth2.client.web.DefaultOAuth2AuthorizationRequestResolver;
import org.springframework.security.oauth2.client.web.OAuth2AuthorizationRequestResolver;
import org.springframework.security.oauth2.core.endpoint.OAuth2AuthorizationRequest;
import org.springframework.security.oauth2.core.endpoint.PkceParameterNames;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class OAuth2PkceAuthorizationRequestResolver implements OAuth2AuthorizationRequestResolver {


    OAuth2AuthorizationRequestResolver defaultResolver;

    public OAuth2PkceAuthorizationRequestResolver(
            ClientRegistrationRepository clientRegistrationRepository,
                @Value("${spring.security.oauth2.client.registration.google.redirect-uri}") String authorizationRequestBaseUri
    ) {
        this.defaultResolver = new DefaultOAuth2AuthorizationRequestResolver(
                clientRegistrationRepository, authorizationRequestBaseUri
        );
    }

    @Override
    public OAuth2AuthorizationRequest resolve(HttpServletRequest request) {
        OAuth2AuthorizationRequest authRequest = defaultResolver.resolve(request);
        return customizeWithPkce(authRequest);
    }

    @Override
    public OAuth2AuthorizationRequest resolve(HttpServletRequest request, String clientRegistrationId) {
        OAuth2AuthorizationRequest authRequest = defaultResolver.resolve(request, clientRegistrationId);
        return customizeWithPkce(authRequest);
    }

    private OAuth2AuthorizationRequest customizeWithPkce(OAuth2AuthorizationRequest authRequest) {
        if (authRequest == null) return null;

        if ("authorization_code".equals(authRequest.getGrantType().getValue())) {
            String codeVerifier = generateCodeVerifier();
            String codeChallenge = createCodeChallenge(codeVerifier);

            return OAuth2AuthorizationRequest.from(authRequest)
                    .additionalParameters(params -> {
                        params.put(PkceParameterNames.CODE_VERIFIER, codeVerifier);
                        params.put(PkceParameterNames.CODE_CHALLENGE, codeChallenge);
                        params.put(PkceParameterNames.CODE_CHALLENGE_METHOD, "S256");
                    })
                    .build();
        }
        return authRequest;
    }

    private String generateCodeVerifier() {
        byte[] code = new byte[32];
        new SecureRandom().nextBytes(code);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(code);
    }

    private String createCodeChallenge(String codeVerifier) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(codeVerifier.getBytes(StandardCharsets.US_ASCII));
            return Base64.getUrlEncoder().withoutPadding().encodeToString(hash);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}