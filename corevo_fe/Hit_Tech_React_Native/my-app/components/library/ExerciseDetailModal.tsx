import React, { useState, useEffect, useRef } from 'react';
import {
    View,
    Text,
    StyleSheet,
    Modal,
    ScrollView,
    TouchableOpacity,
    Image,
    ActivityIndicator,
    Dimensions,
    Animated,
    PanResponder,
} from 'react-native';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { AppStrings } from '@/constants/AppStrings';
import { trainingService } from '@/services/api/trainingService';
import { mappingTargetMuscleList, mappingEquipmentList } from '@/utils/mappingHelpers';
import type { TrainingExercise } from '@/types/training';

// Lấy kích thước màn hình
const { width: SCREEN_WIDTH, height: SCREEN_HEIGHT } = Dimensions.get('window');

// Cấu hình chiều cao Modal (85% màn hình)
const MODAL_HEIGHT = SCREEN_HEIGHT * 0.85;
// Ngưỡng kéo xuống để đóng (kéo quá 30% chiều cao modal thì đóng)
const DISMISS_THRESHOLD = MODAL_HEIGHT * 0.3;

interface ExerciseDetailModalProps {
    visible: boolean;
    exerciseId: number | null;
    onClose: () => void;
}

export default function ExerciseDetailModal({ visible, exerciseId, onClose }: ExerciseDetailModalProps) {
    const [exercise, setExercise] = useState<TrainingExercise | null>(null);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);

    // [ANIMATION] Giá trị Y để kéo modal
    const panY = useRef(new Animated.Value(0)).current;

    // [EFFECT] Reset vị trí khi mở modal và load dữ liệu
    useEffect(() => {
        if (visible) {
            panY.setValue(0); // Reset vị trí về 0 mỗi khi mở
            if (exerciseId) {
                loadExerciseDetails();
            }
        }
    }, [visible, exerciseId]);

    // [LOGIC] PanResponder để xử lý kéo thả
    const panResponder = useRef(
        PanResponder.create({
            onStartShouldSetPanResponder: () => true,
            onMoveShouldSetPanResponder: (_, gestureState) => {
                // Chỉ bắt sự kiện khi người dùng kéo xuống (dy > 0)
                return gestureState.dy > 0;
            },
            onPanResponderMove: (_, gestureState) => {
                // Chỉ cho phép kéo xuống (không cho kéo lên quá top -> dy > 0)
                if (gestureState.dy > 0) {
                    panY.setValue(gestureState.dy);
                }
            },
            onPanResponderRelease: (_, gestureState) => {
                // Nếu kéo quá ngưỡng hoặc vuốt nhanh (velocity > 0.5) -> Đóng modal
                if (gestureState.dy > DISMISS_THRESHOLD || gestureState.vy > 0.5) {
                    closeModalWithAnimation();
                } else {
                    // Nếu chưa đủ ngưỡng -> Bật ngược lại vị trí cũ (Spring)
                    Animated.spring(panY, {
                        toValue: 0,
                        useNativeDriver: true,
                        bounciness: 5,
                    }).start();
                }
            },
        })
    ).current;

    // Hàm đóng modal có animation trượt xuống
    const closeModalWithAnimation = () => {
        Animated.timing(panY, {
            toValue: SCREEN_HEIGHT, // Trượt hẳn xuống dưới màn hình
            duration: 200,
            useNativeDriver: true,
        }).start(() => onClose());
    };

    const loadExerciseDetails = async () => {
        if (!exerciseId) return;

        try {
            setLoading(true);
            setError(null);

            const response = await trainingService.getExerciseById(exerciseId);

            if (response.status === 'SUCCESS' && response.data) {
                setExercise(response.data);
            } else {
                setError('Không thể tải thông tin bài tập');
            }
        } catch (err) {
            console.error('Error loading exercise details:', err);
            setError('Đã xảy ra lỗi khi tải dữ liệu');
        } finally {
            setLoading(false);
        }
    };

    const getSetsRepsText = () => {
        if (!exercise) return '';

        const minSet = exercise.minSet || 0;
        const maxSet = exercise.maxSet || 0;
        const setsText = minSet === maxSet ? `${minSet}` : `${minSet} - ${maxSet}`;

        const min = exercise.minRep === 0 ? `${exercise.minDuration}` : `${exercise.minRep}`;
        const max = exercise.maxRep === 0
            ? `${exercise.maxDuration} ${AppStrings.secs}`
            : `${exercise.maxRep} ${AppStrings.reps}`;

        return `${setsText} ${AppStrings.sets} | ${min} - ${max}`;
    };

    const renderCategoryChip = (label: string, isPrimary: boolean = false) => (
        <View
            key={label}
            style={[
                styles.chip,
                isPrimary ? styles.chipPrimary : styles.chipSecondary,
            ]}
        >
            <Text
                style={[
                    styles.chipText,
                    isPrimary ? styles.chipTextPrimary : styles.chipTextSecondary,
                ]}
            >
                {label}
            </Text>
        </View>
    );

    return (
        <Modal
            visible={visible}
            animationType="slide"
            transparent={true}
            onRequestClose={onClose}
        >
            <View style={styles.overlay}>
                {/* Backdrop: Vùng tối bấm vào để đóng */}
                <TouchableOpacity
                    style={styles.backdrop}
                    activeOpacity={1}
                    onPress={closeModalWithAnimation}
                />

                {/* Container chính của Modal (Animated) */}
                <Animated.View
                    style={[
                        styles.container,
                        { transform: [{ translateY: panY }] }
                    ]}
                >
                    {/* Khu vực Header nhận sự kiện vuốt (PanResponder) */}
                    <View {...panResponder.panHandlers} style={styles.headerDraggableArea}>
                        <View style={styles.dragHandle} />
                    </View>

                    {/* Nội dung Modal */}
                    {loading ? (
                        <View style={styles.loadingContainer}>
                            <ActivityIndicator size="large" color={Colors.bNormal} />
                        </View>
                    ) : error ? (
                        <View style={styles.errorContainer}>
                            <Text style={styles.errorText}>{error}</Text>
                            <TouchableOpacity style={styles.retryButton} onPress={loadExerciseDetails}>
                                <Text style={styles.retryButtonText}>{AppStrings.retry}</Text>
                            </TouchableOpacity>
                        </View>
                    ) : exercise ? (
                        <>
                            <ScrollView
                                style={styles.scrollView}
                                contentContainerStyle={styles.scrollContent}
                                showsVerticalScrollIndicator={false}
                            >
                                {/* Tên bài tập */}
                                <Text style={styles.exerciseName}>{exercise.name}</Text>

                                {/* Ảnh minh họa */}
                                <View style={styles.imageContainer}>
                                    <Image
                                        source={{ uri: exercise.imageURL }}
                                        style={styles.exerciseImage}
                                        resizeMode="contain"
                                    />
                                </View>

                                {/* Badge Sets/Reps */}
                                <View style={styles.badgeContainer}>
                                    <View style={styles.badge}>
                                        <Text style={styles.badgeText}>{getSetsRepsText()}</Text>
                                    </View>
                                </View>

                                {/* Giới thiệu */}
                                <Text style={styles.sectionTitle}>{AppStrings.introduction}</Text>
                                <Text style={styles.description}>{exercise.description}</Text>

                                {/* Nhóm cơ */}
                                <Text style={styles.sectionTitle}>{AppStrings.targetMuscles}</Text>
                                <ScrollView
                                    horizontal
                                    showsHorizontalScrollIndicator={false}
                                    style={styles.chipScrollView}
                                >
                                    {mappingTargetMuscleList(exercise.primaryMuscleIds).map((muscle) =>
                                        renderCategoryChip(muscle, true)
                                    )}
                                    {mappingTargetMuscleList(exercise.secondaryMuscleIds).map((muscle) =>
                                        renderCategoryChip(muscle, false)
                                    )}
                                </ScrollView>

                                {/* Thiết bị */}
                                <Text style={styles.sectionTitle}>{AppStrings.equipment}</Text>
                                <ScrollView
                                    horizontal
                                    showsHorizontalScrollIndicator={false}
                                    style={styles.chipScrollView}
                                >
                                    {mappingEquipmentList(exercise.equipmentIds).map((equipment) =>
                                        renderCategoryChip(equipment, false)
                                    )}
                                </ScrollView>

                            </ScrollView>

                            {/* Nút đóng */}
                            <View style={styles.buttonContainer}>
                                <TouchableOpacity style={styles.closeButton} onPress={closeModalWithAnimation}>
                                    <Text style={styles.closeButtonText}>{AppStrings.close}</Text>
                                </TouchableOpacity>
                            </View>
                        </>
                    ) : null}
                </Animated.View>
            </View>
        </Modal>
    );
}

const styles = StyleSheet.create({
    overlay: {
        flex: 1,
        justifyContent: 'flex-end',
    },
    backdrop: {
        ...StyleSheet.absoluteFillObject, // Phủ kín màn hình
        backgroundColor: 'rgba(0, 0, 0, 0.5)',
    },
    container: {
        backgroundColor: Colors.wWhite,
        borderTopLeftRadius: Dims.borderRadiusLarge,
        borderTopRightRadius: Dims.borderRadiusLarge,
        height: MODAL_HEIGHT, // Chiều cao cố định 85%
        width: '100%',
        paddingBottom: Dims.paddingM,
        // Shadow effect
        shadowColor: '#000',
        shadowOffset: { width: 0, height: -2 },
        shadowOpacity: 0.25,
        shadowRadius: 10,
        elevation: 10,
    },
    headerDraggableArea: {
        width: '100%',
        height: 40,
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: 'transparent',
    },
    dragHandle: {
        width: 48,
        height: 5,
        backgroundColor: Colors.lightHover, // Màu xám nhạt
        borderRadius: 3,
    },
    scrollView: {
        flex: 1,
        paddingHorizontal: Dims.paddingL,
    },
    scrollContent: {
        paddingBottom: Dims.size48,
    },
    loadingContainer: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
    },
    errorContainer: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        paddingHorizontal: Dims.paddingL,
    },
    errorText: {
        fontSize: Dims.textSizeM,
        color: Colors.dark,
        textAlign: 'center',
        marginBottom: Dims.spacingL,
    },
    retryButton: {
        backgroundColor: Colors.bNormal,
        paddingHorizontal: Dims.paddingL,
        paddingVertical: Dims.paddingM,
        borderRadius: Dims.borderRadiusSmall,
    },
    retryButtonText: {
        color: Colors.wWhite,
        fontSize: Dims.textSizeM,
        fontWeight: '600',
    },
    exerciseName: {
        fontSize: Dims.textSizeXL,
        fontWeight: 'bold',
        color: Colors.dark,
        marginBottom: Dims.spacingL,
    },
    imageContainer: {
        alignItems: 'center',
        marginBottom: Dims.spacingM,
    },
    exerciseImage: {
        width: '100%',
        height: 220,
        borderRadius: Dims.borderRadius,
        borderWidth: 1,
        borderColor: Colors.bLightHover,
        backgroundColor: Colors.wWhite,
    },
    badgeContainer: {
        alignItems: 'flex-end',
    },
    badge: {
        backgroundColor: Colors.bNormal,
        paddingHorizontal: Dims.paddingM,
        paddingVertical: Dims.paddingS,
        borderRadius: Dims.borderRadiusTiny,
    },
    badgeText: {
        fontSize: Dims.textSizeS,
        color: Colors.wWhite,
        fontWeight: '500',
    },
    sectionTitle: {
        fontSize: Dims.textSizeM,
        fontWeight: 'bold',
        color: Colors.bNormal,
        marginBottom: Dims.spacingSM,
        marginTop: Dims.spacingM,
    },
    description: {
        fontSize: Dims.textSizeS,
        color: Colors.dark,
        lineHeight: Dims.textSizeS * 1.6,
    },
    chipScrollView: {
        marginBottom: Dims.spacingM,
    },
    chip: {
        height: 36,
        paddingHorizontal: Dims.paddingM,
        marginRight: Dims.paddingS,
        borderRadius: Dims.borderRadiusSmall,
        justifyContent: 'center',
        alignItems: 'center',
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 1 },
        shadowOpacity: 0.1,
        shadowRadius: 2,
        elevation: 1,
    },
    chipPrimary: {
        backgroundColor: Colors.bNormal,
    },
    chipSecondary: {
        backgroundColor: Colors.wLightActive,
    },
    chipText: {
        fontSize: 13,
        fontWeight: '600',
    },
    chipTextPrimary: {
        color: Colors.wWhite,
    },
    chipTextSecondary: {
        color: Colors.dark,
    },
    bottomSpacer: {
        height: Dims.size40,
    },
    buttonContainer: {
        padding: Dims.paddingM,
        borderTopWidth: 1,
        borderTopColor: Colors.bLightHover,
    },
    closeButton: {
        backgroundColor: Colors.bNormal,
        paddingVertical: Dims.paddingM,
        borderRadius: Dims.borderRadiusLarge,
        alignItems: 'center',
    },
    closeButtonText: {
        color: Colors.wWhite,
        fontSize: Dims.textSizeL,
        fontWeight: '500',
    },
});