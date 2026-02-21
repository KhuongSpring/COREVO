package com.example.corevo.domain.dto.response.feed;

import java.util.UUID;

import com.example.corevo.domain.entity.feed.MediaType;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.FieldDefaults;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class PostMediaDto {
    UUID id;

    String mediaUrl;

    MediaType mediaType;

    Integer orderIndex;

}
