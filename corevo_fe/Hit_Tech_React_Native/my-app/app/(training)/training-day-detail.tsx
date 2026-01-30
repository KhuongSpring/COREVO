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
    Switch,
} from 'react-native';
import { router, useLocalSearchParams } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { AppAssets } from '@/constants/AppAssets';
import { AppStrings } from '@/constants/AppStrings';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { trainingService } from '@/services/api/trainingService';
import type { TrainingSchedule, TrainingExercisePreview } from '@/types/training';

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
    const imageBG: string = params.imageBG as string || '';

    const [isLoading, setIsLoading] = useState(true);
    const [isRestTimeOn, setIsRestTimeOn] = useState(true);
    const [previewExercises, setPreviewExercises] = useState<TrainingExercisePreview[]>([]);
    const [exercises, setExercises] = useState<any[]>([]);

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

            // Simulate loading delay like Flutter
            setTimeout(() => {
                setIsLoading(false);
            }, 3000);
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

    return (
        <View style={styles.container}>
            {/* Background Image */}
            <ImageBackground
                source={imageBG ? { uri: imageBG } : AppAssets.mainBackground}
                style={styles.backgroundImage}
                resizeMode="cover"
            >
                {/* Back Button */}
                <TouchableOpacity
                    style={styles.backButton}
                    onPress={() => router.back()}
                    activeOpacity={0.7}
                >
                    <Ionicons name="chevron-back-outline" size={Dims.iconSizeM} color={Colors.dark} />
                </TouchableOpacity>

                {/* Draggable Bottom Sheet */}
                <View style={styles.bottomSheet}>
                    <ScrollView
                        style={styles.scrollView}
                        contentContainerStyle={styles.scrollContent}
                        showsVerticalScrollIndicator={false}
                    >
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
                                        key={index}
                                        exercise={exercise}
                                        sets={setInfo.sets}
                                        setLabel={setLabel}
                                        repOrTime={repOrTime}
                                    />
                                );
                            })}
                        </View>

                        <View style={{ height: Dims.size80 }} />
                    </ScrollView>
                </View>

                {/* Start Button */}
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

                {/* Loading Overlay */}
                {isLoading && (
                    <View style={styles.loadingOverlay}>
                        <ActivityIndicator size="large" color={Colors.bNormal} />
                    </View>
                )}
            </ImageBackground>
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
}

function ExerciseItem({ exercise, sets, setLabel, repOrTime }: ExerciseItemProps) {
    return (
        <View style={styles.exerciseItem}>
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
        </View>
    );
}

// ====================================================================
// STYLES
// ====================================================================

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    backgroundImage: {
        flex: 1,
    },
    backButton: {
        position: 'absolute',
        top: Dims.paddingXL,
        left: Dims.spacingSM,
        zIndex: 10,
        padding: Dims.paddingS,
    },
    bottomSheet: {
        position: 'absolute',
        bottom: 0,
        left: 0,
        right: 0,
        height: '70%',
        backgroundColor: Colors.bLight,
        borderTopLeftRadius: Dims.borderRadiusLarge,
        borderTopRightRadius: Dims.borderRadiusLarge,
    },
    scrollView: {
        flex: 1,
    },
    scrollContent: {
        paddingBottom: Dims.spacingXXL,
    },
    header: {
        backgroundColor: Colors.bNormal,
        paddingVertical: Dims.paddingS,
        borderTopLeftRadius: Dims.borderRadiusLarge,
        borderTopRightRadius: Dims.borderRadiusLarge,
        alignItems: 'center',
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
    infoSection: {
        paddingHorizontal: Dims.paddingL,
        marginTop: Dims.spacingML,
    },
    infoRow: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        marginBottom: Dims.spacingL,
    },
    infoItem: {
        alignItems: 'center',
        flex: 1,
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
    restTimeContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        backgroundColor: Colors.wWhite,
        borderRadius: Dims.borderRadiusLarge,
        padding: Dims.paddingS,
        marginBottom: Dims.spacingL,
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
    buttonContainer: {
        position: 'absolute',
        bottom: Dims.paddingL,
        left: Dims.paddingM,
        right: Dims.paddingM,
    },
    startButton: {
        backgroundColor: Colors.bNormal,
        paddingVertical: Dims.paddingM,
        borderRadius: Dims.borderRadiusSmall,
        alignItems: 'center',
        justifyContent: 'center',
        minHeight: Dims.paddingXL,
    },
    startButtonText: {
        color: Colors.wWhite,
        fontSize: Dims.textSizeL,
        fontWeight: 'bold',
    },
    loadingOverlay: {
        ...StyleSheet.absoluteFillObject,
        backgroundColor: 'rgba(255, 255, 255, 0.8)',
        justifyContent: 'center',
        alignItems: 'center',
    },
});
