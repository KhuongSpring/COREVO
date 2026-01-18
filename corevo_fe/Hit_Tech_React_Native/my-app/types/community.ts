/**
 * Community/Social Types
 * TypeScript interfaces for social features and feeds
 */

export interface Post {
    id: string;
    userId: string;
    user: {
        id: string;
        fullName: string;
        username: string;
        avatarUrl?: string;
    };
    content: string;
    images?: string[];
    workoutId?: string;
    workout?: {
        name: string;
        duration: number;
        caloriesBurned: number;
    };
    likes: number;
    comments: number;
    isLiked: boolean;
    createdAt: string;
    updatedAt: string;
}

export interface Comment {
    id: string;
    postId: string;
    userId: string;
    user: {
        id: string;
        fullName: string;
        username: string;
        avatarUrl?: string;
    };
    content: string;
    likes: number;
    isLiked: boolean;
    createdAt: string;
}

export interface Follow {
    id: string;
    followerId: string;
    followingId: string;
    createdAt: string;
}

export interface UserProfile {
    id: string;
    fullName: string;
    username: string;
    bio?: string;
    avatarUrl?: string;
    coverUrl?: string;
    followersCount: number;
    followingCount: number;
    postsCount: number;
    isFollowing: boolean;
    isFollower: boolean;
    stats: {
        totalWorkouts: number;
        totalDuration: number;
        currentStreak: number;
    };
}

// API Request/Response Types
export interface CreatePostRequest {
    content: string;
    images?: string[];
    workoutId?: string;
}

export interface CreateCommentRequest {
    postId: string;
    content: string;
}

export interface FeedResponse {
    posts: Post[];
    hasMore: boolean;
    nextCursor?: string;
}
