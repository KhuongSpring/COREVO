package com.example.corevo;

import org.springframework.core.env.Environment;
import org.springframework.data.redis.repository.configuration.EnableRedisRepositories;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.time.LocalDate;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;

import com.example.corevo.domain.entity.user.User;
import com.example.corevo.domain.entity.user.Role;

import com.example.corevo.config.UserInfoProperties;
import com.example.corevo.repository.UserRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Log4j2
@RequiredArgsConstructor
@EnableConfigurationProperties(UserInfoProperties.class)
@SpringBootApplication(scanBasePackages = "com.example.corevo")
public class CorevoApplication {

	private final UserRepository userRepository;

	public static void main(String[] args) {
		Environment env = SpringApplication.run(CorevoApplication.class, args).getEnvironment();
		String appName = env.getProperty("spring.application.name");
		if (appName != null) {
			appName = appName.toUpperCase();
		}
		String port = env.getProperty("server.port");
		log.info("-------------------------START " + appName
				+ " Application------------------------------");
		log.info("   Application         : " + appName);
		log.info("   Url swagger-ui      : http://localhost:" + port + "/swagger-ui.html");
		log.info("-------------------------START SUCCESS " + appName
				+ " Application------------------------------");
	}

	@Bean
	CommandLineRunner init(UserInfoProperties userInfo, PasswordEncoder passwordEncoder) {
		return arg -> {
			// init account admin
			if (userRepository.count() == 0) {
				User admin = User.builder()
						.username(userInfo.getUsername())
						.password(passwordEncoder.encode(userInfo.getPassword()))
						.email(userInfo.getEmail())
						.firstName(userInfo.getFirstName())
						.lastName(userInfo.getLastName())
						.phone(userInfo.getPhone())
						.nationality(userInfo.getNationality())
						.birth(userInfo.getBirth())
						.createdAt(LocalDate.now())
						.isLocked(false)
						.role(Role.ADMIN)
						.build();
				userRepository.save(admin);
				log.info("Admin user created successfully: {}", userInfo.getUsername());
			} else {
				log.info("Admin user already exists");
			}
		};
	}

}
