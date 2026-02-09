package com.example.corevo.domain.dto.request.feed;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.FieldDefaults;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class CreateCommentRequestDto {
    @NotBlank(message = "Comment cannot be blank")
    @Size(max = 1000, message = "Comment must not exceed 1000 characters")
    String content;

    String parentCommentId; // Nullable for top-level comments

}
