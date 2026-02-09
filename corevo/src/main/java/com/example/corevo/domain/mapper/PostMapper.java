package com.example.corevo.domain.mapper;

import com.example.corevo.domain.dto.request.feed.CreatePostRequestDto;
import com.example.corevo.domain.dto.request.feed.UpdatePostRequestDto;
import com.example.corevo.domain.dto.response.feed.PostMediaDto;
import com.example.corevo.domain.dto.response.feed.PostResponseDto;
import com.example.corevo.domain.dto.response.feed.UserBasicInfoResponseDto;
import com.example.corevo.domain.entity.feed.Post;
import com.example.corevo.domain.entity.feed.PostMedia;
import com.example.corevo.domain.entity.user.User;
import org.mapstruct.*;

import java.util.List;

@Mapper(componentModel = "spring", nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE, nullValueCheckStrategy = NullValueCheckStrategy.ALWAYS)
public interface PostMapper {

    @Mapping(target = "author", source = "user")
    @Mapping(target = "stats", ignore = true)
    @Mapping(target = "isLikedByCurrentUser", ignore = true)
    @Mapping(target = "isDislikedByCurrentUser", ignore = true)
    @Mapping(target = "hashtags", ignore = true)
    @Mapping(target = "mentions", ignore = true)
    PostResponseDto toPostResponseDto(Post post);

    @Mapping(target = "id", expression = "java(user.getId().toString())")
    UserBasicInfoResponseDto toUserBasicInfoResponseDto(User user);

    PostMediaDto toPostMediaDto(PostMedia postMedia);

    List<PostMediaDto> toPostMediaDtoList(List<PostMedia> postMediaList);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "user", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    @Mapping(target = "viewCount", ignore = true)
    @Mapping(target = "isEdited", ignore = true)
    @Mapping(target = "isDeleted", ignore = true)
    @Mapping(target = "deletedAt", ignore = true)
    @Mapping(target = "media", ignore = true)
    @Mapping(target = "likes", ignore = true)
    @Mapping(target = "comments", ignore = true)
    Post toPost(CreatePostRequestDto request);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "user", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    @Mapping(target = "viewCount", ignore = true)
    @Mapping(target = "isEdited", expression = "java(true)")
    @Mapping(target = "isDeleted", ignore = true)
    @Mapping(target = "deletedAt", ignore = true)
    @Mapping(target = "media", ignore = true)
    @Mapping(target = "likes", ignore = true)
    @Mapping(target = "comments", ignore = true)
    void updatePostFromDto(UpdatePostRequestDto request, @MappingTarget Post post);
}
