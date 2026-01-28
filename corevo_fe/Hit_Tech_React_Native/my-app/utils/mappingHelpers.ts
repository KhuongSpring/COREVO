/**
 * Mapping Helper Functions
 * Map IDs to Vietnamese display names for muscles and equipment
 */

// Muscle ID mapping (from Flutter mappingTargetMuscle)
const MUSCLE_MAP: Record<number, string> = {
    1: 'Ngực',
    2: 'Lưng',
    3: 'Vai',
    4: 'Tay trước',
    5: 'Tay sau',
    6: 'Bụng',
    7: 'Mông',
    8: 'Đùi trước',
    9: 'Đùi sau',
};

// Equipment ID mapping (from Flutter mappingEquipment)
const EQUIPMENT_MAP: Record<number, string> = {
    1: 'Không cần dụng cụ',
    2: 'Tạ đơn',
    3: 'Tạ đôi',
    4: 'Máy tập',
    5: 'Xà đơn',
    6: 'Xà kép',
    7: 'Thảm tập',
    8: 'Dây kháng lực',
    9: 'Bóng tập',
    10: 'Ghế tập',
};

/**
 * Maps an array of muscle IDs to Vietnamese muscle names
 * @param ids - Array of muscle IDs
 * @returns Array of Vietnamese muscle names
 */
export function mappingTargetMuscleList(ids: number[]): string[] {
    return ids.map(id => MUSCLE_MAP[id] || 'Không xác định').filter(name => name !== 'Không xác định');
}

/**
 * Maps an array of equipment IDs to Vietnamese equipment names
 * @param ids - Array of equipment IDs
 * @returns Array of Vietnamese equipment names
 */
export function mappingEquipmentList(ids: number[]): string[] {
    return ids.map(id => EQUIPMENT_MAP[id] || 'Không xác định').filter(name => name !== 'Không xác định');
}
