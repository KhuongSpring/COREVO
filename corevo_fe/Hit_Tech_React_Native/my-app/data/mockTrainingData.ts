/**
 * Mock Training Data
 * Mock data for testing training screen UI before API integration
 */

import { TrainingSchedule, TrainingProgressStatistic } from '@/types/training';
import { UserProfile } from '@/types/user';

export const mockUserProfile: Partial<UserProfile> = {
    id: '1',
    email: 'user@example.com',
    firstName: 'Văn A',
    lastName: 'Nguyễn',
    trainingPlans: [
        {
            id: 1,
            name: 'Muscle Mass Builder',
            description: 'Nơi cơ bắp được xây nên bằng thép, kỷ luật và sức bền tại phòng gym.',
            aim: 'Tăng khối lượng cơ toàn thân (lean mass). Cải thiện sức mạnh và kích thước cơ bắp.',
            goals: 'Gain muscle',
            type: 'GYM',
            duration: '45',
            frequency: '5',
            levelIds: [2],
            locationIds: [3],
            equipmentIds: [1, 2, 3],
        },
    ],
};

export const mockTrainingSchedules: TrainingSchedule[] = [
    {
        dayOfWeek: 'MONDAY',
        name: 'Ngực - Vai',
        duration: '45 phút',
        location: 'Phòng gym',
        description: 'Tập trung vào ngực trên, giữa và vai',
        exerciseGroups: {
            note: 'Khởi động 5 phút trước khi tập',
            exercises: [
                { exerciseId: 1, duration: '3x10' },
                { exerciseId: 2, duration: '3x12' },
                { exerciseId: 3, duration: '4x8' },
            ],
        },
    },
    {
        dayOfWeek: 'TUESDAY',
        name: 'Lưng - Tay sau',
        duration: '50 phút',
        location: 'Phòng gym',
        description: 'Xây dựng sức mạnh lưng và tay sau',
        exerciseGroups: {
            note: 'Tập trung vào form chuẩn',
            exercises: [
                { exerciseId: 4, duration: '4x8' },
                { exerciseId: 5, duration: '3x10' },
                { exerciseId: 6, duration: '3x12' },
            ],
        },
    },
    {
        dayOfWeek: 'WEDNESDAY',
        name: 'Chân - Mông',
        duration: '55 phút',
        location: 'Phòng gym',
        description: 'Phát triển cơ chân và mông',
        exerciseGroups: {
            note: 'Khởi động kỹ trước khi squat',
            exercises: [
                { exerciseId: 7, duration: '4x10' },
                { exerciseId: 8, duration: '3x12' },
                { exerciseId: 9, duration: '3x15' },
            ],
        },
    },
    {
        dayOfWeek: 'THURSDAY',
        name: 'Ngày nghỉ',
        description: 'Nghỉ ngơi và phục hồi cơ bắp',
    },
    {
        dayOfWeek: 'FRIDAY',
        name: 'Vai - Tay trước',
        duration: '45 phút',
        location: 'Phòng gym',
        description: 'Tập trung vào vai và biceps',
        exerciseGroups: {
            note: 'Giữ form chuẩn để tránh chấn thương',
            exercises: [
                { exerciseId: 10, duration: '4x10' },
                { exerciseId: 11, duration: '3x12' },
                { exerciseId: 12, duration: '3x10' },
            ],
        },
    },
    {
        dayOfWeek: 'SATURDAY',
        name: 'Ngực - Tay sau',
        duration: '50 phút',
        location: 'Phòng gym',
        description: 'Kết hợp ngực và tay sau',
        exerciseGroups: {
            note: 'Tập luyện cường độ cao',
            exercises: [
                { exerciseId: 13, duration: '4x8' },
                { exerciseId: 14, duration: '3x10' },
                { exerciseId: 15, duration: '3x12' },
            ],
        },
    },
    {
        dayOfWeek: 'SUNDAY',
        name: 'Ngày nghỉ',
        description: 'Nghỉ ngơi, hồi phục',
    },
];

export const mockProgressStatistic: TrainingProgressStatistic = {
    month: 'January',
    year: 2026,
    currentMonthCompletions: [
        true, true, true, true, true, true, true, // Week 1
        true, true, true, true, true, true, false, // Week 2
        true, true, true, true, true, false, false, // Week 3
        true, false, false, false, false, false, false, // Week 4 (current week)
        false, false, false, // Remaining days
    ],
    currentStreak: 2,
    longestStreak: 12,
};
