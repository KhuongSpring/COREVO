import React, { useState, useEffect, useRef } from 'react';
import {
    View,
    Text,
    StyleSheet,
    ScrollView,
    TouchableOpacity,
    ImageBackground,
    ActivityIndicator,
    Alert,
    Animated,
    Platform,
    Dimensions,
    StatusBar,
} from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { AppAssets } from '@/constants/AppAssets';
import { trainingService } from '@/services/api/trainingService';
import ExerciseListItem from '@/components/library/ExerciseListItem';
import CategoryPill from '@/components/library/CategoryPill';
import { mapGoalToVietnamese, generatePlanDescription } from '@/utils/trainingHelpers';
import type { TrainingPlan, TrainingExercisePreview } from '@/types/training';
import { AppStrings } from '@/constants/AppStrings';
import ExerciseDetailModal from '@/components/library/ExerciseDetailModal';

// Chiều cao ảnh Header
const HEADER_HEIGHT = Dims.size304;
// Chiều cao tối thiểu của header (nếu muốn giữ lại thanh toolbar khi cuộn lên)
const HEADER_MIN_HEIGHT = Dims.size88;
// Khoảng cách nội dung đè lên ảnh (để tạo cảm giác card)
const SHEET_OVERLAP = Dims.size28;

// Tạo Animated Component cho ImageBackground để có thể transform
const AnimatedImageBackground = Animated.createAnimatedComponent(ImageBackground);

const { height: WINDOW_HEIGHT } = Dimensions.get('window');

export default function TrainingPlanDetailScreen() {
    const router = useRouter();
    const { id } = useLocalSearchParams<{ id: string }>();

    // [ANIMATION] Giá trị theo dõi vị trí cuộn (Scroll Position)
    const scrollY = useRef(new Animated.Value(0)).current;

    // [STATE] Dữ liệu và trạng thái
    const [plan, setPlan] = useState<TrainingPlan | null>(null);
    const [exercises, setExercises] = useState<TrainingExercisePreview[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [selectedExerciseId, setSelectedExerciseId] = useState<number | null>(null);
    const [modalVisible, setModalVisible] = useState(false);


    // [EFFECT] Load dữ liệu khi vào màn hình
    useEffect(() => {
        loadPlanDetail();
    }, [id]);

    // [LOGIC] Hàm gọi API lấy dữ liệu
    const loadPlanDetail = async () => {
        if (!id) return;

        try {
            setLoading(true);
            setError(null);

            // 1. Lấy thông tin Plan
            const planResponse = await trainingService.getTrainingPlanById(Number(id));
            if (planResponse.status !== 'SUCCESS') {
                throw new Error('Failed to load plan details');
            }
            setPlan(planResponse.data);

            // 2. Lấy lịch trình để biết các bài tập
            const scheduleResponse = await trainingService.getTrainingScheduleById(Number(id));
            if (scheduleResponse.status !== 'SUCCESS') {
                throw new Error('Failed to load plan schedule');
            }

            // 3. Lọc danh sách ID bài tập (Unique)
            const exerciseIds = new Set<number>();
            const exerciseMap = new Map<number, string>(); // Map ID -> Duration/Reps

            scheduleResponse.data.days.forEach((day) => {
                if (day.exerciseGroups?.exercises) {
                    day.exerciseGroups.exercises.forEach((ex) => {
                        exerciseIds.add(ex.exerciseId);
                        exerciseMap.set(ex.exerciseId, ex.duration);
                    });
                }
            });

            // 4. Lấy chi tiết từng bài tập
            const exercisePromises = Array.from(exerciseIds).map(async (exerciseId) => {
                try {
                    const response = await trainingService.getExerciseById(exerciseId);
                    if (response.status === 'SUCCESS' && response.data) {
                        const duration = exerciseMap.get(exerciseId) || '';
                        return {
                            id: exerciseId,
                            name: response.data.name,
                            imageURL: response.data.imageURL,
                            description: response.data.description,
                            levelName: duration, // Hiển thị thời gian/số reps tạm ở đây
                        } as TrainingExercisePreview;
                    }
                } catch (err) {
                    console.error(`Failed to load exercise ${exerciseId}`, err);
                }
                return null;
            });

            const loadedExercises = await Promise.all(exercisePromises);
            setExercises(loadedExercises.filter((ex) => ex !== null) as TrainingExercisePreview[]);

        } catch (err) {
            console.error('Error loading plan details:', err);
            setError('Không thể tải chi tiết kế hoạch');
        } finally {
            setLoading(false);
        }
    };

    // [HELPER] Lấy danh sách category/tags
    const getCategoryLabels = (): string[] => {
        if (!plan) return [];
        const labels: string[] = [];
        labels.push(plan.type);
        const levelMap: { [key: number]: string } = {
            1: 'Mới bắt đầu',
            2: 'Cơ bản',
            3: 'Nâng cao',
        };
        plan.levelIds.forEach((id) => {
            if (levelMap[id]) labels.push(levelMap[id]);
        });
        return labels;
    };

    // [HANDLERS] Các sự kiện bấm nút
    const handleExercisePress = (exercise: TrainingExercisePreview) => {
        setSelectedExerciseId(exercise.id);
        setModalVisible(true);
    };

    const handleCloseModal = () => {
        setModalVisible(false);
        setSelectedExerciseId(null);
    };

    const handleStartPress = () => {
        Alert.alert('Bắt đầu tập luyện', 'Tính năng đang phát triển');
    };

    // [RENDER] Loading State
    if (loading) {
        return (
            <View style={styles.loadingContainer}>
                <ActivityIndicator size="large" color={Colors.bNormal} />
                <Text style={styles.loadingText}>Đang tải...</Text>
            </View>
        );
    }

    // [RENDER] Error State
    if (error || !plan) {
        return (
            <View style={styles.errorContainer}>
                <Text style={styles.errorText}>{error || 'Không tìm thấy kế hoạch'}</Text>
                <TouchableOpacity style={styles.retryButton} onPress={loadPlanDetail}>
                    <Text style={styles.retryButtonText}>{AppStrings.retry}</Text>
                </TouchableOpacity>
            </View>
        );
    }

    // [ANIMATION CONFIG]
    // 1. Parallax: Ảnh di chuyển chậm hơn nội dung (chia 2 tốc độ)
    const headerTranslateY = scrollY.interpolate({
        inputRange: [0, HEADER_HEIGHT],
        outputRange: [0, -HEADER_HEIGHT / 2],
        extrapolate: 'clamp',
    });

    // 2. Zoom: Khi kéo xuống (giá trị âm), ảnh phóng to ra
    const headerScale = scrollY.interpolate({
        inputRange: [-HEADER_HEIGHT, 0],
        outputRange: [2, 1],
        extrapolate: 'clamp',
    });

    return (
        <View style={styles.container}>
            <StatusBar barStyle="light-content" translucent backgroundColor="transparent" />

            {/* --- 1. BACKGROUND IMAGE (ANIMATED) --- */}
            {/* Nằm dưới cùng (zIndex thấp), thay đổi vị trí và scale theo scrollY */}
            <AnimatedImageBackground
                source={AppAssets.trainingPlan1} // Có thể thay bằng ảnh động từ API nếu có
                style={[
                    styles.backgroundImage,
                    {
                        transform: [
                            { translateY: headerTranslateY },
                            { scale: headerScale }
                        ]
                    }
                ]}
                resizeMode="cover"
            />

            {/* --- 2. FIXED HEADER (BACK BUTTON) --- */}
            {/* Nằm trên cùng, luôn cố định */}
            <View style={styles.fixedHeader}>
                <TouchableOpacity style={styles.backButton} onPress={() => router.back()}>
                    <Ionicons name="chevron-back" size={Dims.iconSizeXL} color={Colors.dark} />
                </TouchableOpacity>
            </View>

            {/* --- 3. SCROLLABLE CONTENT --- */}
            <Animated.ScrollView
                style={styles.scrollView}
                showsVerticalScrollIndicator={false}
                scrollEventThrottle={16} // Tối ưu hiệu năng animation (16ms = 60fps)
                onScroll={Animated.event(
                    [{ nativeEvent: { contentOffset: { y: scrollY } } }],
                    { useNativeDriver: true }
                )}
                // PaddingTop quan trọng: Đẩy nội dung xuống dưới để lộ ảnh nền
                contentContainerStyle={{
                    paddingTop: HEADER_HEIGHT - SHEET_OVERLAP,
                    paddingBottom: Dims.size104, // Chừa chỗ cho nút Start
                }}
            >
                {/* CONTENT SHEET: Phần nền trắng chứa thông tin */}
                <View style={styles.contentSheet}>
                    {/* Drag Handle (Thanh gạch ngang trang trí) */}
                    <View style={styles.dragHandleContainer}>
                        <View style={styles.dragHandle} />
                    </View>

                    {/* Plan Info */}
                    <Text style={styles.title}>
                        {mapGoalToVietnamese(plan.goals)} - {plan.name}
                    </Text>

                    <Text style={styles.description}>
                        {generatePlanDescription(plan.name)}
                    </Text>

                    {/* Categories Pills */}
                    <View style={styles.categoriesContainer}>
                        <ScrollView
                            horizontal
                            showsHorizontalScrollIndicator={false}
                            contentContainerStyle={styles.categoriesContent}
                        >
                            {getCategoryLabels().map((label, index) => (
                                <View key={index} style={styles.categoryPillWrapper}>
                                    <CategoryPill label={label} />
                                </View>
                            ))}
                        </ScrollView>
                    </View>

                    <View style={styles.divider} />

                    {/* Exercise List */}
                    <Text style={styles.sectionTitle}>
                        Các bài tập ({exercises.length})
                    </Text>

                    {exercises.map((exercise) => (
                        <ExerciseListItem
                            key={exercise.id}
                            exercise={exercise}
                            onPress={() => handleExercisePress(exercise)}
                        />
                    ))}

                    {/* Spacer bottom để không bị cấn nút Start */}
                    <View style={{ height: Dims.size24 }} />
                </View>
            </Animated.ScrollView>

            {/* --- 4. FIXED BOTTOM BUTTON --- */}
            <View style={styles.buttonContainer}>
                <TouchableOpacity style={styles.startButton} onPress={handleStartPress}>
                    <Text style={styles.startButtonText}>{AppStrings.startNow}</Text>
                </TouchableOpacity>
            </View>

            {/* --- 5. EXERCISE DETAIL MODAL --- */}
            <ExerciseDetailModal
                visible={modalVisible}
                exerciseId={selectedExerciseId}
                onClose={handleCloseModal}
            />
        </View>
    );
}


const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: Colors.bLight, // Màu nền đen/tối phía sau ScrollView
    },

    // Ảnh nền Parallax
    backgroundImage: {
        position: 'absolute',
        top: 0,
        left: 0,
        right: 0,
        width: '100%',
        height: HEADER_HEIGHT,
        zIndex: 0, // Nằm dưới
    },

    // Header cố định (Nút Back)
    fixedHeader: {
        position: 'absolute',
        top: 0,
        left: 0,
        right: 0,
        zIndex: 100, // Nằm trên cùng
        paddingTop: Platform.OS === 'ios' ? 44 : StatusBar.currentHeight, // Safe Area
        paddingHorizontal: Dims.paddingM,
        height: 90,
        justifyContent: 'center',
    },
    backButton: {
        width: 44,
        height: 44,
        borderRadius: 22,
        justifyContent: 'center',
        alignItems: 'center',
    },

    // ScrollView
    scrollView: {
        flex: 1,
        zIndex: 1,
    },

    // Content Sheet (Phần thẻ trắng)
    contentSheet: {
        backgroundColor: Colors.wWhite,
        borderTopLeftRadius: 32, // Bo góc tròn trịa
        borderTopRightRadius: 32,
        paddingHorizontal: Dims.paddingL,
        paddingTop: Dims.paddingM,
        // Min height đảm bảo kéo lên full màn hình được
        minHeight: WINDOW_HEIGHT - HEADER_MIN_HEIGHT,

        // Shadow Effect
        shadowColor: "#000",
        shadowOffset: { width: 0, height: -4 },
        shadowOpacity: 0.1,
        shadowRadius: 8,
        elevation: 10,
    },

    // Drag Handle (Thanh trang trí)
    dragHandleContainer: {
        alignItems: 'center',
        marginBottom: Dims.spacingM,
    },
    dragHandle: {
        width: 48,
        height: 5,
        backgroundColor: Colors.bLightHover,
        borderRadius: 3,
    },

    // Text Styles
    title: {
        fontSize: Dims.textSizeXL,
        fontWeight: 'bold',
        color: Colors.dark,
        marginBottom: Dims.spacingS,
    },
    description: {
        fontSize: Dims.textSizeS,
        color: Colors.lightActive, // Màu xám nhẹ hơn cho description
        lineHeight: 22,
        marginBottom: Dims.spacingM,
    },

    // Categories
    categoriesContainer: {
        marginBottom: Dims.spacingM,
    },
    categoriesContent: {
        paddingRight: Dims.paddingM,
    },
    categoryPillWrapper: {
        marginRight: Dims.paddingS,
    },

    divider: {
        height: 1,
        backgroundColor: Colors.bLightHover,
        marginVertical: Dims.spacingM,
    },

    sectionTitle: {
        fontSize: Dims.textSizeL,
        fontWeight: 'bold',
        color: Colors.dark,
        marginBottom: Dims.spacingM,
    },

    // Loading & Error
    loadingContainer: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: Colors.wWhite,
    },
    loadingText: {
        marginTop: Dims.spacingM,
        fontSize: Dims.textSizeM,
        color: Colors.dark,
    },
    errorContainer: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        padding: Dims.paddingL,
        backgroundColor: Colors.wWhite,
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

    // Bottom Button
    buttonContainer: {
        position: 'absolute',
        bottom: 0,
        left: 0,
        right: 0,
        backgroundColor: Colors.wWhite,
        padding: Dims.paddingM,
        paddingBottom: Platform.OS === 'ios' ? 34 : Dims.paddingM, // Safe area bottom
        borderTopWidth: 1,
        borderTopColor: Colors.bLightHover,
        zIndex: 200, // Cao nhất
    },
    startButton: {
        backgroundColor: Colors.bNormal,
        height: 56,
        borderRadius: Dims.borderRadiusLarge,
        justifyContent: 'center',
        alignItems: 'center',
        // Shadow cho nút
        shadowColor: Colors.bNormal,
        shadowOffset: { width: 0, height: 4 },
        shadowOpacity: 0.3,
        shadowRadius: 8,
        elevation: 4,
    },
    startButtonText: {
        fontSize: Dims.textSizeM,
        color: Colors.wWhite,
        fontWeight: 'bold',
        textTransform: 'uppercase',
    },
});