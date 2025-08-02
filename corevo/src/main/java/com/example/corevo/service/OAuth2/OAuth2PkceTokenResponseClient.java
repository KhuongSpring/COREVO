package com.example.corevo.service.OAuth2;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.AccessLevel;
import lombok.experimental.FieldDefaults;
import org.springframework.http.*;
import org.springframework.security.oauth2.client.endpoint.OAuth2AccessTokenResponseClient;
import org.springframework.security.oauth2.client.endpoint.OAuth2AuthorizationCodeGrantRequest;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.core.AuthorizationGrantType;
import org.springframework.security.oauth2.core.OAuth2AccessToken;
import org.springframework.security.oauth2.core.endpoint.OAuth2AccessTokenResponse;
import org.springframework.security.oauth2.core.endpoint.OAuth2ParameterNames;
import org.springframework.security.oauth2.core.endpoint.PkceParameterNames;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.util.Base64;
import java.util.Collections;
import java.util.Map;
import java.util.Set;

@Component
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class OAuth2PkceTokenResponseClient implements OAuth2AccessTokenResponseClient<OAuth2AuthorizationCodeGrantRequest> {

    RestTemplate restTemplate;

    public OAuth2PkceTokenResponseClient() {
        this.restTemplate = new RestTemplate();
    }

    @Override
    public OAuth2AccessTokenResponse getTokenResponse(OAuth2AuthorizationCodeGrantRequest authorizationCodeGrantRequest) {

        ClientRegistration clientRegistration = authorizationCodeGrantRequest.getClientRegistration();

        MultiValueMap<String, String> tokenRequestParameters =  createTokenRequestParameters(authorizationCodeGrantRequest);

        HttpHeaders headers = createTokenRequestHeaders(clientRegistration);

        HttpEntity<MultiValueMap<String, String>> httpEntity = new HttpEntity<>(tokenRequestParameters, headers);

        ResponseEntity<Map> response = restTemplate.postForEntity(
                clientRegistration.getProviderDetails().getTokenUri(),
                httpEntity,
                Map.class
        );

        Map<String, Object> tokenResponseParameters = response.getBody();

        return convertToOAuth2AccessTokenResponse(tokenResponseParameters);

    }

    private MultiValueMap<String, String> createTokenRequestParameters(OAuth2AuthorizationCodeGrantRequest authorizationGrantRequest) {

        ClientRegistration clientRegistration = authorizationGrantRequest.getClientRegistration();

        MultiValueMap<String, String> parameters = new LinkedMultiValueMap<>();

        parameters.add(OAuth2ParameterNames.GRANT_TYPE, AuthorizationGrantType.AUTHORIZATION_CODE.getValue());
        parameters.add(OAuth2ParameterNames.CODE, authorizationGrantRequest.getAuthorizationExchange().getAuthorizationResponse().getCode());
        parameters.add(OAuth2ParameterNames.REDIRECT_URI, clientRegistration.getRedirectUri());
        parameters.add(OAuth2ParameterNames.CLIENT_ID, clientRegistration.getClientId());

        String codeVerifier = getCodeVerifierFromSession();

        parameters.add(PkceParameterNames.CODE_VERIFIER, codeVerifier);

        return parameters;
    }

    private String getCodeVerifierFromSession() {
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();

        HttpServletRequest request = attributes.getRequest();
        HttpSession session = request.getSession(false);

        String codeVerifier = (String) session.getAttribute(OAuth2PkceAuthorizationRequestResolver.CODE_VERIFIER_SESSION_KEY);

        return codeVerifier;
    }

    private HttpHeaders createTokenRequestHeaders(ClientRegistration clientRegistration) {
        HttpHeaders headers = new HttpHeaders();

        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));

        String clientCredentials = clientRegistration.getClientId() + ":" + clientRegistration.getClientSecret();
        String base64ClientCredentials = Base64.getEncoder().encodeToString(clientCredentials.getBytes());
        headers.set(HttpHeaders.AUTHORIZATION, "Basic " + base64ClientCredentials);

        return headers;
    }

    private OAuth2AccessTokenResponse convertToOAuth2AccessTokenResponse(Map<String, Object> tokenResponseParameters) {

        String accessTokenValue = (String) tokenResponseParameters.get("access_token");
        String tokenType = (String) tokenResponseParameters.get("token_type");
        String refreshToken = (String) tokenResponseParameters.get("refresh_token");
        String scope = (String) tokenResponseParameters.get("scope");

        Integer expireIn = (Integer) tokenResponseParameters.get("expires_in");

        Set<String> scopes = scope != null ? Set.of(scope.split(" ")) : Collections.emptySet();

        return OAuth2AccessTokenResponse.withToken(accessTokenValue)
                .tokenType(OAuth2AccessToken.TokenType.BEARER)
                .expiresIn(expireIn)
                .scopes(scopes)
                .refreshToken(refreshToken)
                .additionalParameters(tokenResponseParameters)
                .build();
    }
}
