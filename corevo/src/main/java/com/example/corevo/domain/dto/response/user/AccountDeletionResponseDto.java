package com.example.corevo.domain.dto.response.user;


import com.example.corevo.domain.dto.response.CommonResponseDto;
import lombok.*;
import lombok.experimental.FieldDefaults;
import org.springframework.http.HttpStatus;


@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class AccountDeletionResponseDto extends CommonResponseDto {
    String userEmail;
    Integer gracePeriodDays;
    String supportContact;

    public AccountDeletionResponseDto(HttpStatus status, String message, String userEmail,
                                      Integer gracePeriodDays, String supportContact) {
        super(status, message);
        this.userEmail = userEmail;
        this.gracePeriodDays = gracePeriodDays;
        this.supportContact = supportContact;
    }
}
