package com.example.corevo.service.OAuth2;

import com.example.corevo.domain.entity.user.Role;
import com.example.corevo.domain.entity.user.User;
import com.example.corevo.repository.UserRepository;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.log4j.Log4j2;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Collections;
import java.util.UUID;

@Log4j2
@Service
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    UserRepository userRepository;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest)
            throws OAuth2AuthenticationException {

        OAuth2User oAuth2User = super.loadUser(userRequest);

        String email = oAuth2User.getAttribute("email");
        String name = oAuth2User.getAttribute("name");
        String avatar = oAuth2User.getAttribute("picture");
        String firstName = oAuth2User.getAttribute("given_name");
        String lastName = oAuth2User.getAttribute("family_name");

        User user = findOrCreateUser(email, name, avatar, firstName, lastName);

        return new DefaultOAuth2User(
                Collections.singleton(new SimpleGrantedAuthority("ROLE_" + user.getRole().name())),
                oAuth2User.getAttributes(),
                "email"
        );
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
