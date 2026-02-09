package com.example.corevo.domain.dto.response.feed;

import java.time.LocalDateTime;
import java.util.List;

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
public class CommentResponseDto {
    String id;

    UserBasicInfoResponseDto author;

    String content;

    Integer likeCount;

    Boolean isLikedByCurrentUser;

    Boolean isEdited;

    LocalDateTime createdAt;

    LocalDateTime updatedAt;

    Integer replyCount;

    List<CommentResponseDto> replies;

}
