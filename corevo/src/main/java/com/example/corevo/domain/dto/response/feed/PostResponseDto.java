package com.example.corevo.domain.dto.response.feed;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import com.example.corevo.domain.entity.feed.PostPrivacy;

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
public class PostResponseDto {
    UUID id;

    UserBasicInfoResponseDto author;

    String content;

    PostPrivacy privacy;

    List<PostMediaDto> media;

    PostStatsDto stats;

    Boolean isLikedByCurrentUser;

    Boolean isDislikedByCurrentUser;

    Boolean isEdited;

    LocalDateTime createdAt;

    LocalDateTime updatedAt;

    List<String> hashtags;

    List<UserBasicInfoResponseDto> mentions;

}
