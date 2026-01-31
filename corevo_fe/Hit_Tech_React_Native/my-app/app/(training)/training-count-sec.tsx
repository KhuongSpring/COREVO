import React, { useState, useEffect, useRef } from 'react';
import {
    View,
    Text,
    StyleSheet,
    TouchableOpacity,
    ActivityIndicator,
    Image,
    Dimensions,
} from 'react-native';
import { router, useLocalSearchParams } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { AppStrings } from '@/constants/AppStrings';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { trainingService } from '@/services/api/trainingService';
import type { TrainingExercise } from '@/types/training';
import ExerciseDetailModal from '@/components/library/ExerciseDetailModal';



enum TimerPhase {
    WORK = 'work',
    REST = 'rest',
}

const WORK_DURATION = 45; // seconds
const REST_DURATION = 30; // seconds
const SCREEN_HEIGHT = Dimensions.get('window').height;

export default function TrainingCountSecScreen() {
    const params = useLocalSearchParams();

    // Parse params from navigation
    const exerciseId = parseInt(params.exerciseId as string);
    const exerciseIndex = parseInt(params.exerciseIndex as string);
    const setIndex = parseInt(params.setIndex as string) || 0;
    const totalSet = parseInt(params.totalSet as string);
    const completedSet = parseInt(params.completedSet as string);
    const totalSets = parseInt(params.totalSets as string) || 3;

    // State
    const [exercise, setExercise] = useState<TrainingExercise | null>(null);
    const [loading, setLoading] = useState(true);
    const [currentPhase, setCurrentPhase] = useState<TimerPhase>(TimerPhase.WORK);
    const [remainingSeconds, setRemainingSeconds] = useState(WORK_DURATION);
    const [imageReady, setImageReady] = useState(false);
    const [modalVisible, setModalVisible] = useState(false);

    const handleCloseModal = () => {
        setModalVisible(false);
    };

    const handleOpenModal = () => {
        setModalVisible(true);
    };

    // Timer ref
    const timerRef = useRef<NodeJS.Timeout | null>(null);

    // Fetch exercise data
    useEffect(() => {
        fetchExerciseData();

        return () => {
            if (timerRef.current) {
                clearInterval(timerRef.current);
            }
        };
    }, []);

    // Start timer
    useEffect(() => {
        startTimer();
        return () => {
            if (timerRef.current) {
                clearInterval(timerRef.current);
            }
        };
    }, [currentPhase]);

    const fetchExerciseData = async () => {
        try {
            const response = await trainingService.getExerciseById(exerciseId);
            if (response.status === 'SUCCESS' && response.data) {
                setExercise(response.data);
                setTimeout(() => setImageReady(true), 500);
            }
        } catch (error) {
            console.error('Error fetching exercise:', error);
        } finally {
            setLoading(false);
        }
    };

    const startTimer = () => {
        if (timerRef.current) {
            clearInterval(timerRef.current);
        }

        timerRef.current = setInterval(() => {
            setRemainingSeconds((prev) => {
                if (prev > 1) {
                    return prev - 1;
                } else {
                    // Timer reached 0
                    if (currentPhase === TimerPhase.WORK) {
                        // Switch to rest phase
                        setCurrentPhase(TimerPhase.REST);
                        return REST_DURATION;
                    } else {
                        // Rest phase complete - finish set and go back
                        handleSetComplete(WORK_DURATION + REST_DURATION);
                        return 0;
                    }
                }
            });
        }, 1000);
    };

    const handleSetComplete = (totalTime: number) => {
        if (timerRef.current) {
            clearInterval(timerRef.current);
        }

        // In a real app, this would call the parent's onSetCompleted callback
        // For now, just navigate back
        router.back();
    };

    const handleAdd20Seconds = () => {
        if (currentPhase === TimerPhase.REST) {
            setRemainingSeconds((prev) => prev + 20);
        }
    };

    const handleSkip = () => {
        if (currentPhase === TimerPhase.REST) {
            handleSetComplete(WORK_DURATION + (REST_DURATION - remainingSeconds));
        } else if (remainingSeconds <= 19) {
            // Can only skip work if less than 19 seconds remaining
            handleSetComplete(WORK_DURATION - remainingSeconds);
        }
    };



    const formatTime = (seconds: number): string => {
        const mins = Math.floor(seconds / 60);
        const secs = seconds % 60;
        return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
    };



    if (loading) {
        return (
            <View style={styles.loadingContainer}>
                <ActivityIndicator size="large" color={Colors.wWhite} />
            </View>
        );
    }

    if (!exercise) {
        return (
            <View style={styles.loadingContainer}>
                <Text style={styles.errorText}>Exercise not found</Text>
            </View>
        );
    }

    const canAdd20 = currentPhase === TimerPhase.REST;
    const canSkip = currentPhase === TimerPhase.REST ||
        (currentPhase === TimerPhase.WORK && remainingSeconds <= 19);

    return (
        <View style={styles.container}>
            {/* Back Button */}
            <TouchableOpacity
                style={styles.backButton}
                onPress={() => router.back()}
            >
                <Ionicons name="chevron-back-outline" size={Dims.iconSizeXL} color={Colors.wWhite} />
            </TouchableOpacity>

            {/* Main Timer Display */}
            <View style={styles.timerContainer}>
                <Text style={styles.phaseLabel}>
                    {currentPhase === TimerPhase.WORK
                        ? AppStrings.trainingWorkPhase
                        : AppStrings.trainingRestPhase}
                </Text>

                <Text style={styles.timerText}>
                    {formatTime(remainingSeconds)}
                </Text>

                {/* Control Buttons */}
                <View style={styles.controlButtons}>
                    <TouchableOpacity
                        style={[
                            styles.controlButton,
                            !canAdd20 && styles.controlButtonDisabled
                        ]}
                        onPress={handleAdd20Seconds}
                        disabled={!canAdd20}
                    >
                        <Text style={[
                            styles.controlButtonText,
                            !canAdd20 && styles.controlButtonTextDisabled
                        ]}>
                            {AppStrings.trainingAdd20Sec}
                        </Text>
                    </TouchableOpacity>

                    <TouchableOpacity
                        style={[
                            styles.controlButton,
                            !canSkip && styles.controlButtonDisabled
                        ]}
                        onPress={handleSkip}
                        disabled={!canSkip}
                    >
                        <Text style={[
                            styles.controlButtonText,
                            !canSkip && styles.controlButtonTextDisabled
                        ]}>
                            {AppStrings.trainingSkip}
                        </Text>
                    </TouchableOpacity>
                </View>
            </View>

            {/* Set Progress Info */}
            <View style={styles.progressInfo}>
                <Text style={styles.nextSetText}>
                    {AppStrings.trainingNextSet} {completedSet}/{totalSet}
                </Text>
                <Text style={styles.currentSetText}>
                    {exercise.name} - {AppStrings.trainingSetLabel} {setIndex + 1}/{totalSets}
                </Text>
            </View>

            {/* Bottom Sheet - Static Preview */}
            <View style={styles.bottomSheet}>
                <View style={styles.minimizedSheetContent}>
                    {imageReady && exercise.imageURL && (
                        <View style={styles.previewImageContainer}>
                            <Image
                                source={{ uri: exercise.imageURL }}
                                style={styles.previewImage}
                                resizeMode="contain"
                            />

                            {/* "?" Button */}
                            <TouchableOpacity
                                style={styles.infoButton}
                                onPress={handleOpenModal}
                            >
                                <Text style={styles.infoButtonText}>?</Text>
                            </TouchableOpacity>
                        </View>
                    )}

                    {!imageReady && (
                        <View style={styles.previewImagePlaceholder}>
                            <ActivityIndicator size="small" color={Colors.bNormal} />
                        </View>
                    )}
                </View>
            </View>

            {/* Exercise Detail Modal */}
            <ExerciseDetailModal
                visible={modalVisible}
                exerciseId={exerciseId}
                onClose={handleCloseModal}
            />
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: Colors.bNormal,
    },
    loadingContainer: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: Colors.bNormal,
    },
    errorText: {
        fontSize: Dims.textSizeL,
        color: Colors.wWhite,
    },
    backButton: {
        position: 'absolute',
        top: Dims.paddingXXXL,
        left: Dims.paddingS,
        zIndex: 100,
        padding: Dims.paddingS,
    },

    // Timer Section
    timerContainer: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        paddingBottom: Dims.size152,
    },
    phaseLabel: {
        fontSize: Dims.textSizeXL,
        color: Colors.wWhite,
        fontWeight: 'bold',
        marginBottom: Dims.spacingML,
    },
    timerText: {
        fontSize: 54,
        color: Colors.wWhite,
        fontWeight: 'bold',
        marginBottom: Dims.spacingXXXL,
    },
    controlButtons: {
        flexDirection: 'row',
        gap: Dims.spacingML,
    },
    controlButton: {
        backgroundColor: Colors.wWhite,
        paddingVertical: Dims.paddingS,
        paddingHorizontal: Dims.paddingXL,
        borderRadius: Dims.borderRadiusLarge,
        minWidth: Dims.size104,
        alignItems: 'center',
    },
    controlButtonDisabled: {
        backgroundColor: Colors.bLightNotActive,
    },
    controlButtonText: {
        fontSize: Dims.textSizeM,
        fontWeight: 'bold',
        color: Colors.bNormal,
    },
    controlButtonTextDisabled: {
        color: Colors.wWhite,
    },

    // Progress Info
    progressInfo: {
        position: 'absolute',
        bottom: Dims.size288,
        left: Dims.size24,
    },
    nextSetText: {
        color: Colors.wWhite,
        fontSize: Dims.textSizeM,
        fontWeight: '500',
        marginBottom: 4,
    },
    currentSetText: {
        color: Colors.wWhite,
        fontSize: Dims.textSizeM,
        fontWeight: '500',
    },

    // Bottom Sheet
    bottomSheet: {
        position: 'absolute',
        bottom: 0,
        left: 0,
        right: 0,
        backgroundColor: Colors.wWhite,
        borderTopLeftRadius: Dims.borderRadiusLarge,
        borderTopRightRadius: Dims.borderRadiusLarge,
        paddingHorizontal: Dims.paddingL,
        paddingVertical: Dims.paddingL,
        minHeight: SCREEN_HEIGHT * 0.3,
    },

    // Minimized Sheet
    minimizedSheetContent: {
        alignItems: 'center',
    },
    previewImageContainer: {
        position: 'relative',
        width: '100%',
        alignItems: 'center',
    },
    previewImage: {
        width: '100%',
        height: Dims.size224,
        borderRadius: Dims.borderRadius,
        borderWidth: 3,
        borderColor: Colors.bNormal,
    },
    previewImagePlaceholder: {
        width: '100%',
        height: Dims.size224,
        borderRadius: Dims.borderRadius,
        borderWidth: 3,
        borderColor: Colors.bNormal,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: Colors.lightGray,
    },
    infoButton: {
        position: 'absolute',
        top: Dims.spacingSM,
        right: Dims.spacingSM,
        width: Dims.spacingML,
        height: Dims.spacingML,
        borderRadius: Dims.spacingML / 2,
        backgroundColor: Colors.bNormal,
        justifyContent: 'center',
        alignItems: 'center',
    },
    infoButtonText: {
        fontSize: Dims.textSizeXS,
        color: Colors.wWhite,
        fontWeight: 'bold',
    },
});

