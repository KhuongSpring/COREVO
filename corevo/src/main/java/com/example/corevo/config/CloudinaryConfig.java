package com.example.corevo.config;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class CloudinaryConfig {
    @Bean
    public Cloudinary cloudinary() {
        return new Cloudinary(ObjectUtils.asMap(
                "cloud_name", "dx0t2c7n5",
                "api_key", "548818698313365",
                "api_secret", "PANC0iR_tP2a6QlmKuGZuUsNocM",
                "secure", true
        ));
    }
}
