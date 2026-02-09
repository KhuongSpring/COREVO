package com.example.corevo.domain.dto.request.feed;

import java.util.List;
import com.example.corevo.domain.entity.feed.PostPrivacy;

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
public class UpdatePostRequestDto {
    @NotBlank
    @Size(max = 5000)
    String content;

    PostPrivacy privacy;
    List<String> hashtags;
    List<String> mentionedUserIds;

}
