/**
 * Training Helper Functions
 * Utility functions for mapping and formatting training-related data
 */

/**
 * Map goal from English to Vietnamese
 */
export function mapGoalToVietnamese(goal: string): string {
    const mapping: Record<string, string> = {
        'Lose fat': 'Giảm cân / Giảm mỡ',
        'Gain weight': 'Tăng cân',
        'Gain muscle': 'Tăng cơ',
        'Maintain Body': 'Duy trì vóc dáng',
        'Increase endurance': 'Tăng sức bền',
        'Improve cardiovascular': 'Cải thiện tim mạch',
        'Stress relief/relaxation': 'Giảm stress, thư giãn',
        'Increase height': 'Tăng chiều cao',
    };

    return mapping[goal] || goal;
}

/**
 * Normalize muscle name from Vietnamese to English for API calls
 */
export function normalizeMuscleName(vietnamese: string): string {
    const mapping: Record<string, string> = {
        'Ngực': 'Chest',
        'Lưng': 'Back',
        'Vai': 'Shoulders',
        'Tay trước': 'Biceps',
        'Tay sau': 'Triceps',
        'Bụng': 'Abs',
        'Mông': 'Glutes',
        'Đùi trước': 'Quads',
        'Đùi sau': 'Hamstrings',
        'Cardio': 'Cardio',
        'Yoga': 'Yoga',
        'Calisthenic': 'Calisthenic',
    };

    return mapping[vietnamese] || vietnamese;
}

/**
 * Generate description for muscle/type categories
 */
export function generateMuscleDescription(muscleName: string): string {
    const mapping: Record<string, string> = {
        'NGỰC': 'Không cần bắt đầu với sức mạnh - chỉ cần bắt đầu. Tập ngực là cách đơn giản để xây nền tảng cho một cơ thể khỏe và vững chắc.\nNhóm bài tập này tác động đến ngực trên, giữa và dưới, đồng thời hỗ trợ vai và tay sau. Các bài phổ biến gồm chống đẩy, đẩy tạ, ép ngực và kéo cáp.',
        'LƯNG': 'Sức mạnh đến từ phía sau. Tập lưng giúp cải thiện tư thế và mở rộng vóc dáng toàn diện.\nNhóm bài tập này tác động đến cơ xô, lưng giữa và lưng dưới. Các bài phổ biến gồm kéo xà, deadlift, chèo tạ và kéo cáp.',
        'VAI': 'Một bờ vai vững chãi tạo nên thân hình cân đối và sức mạnh toàn thân.\nNhóm bài tập này tác động đến cơ vai trước, giữa và sau. Gồm đẩy vai, nâng tạ bên, kéo dây và flye.',
        'TAY TRƯỚC': 'Lực kéo mạnh bắt đầu từ tay trước. Biceps không chỉ để đẹp - mà còn để khỏe.\nNhóm bài tập này tác động đến cơ tay trước, gồm các bài như curl tạ, curl dây và chin-up.',
        'TAY SAU': 'Tay sau chiếm phần lớn khối lượng cánh tay - đừng bỏ qua nếu bạn muốn tay săn chắc và khỏe hơn.\nNhóm bài tập này tác động đến triceps với các bài dips, close-grip push-up và pushdown.',
        'BỤNG': 'Cơ bụng khỏe là trung tâm của sự ổn định và chuyển động.\nNhóm bài tập này tác động đến bụng trên, giữa, dưới và cơ xiên. Bao gồm crunch, plank, leg raise và mountain climber.',
        'MÔNG': 'Một cơ mông mạnh không chỉ đẹp mà còn giúp chạy nhanh, nhảy cao và đứng vững.\nNhóm bài tập này tập trung vào cơ mông lớn với các bài như hip thrust, glute bridge và squat.',
        'ĐÙI TRƯỚC': 'Sức mạnh thân dưới bắt đầu từ đùi trước - nhóm cơ chính khi đứng lên, chạy, bật nhảy.\nNhóm bài tập này tác động vào quads với squat, lunge, leg extension và step-up.',
        'ĐÙI SAU': 'Muốn di chuyển linh hoạt và giảm chấn thương? Đừng bỏ qua đùi sau.\nNhóm bài tập này tập trung vào hamstrings với các bài như deadlift, leg curl và glute kickback.',
        'CARDIO': 'Trái tim khỏe là nền tảng cho mọi mục tiêu thể hình.\nNhóm bài tập này giúp cải thiện sức bền và đốt mỡ hiệu quả. Bao gồm chạy bộ, đạp xe, nhảy dây và leo cầu thang.',
        'YOGA': 'Không chỉ là thư giãn - yoga là nghệ thuật kiểm soát hơi thở, cơ thể và tâm trí.\nNhóm bài tập này tập trung vào kéo giãn, giữ thăng bằng và phục hồi thông qua các tư thế và kỹ thuật thở.',
        'CALISTHENIC': 'Sức mạnh thật sự đến từ khả năng làm chủ trọng lượng cơ thể.\nNhóm bài tập này bao gồm chống đẩy, xà đơn, plank, squat và các chuyển động liên hoàn không cần thiết bị.',
    };

    return mapping[muscleName] || muscleName;
}

/**
 * Generate detailed description and aim for training plans
 */
export function generatePlanDescription(planName: string): string {
    const mapping: Record<string, string> = {
        'Fat Burn Express': 'Tập luyện liên tục, đốt năng lượng theo từng nhịp tim.\nMục tiêu:\n1. Đốt cháy mỡ toàn thân hiệu quả.\n2. Tăng nhịp tim – cải thiện sức bền tim mạch.\n3. Giảm cân nhanh nhưng vẫn nhẹ nhàng với khớp.\n4. Phù hợp với người thừa cân nhẹ đến trung bình, ít vận động trước đó.',
        'Shred and Burn': 'Tập gym cường độ cao, đốt mỡ tối đa với máy móc và bài tập kháng lực.\nMục tiêu:\n1. Giảm mỡ nhưng vẫn giữ hoặc tăng nhẹ khối cơ nạc.\n2. Cải thiện hình thể rõ rệt (săn chắc, khỏe mạnh).\n3. Thích hợp cho người muốn giảm mỡ khoa học kết hợp tập tạ.\n4. Cải thiện tốc độ trao đổi chất về lâu dài.',
        'Bodyweigt Burn': 'Dùng trọng lượng cơ thể để xây dựng hành trình đốt mỡ linh hoạt và bền bỉ.\nMục tiêu:\n1. Giảm mỡ thông qua bài tập toàn thân bằng chính trọng lượng cơ thể.\n2. Cải thiện khả năng kiểm soát cơ thể, tư thế, sự linh hoạt.\n3. Phù hợp với người không có dụng cụ, không đến phòng gym.\n4. Giúp cải thiện sức bền và vóc dáng săn chắc.',
        'Muscle Mass Builder': 'Nơi cơ bắp được xây nên bằng thép, kỷ luật và sức bền tại phòng gym.\nMục tiêu:\n1. Tăng khối lượng cơ toàn thân (lean mass).\n2. Cải thiện sức mạnh và kích thước cơ bắp.\n3. Tối ưu hóa hormone tăng trưởng tự nhiên.',
        'Bodyweight Hypertrophy': 'Xây dựng cơ bắp bằng chính trọng lượng cơ thể - kiểm soát, sức mạnh và kỷ luật.\nMục tiêu:\n1. Tăng cơ toàn thân thông qua sức mạnh trọng lượng cơ thể.\n2. Xây dựng thể hình săn chắc, khỏe khoắn.\n3. Cải thiện khả năng kiểm soát cơ thể và sức bền cơ bắp.',
        'Body Control Muscle': 'Làm chủ cơ thể qua từng chuyển động - tăng cơ bằng kiểm soát, độ khó và độ sâu kỹ thuật.\nMục tiêu:\n1. Tăng cơ toàn thân bằng bodyweight.\n2. Phát triển khả năng kiểm soát cơ thể và sức mạnh cơ lõi.\n3. Săn chắc và tạo hình rõ nét.',
        'Lean Muscle Assist': 'Cardio cường độ thấp hỗ trợ tăng cơ, thực hiện vào ngày nghỉ hoặc cuối buổi tập.\nMục tiêu:\n1. Cải thiện lưu thông máu, hỗ trợ phục hồi cơ.\n2. Tăng khả năng tập luyện bền bỉ.\n3. Duy trì nhịp tim ổn định trong quá trình tăng cơ.',
        'Lean and Fit': 'Cân bằng giữa sức mạnh và sự dẻo dai - giữ form săn chắc mà không cần tạ nặng.\nMục tiêu:\n1. Giữ cơ bắp hiện có, không tăng thêm quá nhiều khối lượng.\n2. Duy trì tỷ lệ mỡ – cơ cân đối.\n3. Giữ thói quen vận động và trao đổi chất ổn định.',
        'Steady Fit': 'Nhịp độ ổn định cho vóc dáng bền vững - đi bộ, chạy chậm mà không lo mất cơ.\nMục tiêu:\n1. Duy trì sức khỏe tim mạch và thể lực nền.\n2. Đốt năng lượng vừa đủ để giữ cân.\n3. Tăng cường khả năng trao đổi chất và sức bền.',
        'Balanced Body': 'Cân bằng từ hơi thở đến cơ thể - giữ dáng nhẹ nhàng với yoga định hướng core.\nMục tiêu:\n1. Giữ vóc dáng cân đối qua sự linh hoạt và kiểm soát cơ thể.\n2. Giảm stress, ngủ sâu, cải thiện nội tiết tố.\n3. Tăng tuần hoàn, hỗ trợ tiêu hóa và giữ dáng tự nhiên.',
        'Endurance Engine': 'Mỗi bước chạy là nền móng cho sức bền bền vững.\nMục tiêu:\n1. Tăng sức bền tim mạch (aerobic capacity).\n2. Cải thiện khả năng vận động lâu dài không mệt.\n3. Chuẩn bị thể lực nền cho chạy bộ, đạp xe, thể thao.',
        'Strength-Endurance Hybrid': 'Kết hợp sức mạnh và bền bỉ trong từng set - tập luyện không chỉ nặng mà còn dẻo dai.\nMục tiêu:\n1. Tăng sức bền cơ bắp và khả năng vận động liên tục.\n2. Vừa xây dựng sức mạnh, vừa tăng khả năng lặp lại động tác.\n3. Phù hợp với người chơi thể thao, muốn không đuối sức.',
        'Bodyweight Stamina': 'Sức bền xây dựng từ từng chuyển động liền mạch - tập toàn thân không ngừng nghỉ.\nMục tiêu:\n1. Tăng sức bền toàn thân bằng các bài tập trọng lượng cơ thể.\n2. Cải thiện khả năng kiểm soát hơi thở và nhịp tim khi vận động dài.\n3. Phù hợp cho người không có điều kiện đến phòng tập.',
        'Healthy Heart Routine': 'Nhịp tim khỏe từ từng bước nhỏ - cardio nhẹ nhàng, bền bỉ cho mọi thể trạng.\nMục tiêu:\n1. Tăng hiệu quả bơm máu và nhịp tim.\n2. Giảm huyết áp, cholesterol, kiểm soát cân nặng.\n3. Tăng sức khỏe hệ tuần hoàn và khả năng hô hấp.',
        'Cardio + Strength Circuit': 'Tập đều cả tim và cơ - nhịp tim ổn định, chuyển động không ngừng.\nMục tiêu:\n1. Hỗ trợ hệ tim mạch bằng các bài tập tạ nhẹ kết hợp cardio.\n2. Tăng lưu thông máu, cải thiện nhịp tim khi vận động.\n3. Duy trì tim khỏe mạnh trong khi tập gym.',
        'Hearful Flow': 'Nhịp thở chậm, chuyển động êm - nuôi dưỡng trái tim và sự bình an từ bên trong.\nMục tiêu:\n1. Điều hòa huyết áp, nhịp tim và hô hấp.\n2. Giảm stress – nguyên nhân gây nguy cơ tim mạch.\n3. Tăng lưu thông máu và giảm viêm nội tạng.',
        'Calm and Clarity': 'Chậm lại để lắng nghe - thư giãn thân - tĩnh tâm trí qua từng hơi thở sâu và chuyển động nhẹ.\nMục tiêu:\n1. Giải tỏa căng thẳng tinh thần và cơ thể.\n2. Tăng khả năng kiểm soát cảm xúc và cải thiện chất lượng giấc ngủ.\n3. Kích hoạt hệ thần kinh phó giao cảm (relaxation mode).',
        'Mindful Movement': 'Chuyển động chậm rãi, tâm trí an yên - đi bộ hay đạp xe để thả lỏng và lắng nghe chính mình.\nMục tiêu:\n1. Giải phóng endorphin tự nhiên (hormone hạnh phúc).\n2. Giảm stress và rối loạn lo âu nhẹ.\n3. Kết hợp vận động và hít thở giúp làm dịu hệ thần kinh.',
        'Reset and Recharge': 'Lắc lư, thả lỏng, thở sâu - phục hồi cả thân và tâm qua từng chuyển động đầy chánh niệm.\nMục tiêu:\n1. Giải phóng căng cứng ở cổ, vai, lưng do ngồi lâu / stress.\n2. Duy trì vận động nhẹ nhàng mà không tạo áp lực.\n3. Làm dịu cơ thể và tinh thần.',
        'Height Stretch Flow': 'Mỗi hơi thở giúp bạn vươn dài hơn - kéo giãn nhẹ nhàng cho cơ thể khỏe và cao hơn từng ngày.\nMục tiêu:\n1. Kéo giãn cột sống, làm thẳng tư thế.\n2. Kích thích hormone tăng trưởng (GH) vào buổi sáng hoặc trước khi ngủ.\n3. Tăng độ linh hoạt cột sống, cải thiện postural height.',
        'Jump and Stretch Combo': 'Bật cao hơn, vươn dài hơn - kết hợp vận động và kéo giãn để tối ưu chiều cao.\nMục tiêu:\n1. Kích thích hormone tăng trưởng tự nhiên.\n2. Giãn các sụn ở đầu xương khi chưa đóng.\n3. Tăng nhịp tim nhẹ để thúc đẩy trao đổi chất.',
        'Posture and Core Strength': 'Lưng thẳng - dáng cao. Xây dựng tư thế vững vàng từ bên trong.\nMục tiêu:\n1. Tăng chiều cao thông qua cải thiện tư thế.\n2. Kéo dài cột sống và giữ vai – lưng thẳng.\n3. Cải thiện core để hỗ trợ giữ vóc dáng thẳng.',
    };

    return mapping[planName] || planName;
}
