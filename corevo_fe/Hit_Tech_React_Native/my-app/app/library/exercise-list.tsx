import React, { useState, useEffect, useRef } from 'react';
import {
    View,
    Text,
    StyleSheet,
    ScrollView,
    TouchableOpacity,
    ImageBackground,
    ActivityIndicator,
    Animated,
    Dimensions,
    Platform,
    StatusBar,
} from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { AppAssets } from '@/constants/AppAssets';
import { trainingService } from '@/services/api/trainingService';
import ExerciseListItem from '@/components/library/ExerciseListItem';
import { generateMuscleDescription } from '@/utils/trainingHelpers';
import type { TrainingExercisePreview } from '@/types/training';
import { AppStrings } from '@/constants/AppStrings';

// ====================================================================
// CONSTANTS & CONFIGURATION
// ====================================================================

const HEADER_HEIGHT = Dims.size280;
const SHEET_OVERLAP = Dims.size32;
const HEADER_MIN_HEIGHT = Dims.size88;

const { height: WINDOW_HEIGHT } = Dimensions.get('window');

// Tạo component Animated cho ImageBackground
const AnimatedImageBackground = Animated.createAnimatedComponent(ImageBackground);

// ====================================================================
// MAIN COMPONENT
// ====================================================================

export default function ExerciseListScreen() {
    const router = useRouter();
    const params = useLocalSearchParams<{ muscle?: string; type?: string; name?: string }>();

    // [ANIMATION] Giá trị theo dõi vị trí cuộn
    const scrollY = useRef(new Animated.Value(0)).current;

    const [exercises, setExercises] = useState<TrainingExercisePreview[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);

    const displayName = params.name || params.muscle || params.type || '';

    useEffect(() => {
        loadExercises();
    }, [params.muscle, params.type]);

    const loadExercises = async () => {
        try {
            setLoading(true);
            setError(null);

            let response;
            if (params.muscle) {
                response = await trainingService.getTrainingExerciseByTargetMuscle(
                    params.muscle, 1, 1000
                );
            } else if (params.type) {
                response = await trainingService.getTrainingExerciseByType(
                    params.type, 1, 1000
                );
            }

            if (response && response.status === 'SUCCESS' && response.data) {
                const allExercises: TrainingExercisePreview[] = [];
                response.data.forEach((level) => {
                    if (level.exercises) {
                        level.exercises.forEach((ex) => {
                            allExercises.push(ex);
                        });
                    }
                });
                setExercises(allExercises);
            } else {
                setError('Không thể tải danh sách bài tập');
            }
        } catch (err) {
            console.error('Error loading exercises:', err);
            setError('Đã xảy ra lỗi khi tải dữ liệu');
        } finally {
            setLoading(false);
        }
    };

    const getBackgroundImage = () => {
        const imageMap: Record<string, any> = {
            'Ngực': AppAssets.targetMuscleChest,
            'Lưng': AppAssets.targetMuscleBack,
            'Vai': AppAssets.targetMuscleShoulders,
            'Tay trước': AppAssets.targetMuscleBicep,
            'Tay sau': AppAssets.targetMuscleTricep,
            'Bụng': AppAssets.targetMuscleAbs,
            'Mông': AppAssets.targetMuscleGlute,
            'Đùi trước': AppAssets.targetMuscleQuad,
            'Đùi sau': AppAssets.targetMuscleHamstring,
            'Cardio': AppAssets.targetMuscleCardio,
            'Yoga': AppAssets.targetMuscleYoga,
            'Calisthenic': AppAssets.targetMuscleCalisthenic,
        };
        return imageMap[displayName] || AppAssets.targetMuscleChest;
    };

    const getBackButtonColor = () => {
        const whiteBackgroundNames = ['Lưng', 'Vai', 'Tay trước', 'Tay sau', 'Bụng', 'Đùi trước', 'Đùi sau', 'Cardio'];
        return whiteBackgroundNames.includes(displayName) ? Colors.wWhite : Colors.dark;
    };

    const handleExercisePress = (exercise: TrainingExercisePreview) => {
        console.log('Exercise pressed:', exercise.name);
    };

    // [ANIMATION CONFIG]
    const headerTranslateY = scrollY.interpolate({
        inputRange: [0, HEADER_HEIGHT],
        outputRange: [0, -HEADER_HEIGHT / 2],
        extrapolate: 'clamp',
    });

    const headerScale = scrollY.interpolate({
        inputRange: [-HEADER_HEIGHT, 0],
        outputRange: [2, 1],
        extrapolate: 'clamp',
    });

    return (
        <View style={styles.container}>
            <StatusBar barStyle="light-content" translucent backgroundColor="transparent" />

            {/* --- 1. BACKGROUND IMAGE (ANIMATED PARALLAX) --- */}
            <AnimatedImageBackground
                source={getBackgroundImage()}
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
            <View style={styles.fixedHeader}>
                <TouchableOpacity
                    style={[
                        styles.backButton,
                        getBackButtonColor() === Colors.wWhite && { backgroundColor: 'rgba(0,0,0,0.2)' }
                    ]}
                    onPress={() => router.back()}
                    activeOpacity={0.7}
                >
                    <Ionicons
                        name="chevron-back"
                        size={Dims.iconSizeXL}
                        color={getBackButtonColor()}
                    />
                </TouchableOpacity>
            </View>

            {/* --- 3. SCROLLABLE CONTENT --- */}
            <Animated.ScrollView
                style={styles.scrollView}
                showsVerticalScrollIndicator={false}
                scrollEventThrottle={16}
                onScroll={Animated.event(
                    [{ nativeEvent: { contentOffset: { y: scrollY } } }],
                    { useNativeDriver: true }
                )}
                contentContainerStyle={{
                    paddingTop: HEADER_HEIGHT - SHEET_OVERLAP,
                }}
            >
                {/* CONTENT SHEET */}
                <View style={styles.contentSheet}>
                    {/* Drag Handle Indicator */}
                    <View style={styles.dragHandleContainer}>
                        <View style={styles.dragHandle} />
                    </View>

                    {/* Title */}
                    <Text style={styles.title}>BÀI TẬP {displayName.toUpperCase()}</Text>

                    {/* Description */}
                    <Text style={styles.description}>
                        {generateMuscleDescription(displayName.toUpperCase())}
                    </Text>

                    {/* Divider */}
                    <View style={styles.divider} />

                    {/* Exercises Section */}
                    <Text style={styles.sectionTitle}>
                        Các bài tập ({exercises.length})
                    </Text>

                    {/* Loading State */}
                    {loading && (
                        <View style={styles.loadingContainer}>
                            <ActivityIndicator size="large" color={Colors.bNormal} />
                        </View>
                    )}

                    {/* Error State */}
                    {error && !loading && (
                        <View style={styles.errorContainer}>
                            <Text style={styles.errorText}>{error}</Text>
                            <TouchableOpacity
                                style={styles.retryButton}
                                onPress={loadExercises}
                            >
                                <Text style={styles.retryButtonText}>Thử lại</Text>
                            </TouchableOpacity>
                        </View>
                    )}

                    {/* Exercise List */}
                    {!loading && !error && exercises.map((exercise) => (
                        <ExerciseListItem
                            key={`${exercise.id}-${exercise.levelName}`}
                            exercise={exercise}
                            onPress={() => handleExercisePress(exercise)}
                        />
                    ))}

                    {/* Empty State */}
                    {!loading && !error && exercises.length === 0 && (
                        <Text style={styles.emptyText}>
                            {AppStrings.noExerciseForThisGroup}
                        </Text>
                    )}

                    <View style={styles.bottomSpacer} />
                </View>
            </Animated.ScrollView>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: Colors.bLight, // Màu nền tối phía sau khi kéo quá đà
    },

    // Ảnh nền (Position Absolute)
    backgroundImage: {
        position: 'absolute',
        top: 0,
        left: 0,
        right: 0,
        width: '100%',
        height: HEADER_HEIGHT,
        zIndex: 0,
    },

    // Header cố định (Nút Back)
    fixedHeader: {
        position: 'absolute',
        top: 0,
        left: 0,
        right: 0,
        zIndex: 100,
        paddingTop: Platform.OS === 'ios' ? 48 : StatusBar.currentHeight,
        paddingHorizontal: Dims.paddingM,
        height: 90,
        justifyContent: 'center', // Căn giữa nút back theo chiều dọc trong vùng an toàn
    },
    backButton: {
        width: 40,
        height: 40,
        borderRadius: 20,
        justifyContent: 'center',
        alignItems: 'center',
    },

    // ScrollView
    scrollView: {
        flex: 1,
        zIndex: 1,
    },

    // Content Sheet (Thẻ trắng chứa nội dung)
    contentSheet: {
        backgroundColor: Colors.wWhite,
        borderTopLeftRadius: 32,
        borderTopRightRadius: 32,
        paddingHorizontal: Dims.paddingL,
        paddingTop: Dims.paddingM,
        minHeight: WINDOW_HEIGHT - HEADER_MIN_HEIGHT, // Đảm bảo kéo lên full màn hình được

        // Shadow
        shadowColor: "#000",
        shadowOffset: { width: 0, height: -3 },
        shadowOpacity: 0.1,
        shadowRadius: 5,
        elevation: 5,
    },

    // Thanh gạch ngang (Drag Handle)
    dragHandleContainer: {
        alignItems: 'center',
        marginBottom: Dims.spacingM,
    },
    dragHandle: {
        width: 48,
        height: 5,
        backgroundColor: Colors.bLightHover,
        borderRadius: 2.5,
    },

    // Các style nội dung (giữ nguyên)
    title: {
        fontSize: Dims.textSizeL,
        fontWeight: 'bold',
        color: Colors.dark,
        marginBottom: Dims.spacingSM,
    },
    description: {
        fontSize: Dims.textSizeS,
        color: Colors.lightActive,
        lineHeight: Dims.textSizeM * 1.5,
        marginBottom: Dims.spacingSM,
    },
    divider: {
        height: 1,
        backgroundColor: Colors.bLightHover, // Màu nhạt hơn chút cho divider
        marginVertical: Dims.spacingSM,
    },
    sectionTitle: {
        fontSize: Dims.textSizeM,
        fontWeight: 'bold',
        color: Colors.dark,
        marginBottom: Dims.spacingSM,
    },
    loadingContainer: {
        paddingVertical: Dims.spacingHuge,
        alignItems: 'center',
    },
    errorContainer: {
        paddingVertical: Dims.spacingHuge,
        alignItems: 'center',
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
    emptyText: {
        fontSize: Dims.textSizeM,
        color: Colors.lightHover,
        textAlign: 'center',
        marginTop: Dims.spacingHuge,
    },
    bottomSpacer: {
        height: Dims.size48,
    },
});