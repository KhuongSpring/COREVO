package com.example.corevo.service;

import org.springframework.security.core.userdetails.UserDetails;

import java.util.Date;

public interface JwtService {
    String generateToken(String username);

    String extractUsername(String token);

    Date extractExpiration(String token);

    boolean isTokenValid(String token, UserDetails userDetails);
}
