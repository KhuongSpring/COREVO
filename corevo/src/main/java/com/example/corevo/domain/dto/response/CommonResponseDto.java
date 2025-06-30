package com.example.corevo.domain.dto.response;

import lombok.*;
import org.springframework.http.HttpStatus;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@Builder
public class CommonResponseDto {

    private HttpStatus status;

    private String message;

}
