package com.example.corevo.service.impl;

import com.example.corevo.constant.RoleConstant;
import com.example.corevo.exception.InternalServerException;
import com.example.corevo.service.JwtService;
import com.example.corevo.service.UserService;
import com.nimbusds.jose.JOSEException;
import com.nimbusds.jose.JWSAlgorithm;
import com.nimbusds.jose.JWSHeader;
import com.nimbusds.jose.crypto.MACSigner;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import lombok.AccessLevel;
import lombok.Data;
import lombok.experimental.FieldDefaults;
import lombok.experimental.NonFinal;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import java.security.Key;
import java.util.Date;
import java.util.List;
import java.util.function.Function;

@Service
@Data
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class JwtServiceImpl implements JwtService {

    // UserService userService;

    @NonFinal
    @Value("${jwt.secret}")
    String secretKey;

    @NonFinal
    @Value("${jwt.access.expiration_time}")
    long EXPIRATION;

    // public JwtServiceImpl(UserService userService) {
    //     this.userService = userService;
    // }

    @Override
    public String generateToken(String username) {
        try {
            JWTClaimsSet claimsSet = new JWTClaimsSet.Builder()
                    .subject(username)
                    .issueTime(new Date())
                    .expirationTime(new Date(System.currentTimeMillis() + EXPIRATION))
                    .claim("authorities", List.of(RoleConstant.USER))
                    .build();

            SignedJWT signedJWT = new SignedJWT(
                    new JWSHeader(JWSAlgorithm.HS512),
                    claimsSet
            );

            signedJWT.sign(new MACSigner(secretKey.getBytes()));

            return signedJWT.serialize();

        } catch (JOSEException e) {
            throw new InternalServerException("Error while signing JWT");
        }
    }

    private Key getSignInKey() {
        return Keys.hmacShaKeyFor(secretKey.getBytes());
    }

    @Override
    public String extractUsername(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    @Override
    public Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }

    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    @Override
    public boolean isTokenValid(String token, UserDetails userDetails) {
        final String username = extractUsername(token);
        return (username.equals(userDetails.getUsername())) && !isTokenExpired(token);
    }

    private boolean isTokenExpired(String token) {
        return extractExpiration(token).before(new Date());
    }

    private Claims extractAllClaims(String token) {
        return Jwts
                .parserBuilder()
                .setSigningKey(getSignInKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
    }
}