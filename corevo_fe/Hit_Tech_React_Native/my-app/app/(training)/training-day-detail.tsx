import React, { useState, useEffect, useRef } from 'react';
import {
    View,
    Text,
    StyleSheet,
    ScrollView,
    TouchableOpacity,
    Image,
    ActivityIndicator,
    Switch,
    Animated,
    Dimensions,
    Platform,
    StatusBar,
} from 'react-native';
import { router, useLocalSearchParams } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { AppAssets } from '@/constants/AppAssets';
import { AppStrings } from '@/constants/AppStrings';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { trainingService } from '@/services/api/trainingService';
import { getTrainingDayImages } from '@/utils/trainingImageHelper';
import ExerciseDetailModal from '@/components/library/ExerciseDetailModal';
import type { TrainingSchedule, TrainingExercisePreview } from '@/types/training';

// ====================================================================
// CONSTANTS & CONFIGURATION
// ====================================================================

const HEADER_HEIGHT = Dims.size280;
const SHEET_OVERLAP = Dims.size32;
const HEADER_MIN_HEIGHT = Dims.size88;

const { height: WINDOW_HEIGHT } = Dimensions.get('window');

// Create Animated component for ImageBackground
const AnimatedImageBackground = Animated.createAnimatedComponent(require('react-native').ImageBackground);

// ====================================================================
// HELPER FUNCTIONS
// ====================================================================

const normalizeLocation = (location?: string): string => {
    if (!location) return 'Mọi nơi';
    // Add location normalization logic if needed
    return location;
};

const parseSetInfo = (duration: string): { sets: string; repsPerSet?: string; durationPerSet?: string } => {
    const parts = duration.split('X');
    if (parts.length < 2) {
        return { sets: '1', repsPerSet: duration };
    }

    const sets = parts[0].trim();
    const value = parts[1].trim().toLowerCase();

    // Check if it's time-based (contains 'sec' or 's')
    if (value.includes('sec') || value.includes('s')) {
        return { sets, durationPerSet: value };
    }

    return { sets, repsPerSet: value };
};

// ====================================================================
// MAIN COMPONENT
// ====================================================================

export default function TrainingDayDetailScreen() {
    const params = useLocalSearchParams();

    // Parse params
    const scheduleData: TrainingSchedule = params.schedule ? JSON.parse(params.schedule as string) : null;
    const numberDay: string = params.numberDay as string || '';
    const dayIndex: number = params.dayIndex ? parseInt(params.dayIndex as string) : 0;
    const planName: string = params.planName as string || '';
    const planGoal: string = params.planGoal as string || '';

    // Get background image for this day
    const trainingDayImages = planName && planGoal
        ? getTrainingDayImages(planName, planGoal)
        : [];
    const backgroundImage = trainingDayImages[dayIndex] || AppAssets.mainBackground;

    // [ANIMATION] Track scroll position
    const scrollY = useRef(new Animated.Value(0)).current;

    const [isLoading, setIsLoading] = useState(true);
    const [isRestTimeOn, setIsRestTimeOn] = useState(true);
    const [previewExercises, setPreviewExercises] = useState<TrainingExercisePreview[]>([]);
    const [exercises, setExercises] = useState<any[]>([]);
    const [selectedExerciseId, setSelectedExerciseId] = useState<number | null>(null);
    const [modalVisible, setModalVisible] = useState(false);

    useEffect(() => {
        handleGetExercise();
    }, []);

    const handleGetExercise = async () => {
        try {
            const exerciseGroups = scheduleData?.exerciseGroups;
            const exerciseList = exerciseGroups?.exercises || [];
            setExercises(exerciseList);

            const fetchedPreviews: TrainingExercisePreview[] = [];

            for (let i = 0; i < exerciseList.length; i++) {
                try {
                    const response = await trainingService.getExerciseById(exerciseList[i].exerciseId);

                    if (response.status === 'SUCCESS' && response.data) {
                        fetchedPreviews.push({
                            id: exerciseList[i].exerciseId,
                            name: response.data.name || '',
                            imageURL: response.data.imageURL || '',
                            description: response.data.description || '',
                            levelName: '',
                        });
                    }
                } catch (error) {
                    console.error(`Error fetching exercise ${exerciseList[i].exerciseId}:`, error);
                }
            }

            setPreviewExercises(fetchedPreviews);
            setIsLoading(false);
        } catch (error) {
            console.error('Error in handleGetExercise:', error);
            setIsLoading(false);
        }
    };

    const handleStartTraining = () => {
        router.push({
            pathname: '/(training)/training-day-start',
            params: {
                schedule: JSON.stringify(scheduleData),
                previewExercises: JSON.stringify(previewExercises),
                exercises: JSON.stringify(exercises),
            },
        });
    };

    const handleExercisePress = (exercise: TrainingExercisePreview) => {
        setSelectedExerciseId(exercise.id);
        setModalVisible(true);
    };

    const handleCloseModal = () => {
        setModalVisible(false);
        setSelectedExerciseId(null);
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
                source={backgroundImage}
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
                    style={styles.backButton}
                    onPress={() => router.back()}
                    activeOpacity={0.7}
                >
                    <Ionicons
                        name="chevron-back"
                        size={Dims.iconSizeXL}
                        color={Colors.dark}
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

                    {/* Header with Day and Name */}
                    <View style={styles.header}>
                        <Text style={styles.headerDayText}>{numberDay}</Text>
                        <Text style={styles.headerNameText}>{scheduleData?.name || ''}</Text>
                    </View>

                    {/* Workout Info Section */}
                    <View style={styles.infoSection}>
                        {/* Time and Location */}
                        <View style={styles.infoRow}>
                            <View style={styles.infoItem}>
                                <Text style={styles.infoValue}>
                                    {scheduleData?.duration || '60 phút'}
                                </Text>
                                <Text style={styles.infoLabel}>{AppStrings.trainingDetailTime}</Text>
                            </View>

                            <View style={styles.divider} />

                            <View style={styles.infoItem}>
                                <Text style={styles.infoValue}>
                                    {normalizeLocation(scheduleData?.location)}
                                </Text>
                                <Text style={styles.infoLabel}>{AppStrings.trainingDetailLocation}</Text>
                            </View>
                        </View>

                        {/* Note */}
                        {scheduleData?.exerciseGroups?.note && (
                            <View style={styles.noteContainer}>
                                <Image source={AppAssets.trainingNoteIcon} style={styles.noteIcon} />
                                <Text style={styles.noteText}>
                                    {scheduleData.exerciseGroups.note}
                                </Text>
                            </View>
                        )}

                        {/* Rest Time Toggle */}
                        <View style={styles.restTimeContainer}>
                            <Text style={styles.restTimeLabel}>
                                {AppStrings.trainingDetailRestTime}
                            </Text>
                            <Text style={styles.restTimeValue}>
                                {AppStrings.trainingDetailRestSeconds}
                            </Text>
                            <Switch
                                value={isRestTimeOn}
                                onValueChange={setIsRestTimeOn}
                                trackColor={{ false: '#e0e0e0', true: Colors.bNormal }}
                                thumbColor={Colors.wWhite}
                                style={styles.switch}
                            />
                        </View>
                    </View>

                    {/* Exercise List */}
                    <View style={styles.exerciseListContainer}>
                        {previewExercises.map((exercise, index) => {
                            const duration = exercises[index]?.duration || '';
                            const setInfo = parseSetInfo(duration);
                            const setLabel = setInfo.sets === '1'
                                ? AppStrings.trainingDetailSet
                                : AppStrings.trainingDetailSets;
                            const repOrTime = setInfo.repsPerSet || setInfo.durationPerSet || '';

                            return (
                                <ExerciseItem
                                    key={`${exercise.id}-${index}`}
                                    exercise={exercise}
                                    sets={setInfo.sets}
                                    setLabel={setLabel}
                                    repOrTime={repOrTime}
                                    onPress={() => handleExercisePress(exercise)}
                                />
                            );
                        })}
                    </View>

                    <View style={styles.bottomSpacer} />
                </View>
            </Animated.ScrollView>

            {/* --- 4. START BUTTON --- */}
            <View style={styles.buttonContainer}>
                <TouchableOpacity
                    style={styles.startButton}
                    onPress={handleStartTraining}
                    activeOpacity={0.7}
                    disabled={isLoading}
                >
                    <Text style={styles.startButtonText}>
                        {AppStrings.trainingDetailStart}
                    </Text>
                </TouchableOpacity>
            </View>

            {/* --- 5. LOADING OVERLAY --- */}
            {isLoading && (
                <View style={styles.loadingOverlay}>
                    <ActivityIndicator size="large" color={Colors.bNormal} />
                </View>
            )}

            {/* --- 6. EXERCISE DETAIL MODAL --- */}
            <ExerciseDetailModal
                visible={modalVisible}
                exerciseId={selectedExerciseId}
                onClose={handleCloseModal}
            />
        </View>
    );
}

// ====================================================================
// SUB-COMPONENTS
// ====================================================================

interface ExerciseItemProps {
    exercise: TrainingExercisePreview;
    sets: string;
    setLabel: string;
    repOrTime: string;
    onPress: () => void;
}

function ExerciseItem({ exercise, sets, setLabel, repOrTime, onPress }: ExerciseItemProps) {
    return (
        <TouchableOpacity
            style={styles.exerciseItem}
            onPress={onPress}
            activeOpacity={0.7}
        >
            {/* Exercise Image */}
            <View style={styles.exerciseImageContainer}>
                {exercise.imageURL ? (
                    <Image
                        source={{ uri: exercise.imageURL }}
                        style={styles.exerciseImage}
                        defaultSource={require('@/assets/images/main_background_image.webp')}
                    />
                ) : (
                    <View style={[styles.exerciseImage, styles.exercisePlaceholder]}>
                        <Ionicons name="image-outline" size={32} color={Colors.dark} />
                    </View>
                )}
            </View>

            {/* Exercise Info */}
            <View style={styles.exerciseInfo}>
                <Text style={styles.exerciseName} numberOfLines={2}>
                    {exercise.name}
                </Text>
                <Text style={styles.exerciseDetail}>
                    {sets} {setLabel} | {repOrTime}
                </Text>
            </View>
        </TouchableOpacity>
    );
}

// ====================================================================
// STYLES
// ====================================================================

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: Colors.bLight,
    },

    // Background Image (Position Absolute)
    backgroundImage: {
        position: 'absolute',
        top: 0,
        left: 0,
        right: 0,
        width: '100%',
        height: HEADER_HEIGHT,
        zIndex: 0,
    },

    // Fixed Header (Back Button)
    fixedHeader: {
        position: 'absolute',
        top: 0,
        left: 0,
        right: 0,
        zIndex: 100,
        paddingTop: Platform.OS === 'ios' ? Dims.size48 : StatusBar.currentHeight,
        paddingHorizontal: Dims.paddingM,
        height: Dims.size88,
        justifyContent: 'center',
    },
    backButton: {
        width: Dims.size40,
        height: Dims.size40,
        borderRadius: Dims.borderRadiusLarge,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: 'rgba(255,255,255,0.3)',
    },

    // ScrollView
    scrollView: {
        flex: 1,
        zIndex: 1,
    },

    // Content Sheet (White card containing content)
    contentSheet: {
        backgroundColor: Colors.bLight,
        borderTopLeftRadius: Dims.borderRadiusLarge,
        borderTopRightRadius: Dims.borderRadiusLarge,
        paddingHorizontal: 0,
        paddingTop: Dims.paddingM,
        minHeight: WINDOW_HEIGHT - HEADER_MIN_HEIGHT,

        // Shadow
        shadowColor: "#000",
        shadowOffset: { width: 0, height: -3 },
        shadowOpacity: 0.1,
        shadowRadius: 5,
        elevation: 5,
    },

    // Drag Handle
    dragHandleContainer: {
        alignItems: 'center',
        marginBottom: Dims.spacingM,
    },
    dragHandle: {
        width: Dims.size48,
        height: Dims.size4,
        backgroundColor: Colors.bLightHover,
        borderRadius: Dims.borderRadiusLarge,
    },

    // Header Section
    header: {
        backgroundColor: Colors.bNormal,
        paddingVertical: Dims.paddingS,
        borderTopLeftRadius: Dims.borderRadiusLarge,
        borderTopRightRadius: Dims.borderRadiusLarge,
        alignItems: 'center',
        marginHorizontal: Dims.spacingML,
        marginBottom: Dims.spacingML,
    },
    headerDayText: {
        fontSize: Dims.textSizeXL,
        fontWeight: 'bold',
        color: Colors.wWhite,
    },
    headerNameText: {
        fontSize: Dims.textSizeL,
        color: Colors.wWhite,
        marginTop: Dims.spacingSM,
    },

    // Info Section
    infoSection: {
        paddingHorizontal: Dims.paddingL,
        marginBottom: Dims.spacingL,
    },
    infoRow: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        marginBottom: Dims.spacingL,
    },
    infoItem: {
        alignItems: 'center',
    },
    infoValue: {
        fontSize: Dims.textSizeM,
        fontWeight: 'bold',
        color: Colors.dark,
        marginBottom: Dims.spacingM,
    },
    infoLabel: {
        fontSize: Dims.textSizeS,
        color: Colors.dark,
    },
    divider: {
        width: 1,
        height: Dims.size48,
        backgroundColor: Colors.bNormal,
        marginHorizontal: Dims.spacingGiant,
    },

    // Note Section
    noteContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        marginBottom: Dims.spacingL,
    },
    noteIcon: {
        width: Dims.iconSizeXXL,
        height: Dims.iconSizeXXL,
        marginRight: Dims.spacingS,
    },
    noteText: {
        fontSize: Dims.textSizeS,
        color: Colors.dark,
        flex: 1,
        maxWidth: Dims.size248,
        textAlign: 'center',
    },

    // Rest Time Section
    restTimeContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        backgroundColor: Colors.wWhite,
        borderRadius: Dims.borderRadiusL,
        paddingHorizontal: Dims.spacingSM,
        paddingVertical: Dims.spacingSM,
        marginBottom: Dims.spacingS,
    },
    restTimeLabel: {
        fontSize: Dims.textSizeM,
        color: Colors.dark,
        fontWeight: 'bold',
    },
    restTimeValue: {
        fontSize: Dims.textSizeM,
        color: Colors.dark,
    },
    switch: {
        transform: [{ scale: 0.8 }],
    },

    // Exercise List Section
    exerciseListContainer: {
        marginHorizontal: Dims.spacingML,
        backgroundColor: Colors.wWhite,
        borderRadius: Dims.borderRadiusLarge,
        padding: Dims.spacingSM,
    },
    exerciseItem: {
        flexDirection: 'row',
        paddingVertical: Dims.paddingS,
        alignItems: 'center',
    },
    exerciseImageContainer: {
        marginRight: Dims.spacingSM,
    },
    exerciseImage: {
        width: Dims.size112,
        height: Dims.size64,
        borderRadius: Dims.borderRadiusSmall,
    },
    exercisePlaceholder: {
        backgroundColor: Colors.lightGray,
        justifyContent: 'center',
        alignItems: 'center',
    },
    exerciseInfo: {
        flex: 1,
    },
    exerciseName: {
        fontSize: Dims.textSizeM,
        fontWeight: '600',
        color: Colors.dark,
        marginBottom: Dims.spacingS,
    },
    exerciseDetail: {
        fontSize: Dims.textSizeS,
        color: Colors.bNormal,
    },

    // Bottom Spacer
    bottomSpacer: {
        height: Dims.size120,
    },

    // Button Container
    buttonContainer: {
        position: 'absolute',
        bottom: Dims.paddingL,
        left: Dims.paddingM,
        right: Dims.paddingM,
        zIndex: 200,
    },
    startButton: {
        backgroundColor: Colors.bNormal,
        paddingVertical: Dims.paddingM,
        borderRadius: Dims.borderRadiusSmall,
        alignItems: 'center',
        justifyContent: 'center',
        minHeight: Dims.paddingXL,

        // Shadow for floating effect
        shadowColor: "#000",
        shadowOffset: { width: 0, height: 4 },
        shadowOpacity: 0.3,
        shadowRadius: 8,
        elevation: 8,
    },
    startButtonText: {
        color: Colors.wWhite,
        fontSize: Dims.textSizeL,
        fontWeight: 'bold',
    },

    // Loading Overlay
    loadingOverlay: {
        ...StyleSheet.absoluteFillObject,
        backgroundColor: 'rgba(255, 255, 255, 0.8)',
        justifyContent: 'center',
        alignItems: 'center',
        zIndex: 300,
    },
});
