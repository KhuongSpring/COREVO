package com.example.corevo.domain.dto.request.feed;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.example.corevo.domain.entity.feed.PostPrivacy;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
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
public class CreatePostRequestDto {
    @NotBlank(message = "Content cannot be blank")
    @Size(max = 5000, message = "Content must not exceed 5000 characters")
    String content;

    @NotNull(message = "Privacy setting is required")
    PostPrivacy privacy;

    List<String> hashtags;
    List<String> mentionedUserIds;
    List<MultipartFile> mediaFiles;
}
