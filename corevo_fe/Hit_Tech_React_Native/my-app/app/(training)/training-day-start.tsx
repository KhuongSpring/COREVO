import React, { useState, useEffect } from 'react';
import {
    View,
    Text,
    StyleSheet,
    ImageBackground,
    ScrollView,
    TouchableOpacity,
    Image,
    ActivityIndicator,
    Alert,
    StatusBar,
    Platform,
    Dimensions,
} from 'react-native';
import { router, useLocalSearchParams } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { AppAssets } from '@/constants/AppAssets';
import { AppStrings } from '@/constants/AppStrings';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { trainingService } from '@/services/api/trainingService';
import type { ExerciseSetProgress } from '@/types/ExerciseProgressTypes';
import type { TrainingSchedule, TrainingExercisePreview } from '@/types/training';

// ====================================================================
// HELPER FUNCTIONS
// ====================================================================

const formatSecondsToTime = (totalSeconds: number): string => {
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
    return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
};

const parseSetCount = (duration: string): number => {
    const parts = duration.split('X');
    if (parts.length === 0) return 1;

    const match = parts[0].match(/\d+/);
    return match ? parseInt(match[0], 10) : 1;
};

const getRepOrSecOfExercise = (duration: string): string => {
    const parts = duration.split('X');
    if (parts.length < 2) return duration;

    const value = parts[1].trim();
    // Check if it contains "sec" or is a number followed by "s"
    if (value.toLowerCase().includes('sec') || value.toLowerCase().includes('s')) {
        return value;
    }
    // Otherwise it's reps
    return `${value} ${AppStrings.reps}`;
};

// ====================================================================
// MAIN COMPONENT
// ====================================================================

export default function TrainingDayStartScreen() {
    const params = useLocalSearchParams();

    // Parse params - in a real implementation, these would come from navigation
    // For now, we'll need to fetch data based on IDs
    const scheduleData = params.schedule ? JSON.parse(params.schedule as string) : null;
    const previewExercisesData = params.previewExercises ? JSON.parse(params.previewExercises as string) : [];
    const exercisesData = params.exercises ? JSON.parse(params.exercises as string) : [];

    const [isLoading, setIsLoading] = useState(true);
    const [isExpandedList, setIsExpandedList] = useState<boolean[]>([]);
    const [currentIndex, setCurrentIndex] = useState(0);
    const [totalTime, setTotalTime] = useState(0);
    const [exerciseProgressList, setExerciseProgressList] = useState<ExerciseSetProgress[]>([]);
    const [completions, setCompletions] = useState<Record<string, boolean>>({});

    useEffect(() => {
        initializeScreen();
    }, []);

    const initializeScreen = async () => {
        // Initialize expanded states
        setIsExpandedList(Array(exercisesData.length).fill(false));

        // Fetch daily progress
        await handleTrainingDailyProgress();

        setIsLoading(false);
    };

    const handleTrainingDailyProgress = async () => {
        try {
            const response = await trainingService.getDailyProgress();

            if (response.status === 'SUCCESS' && response.data) {
                const fetchedCompletions = (response.data as any).completions || {};
                const builtProgressList = buildExerciseProgressList(exercisesData, fetchedCompletions);

                setCompletions(fetchedCompletions);
                setExerciseProgressList(builtProgressList);
            }
        } catch (error) {
            console.error('Error fetching daily progress:', error);
        }
    };

    const buildExerciseProgressList = (
        exercises: any[],
        completions: Record<string, boolean>
    ): ExerciseSetProgress[] => {
        return exercises.map((exercise) => {
            const setCount = parseSetCount(exercise.duration);
            const isExerciseCompleted = completions[`${exercise.exerciseId}`] === true;

            return {
                exerciseId: exercise.exerciseId,
                totalSets: setCount,
                setCompleted: Array(setCount).fill(isExerciseCompleted),
            };
        });
    };

    const handleCompleteExercise = async (id: number) => {
        try {
            await trainingService.completeExercise(id);
        } catch (error) {
            console.error('Error completing exercise:', error);
        }
    };

    const getCompletedSetCount = (): number => {
        return exerciseProgressList.reduce((total, exercise) => {
            return total + exercise.setCompleted.filter(completed => completed).length;
        }, 0);
    };

    const getTotalSetCount = (): number => {
        return exerciseProgressList.reduce((total, exercise) => total + exercise.totalSets, 0);
    };

    const toggleExpanded = (index: number) => {
        const newExpandedList = [...isExpandedList];
        newExpandedList[index] = !newExpandedList[index];
        setIsExpandedList(newExpandedList);
    };

    const showPauseDialog = () => {
        Alert.alert(
            AppStrings.trainingPauseDialogTitle,
            AppStrings.trainingPauseDialogMessage,
            [
                {
                    text: AppStrings.trainingPauseDialogCancel,
                    style: 'cancel',
                },
                {
                    text: AppStrings.trainingPauseDialogConfirm,
                    onPress: () => router.back(),
                    style: 'destructive',
                },
            ]
        );
    };

    const handleNextExercise = () => {
        const currentProgress = exerciseProgressList[currentIndex];
        const isCompleted = currentProgress?.setCompleted.every(set => set) ?? false;

        let nextIndex = currentIndex;

        if (isCompleted) {
            // Find next incomplete exercise
            for (let i = currentIndex + 1; i < exerciseProgressList.length; i++) {
                if (!exerciseProgressList[i].setCompleted.every(set => set)) {
                    nextIndex = i;
                    break;
                }
            }
        }

        // Navigate to exercise execution screen
        router.push({
            pathname: '/(training)/training-count-sec',
            params: {
                exerciseId: previewExercisesData[nextIndex]?.id,
                exerciseIndex: nextIndex,
                totalSet: getTotalSetCount(),
                completedSet: getCompletedSetCount(),
            },
        });

        setCurrentIndex(nextIndex);
    };

    if (isLoading) {
        return (
            <View style={styles.loadingContainer}>
                <ActivityIndicator size="large" color={Colors.bNormal} />
            </View>
        );
    }

    return (
        <ImageBackground source={AppAssets.mainBackground} style={styles.background}>
            <StatusBar barStyle="light-content" translucent backgroundColor="transparent" />
            <View style={styles.container}>
                {/* Header */}
                <View style={styles.header}>
                    <TouchableOpacity onPress={showPauseDialog} style={styles.backButton}>
                        <Ionicons name="chevron-back-outline" size={Dims.iconSizeXL} color={Colors.dark} />
                    </TouchableOpacity>

                    <Text style={styles.headerTitle}>{scheduleData?.name || 'Training'}</Text>

                    <Text style={styles.timerText}>{formatSecondsToTime(totalTime)}</Text>
                </View>

                {/* Exercise List */}
                <ScrollView
                    style={styles.scrollView}
                    contentContainerStyle={styles.scrollContent}
                >
                    {previewExercisesData.map((previewExercise: any, index: number) => {
                        const exercise = exercisesData[index];
                        const progressData = exerciseProgressList[index];
                        const completedCount = progressData?.setCompleted.filter(c => c).length || 0;

                        return (
                            <ExerciseCard
                                key={index}
                                previewExercise={previewExercise}
                                exercise={exercise}
                                isExpanded={isExpandedList[index]}
                                onToggleExpand={() => toggleExpanded(index)}
                                exerciseIndex={index}
                                completedCount={completedCount}
                                totalSets={progressData?.totalSets || 0}
                                setCompleted={progressData?.setCompleted || []}
                            />
                        );
                    })}
                </ScrollView>

                {/* Bottom Button */}
                <View style={styles.bottomButtonContainer}>
                    <TouchableOpacity
                        style={styles.nextButton}
                        onPress={handleNextExercise}
                    >
                        <Text style={styles.nextButtonText}>{AppStrings.trainingNext}</Text>
                    </TouchableOpacity>
                </View>
            </View>
        </ImageBackground>
    );
}

// ====================================================================
// SUB-COMPONENTS
// ====================================================================

interface ExerciseCardProps {
    previewExercise: any;
    exercise: any;
    isExpanded: boolean;
    onToggleExpand: () => void;
    exerciseIndex: number;
    completedCount: number;
    totalSets: number;
    setCompleted: boolean[];
}

function ExerciseCard({
    previewExercise,
    exercise,
    isExpanded,
    onToggleExpand,
    exerciseIndex,
    completedCount,
    totalSets,
    setCompleted,
}: ExerciseCardProps) {
    return (
        <TouchableOpacity
            style={styles.exerciseCard}
            onPress={onToggleExpand}
            activeOpacity={0.7}
        >
            <View style={styles.exerciseCardContent}>
                {/* Exercise Image */}
                <View style={styles.exerciseImageContainer}>
                    {previewExercise.imageURL ? (
                        <Image
                            source={{ uri: previewExercise.imageURL }}
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
                        {previewExercise.name}
                    </Text>
                    <Text style={styles.exerciseProgress}>
                        {completedCount}/{totalSets} {AppStrings.trainingCompletedLabel}
                    </Text>
                </View>

                {/* Expand Icon */}
                <Ionicons
                    name={isExpanded ? 'chevron-up' : 'chevron-down'}
                    size={Dims.iconSizeM}
                    color={Colors.dark}
                />
            </View>

            {/* Expanded Content */}
            {isExpanded && (
                <View style={styles.expandedContent}>
                    {/* Table Header */}
                    <View style={styles.tableHeader}>
                        <Text style={styles.tableHeaderColumn1}>{AppStrings.trainingSetLabel}</Text>
                        <Text style={styles.tableHeaderColumn2}>{AppStrings.trainingRepTimeLabel}</Text>
                        <Text style={styles.tableHeaderColumn3}></Text>
                    </View>

                    {/* Sets List */}
                    {setCompleted.map((isCompleted, setIndex) => (
                        <SetRow
                            key={setIndex}
                            setNumber={setIndex + 1}
                            duration={exercise.duration}
                            isCompleted={isCompleted}
                        />
                    ))}
                </View>
            )}
        </TouchableOpacity>
    );
}

interface SetRowProps {
    setNumber: number;
    duration: string;
    isCompleted: boolean;
}

function SetRow({ setNumber, duration, isCompleted }: SetRowProps) {
    return (
        <View style={[
            styles.setRow,
            isCompleted && styles.setRowCompleted
        ]}>
            {/* Column 1: Set Number */}
            <View style={styles.setNumberColumn}>
                <Text style={[
                    styles.setNumberText,
                    isCompleted && styles.setTextCompleted
                ]}>
                    {setNumber}
                </Text>
            </View>

            {/* Column 2: Duration Badge */}
            <View style={styles.durationColumn}>
                <View style={[
                    styles.durationBadge,
                    isCompleted && styles.durationBadgeCompleted
                ]}>
                    <Text style={styles.durationText}>
                        {getRepOrSecOfExercise(duration)}
                    </Text>
                </View>
            </View>

            {/* Column 3: Tick Icon */}
            <View style={styles.tickColumn}>
                <Image
                    source={isCompleted ? AppAssets.tickActive : AppAssets.tickNonActive}
                    style={styles.tickIcon}
                />
            </View>
        </View>
    );
}

// ====================================================================
// STYLES
// ====================================================================

const styles = StyleSheet.create({
    loadingContainer: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: Colors.wWhite,
    },
    background: {
        flex: 1,
    },
    container: {
        flex: 1,
    },
    header: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        paddingHorizontal: Dims.paddingM,
        paddingTop: Platform.OS === 'ios' ? Dims.size48 : (StatusBar.currentHeight || 0) + Dims.paddingM,
        marginBottom: Dims.spacingM,
    },
    backButton: {
        width: Dims.size40,
        height: Dims.size40,
        borderRadius: Dims.borderRadiusLarge,
        justifyContent: 'center',
        alignItems: 'center',
    },
    headerTitle: {
        fontSize: Dims.textSizeL,
        color: Colors.dark,
        fontWeight: '500',
        flex: 1,
        textAlign: 'center',
    },
    timerText: {
        fontSize: Dims.textSizeM,
        color: Colors.dark,
        fontWeight: '500',
        textAlign: 'right',
    },
    scrollView: {
        flex: 1,
    },
    scrollContent: {
        padding: Dims.paddingL,
        paddingBottom: Dims.size80 + Dims.paddingL,
    },
    exerciseCard: {
        backgroundColor: Colors.wWhite,
        borderRadius: Dims.borderRadiusL,
        padding: Dims.paddingM,
        marginBottom: Dims.spacingM,

        // Shadow for card depth
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.1,
        shadowRadius: 4,
        elevation: 3,
    },
    exerciseCardContent: {
        flexDirection: 'row',
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
        justifyContent: 'center',
    },
    exerciseName: {
        fontSize: Dims.textSizeM,
        fontWeight: '600',
        color: Colors.dark,
        marginBottom: Dims.spacingS,
    },
    exerciseProgress: {
        fontSize: Dims.textSizeS,
        color: Colors.bNormal,
    },
    expandedContent: {
        marginTop: Dims.spacingML,
        paddingLeft: Dims.size28,
        paddingRight: Dims.spacingML,
    },
    tableHeader: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        marginBottom: Dims.spacingS,
        paddingHorizontal: Dims.paddingS,
    },
    tableHeaderColumn1: {
        fontSize: Dims.textSizeS,
        color: Colors.dark,
        width: Dims.size40,
        textAlign: 'center',
    },
    tableHeaderColumn2: {
        fontSize: Dims.textSizeS,
        color: Colors.dark,
        flex: 1,
        textAlign: 'center',
        marginHorizontal: Dims.spacingM,
    },
    tableHeaderColumn3: {
        fontSize: Dims.textSizeS,
        color: Colors.dark,
        width: Dims.size40,
        textAlign: 'center',
    },

    // Set Row Styles
    setRow: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        backgroundColor: Colors.wWhite,
        borderRadius: Dims.borderRadiusSmall,
        padding: Dims.paddingS,
    },
    setRowCompleted: {
        backgroundColor: Colors.bNormalActive,
    },

    // Column Containers
    setNumberColumn: {
        width: Dims.size40,
        alignItems: 'center',
        justifyContent: 'center',
    },
    durationColumn: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
        marginHorizontal: Dims.spacingM,
    },
    tickColumn: {
        width: Dims.size40,
        alignItems: 'center',
        justifyContent: 'center',
    },
    setNumberText: {
        fontSize: Dims.textSizeS,
        color: Colors.dark,
    },
    setTextCompleted: {
        color: Colors.wWhite,
    },
    durationBadge: {
        backgroundColor: '#DADADA',
        borderRadius: Dims.borderRadiusSmall,
        justifyContent: 'center',
        alignItems: 'center',
        paddingHorizontal: Dims.paddingM,
        paddingVertical: Dims.paddingS,
        minWidth: Dims.size64,
    },
    durationBadgeCompleted: {
        backgroundColor: Colors.wWhite,
    },
    durationText: {
        fontSize: Dims.textSizeS,
        color: Colors.dark,
    },
    tickIcon: {
        width: Dims.size24,
        height: Dims.size24,
    },
    bottomButtonContainer: {
        position: 'absolute',
        bottom: Dims.paddingL,
        left: Dims.paddingM,
        right: Dims.paddingM,
        zIndex: 200,
    },
    nextButton: {
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
    nextButtonText: {
        color: Colors.wWhite,
        fontSize: Dims.textSizeL,
        fontWeight: 'bold',
    },
});
