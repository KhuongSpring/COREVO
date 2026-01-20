/**
 * Common Response Types
 * Generic API response wrappers
 * Migrated from Flutter default responses
 */

// Generic success/error response
export interface ApiResponse<T = any> {
    status: 'SUCCESS' | 'ERROR' | 'FAIL';
    message?: string;
    data?: T;
    errors?: Record<string, string[]>;
}

// List response with pagination
export interface ApiListResponse<T = any> {
    status: 'SUCCESS' | 'ERROR' | 'FAIL';
    message?: string;
    data: T[];
    pagination?: {
        currentPage: number;
        totalPages: number;
        pageSize: number;
        totalItems: number;
        hasNext: boolean;
        hasPrevious: boolean;
    };
}

// Pagination request params
export interface PaginationParams {
    page?: number;
    size?: number;
    sort?: string;
    order?: 'asc' | 'desc';
}

// Search/Filter params
export interface SearchParams extends PaginationParams {
    query?: string;
    filters?: Record<string, any>;
}
