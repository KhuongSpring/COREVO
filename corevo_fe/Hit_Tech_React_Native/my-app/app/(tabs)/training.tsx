import React, { useState, useEffect, useRef } from 'react';
import {
    View,
    Text,
    StyleSheet,
    ImageBackground,
    ScrollView,
    TouchableOpacity,
    Image,
    StatusBar,
    Animated,
} from 'react-native';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { AppStrings } from '@/constants/AppStrings';
import { AppAssets } from '@/constants/AppAssets';
import SafeAreaWrapper from '@/components/common/SafeAreaWrapper';
import WeeklyTimeline from '@/components/training/WeeklyTimeline';
import { mockUserProfile, mockTrainingSchedules, mockProgressStatistic } from '@/data/mockTrainingData';
import { getTrainingDayImages, getTrainingDayShapeImages } from '@/utils/trainingImageHelper';
import { mapGoalToVietnamese } from '@/utils/trainingHelpers';

// ====================================================================
// CONSTANTS & ASSETS
// ====================================================================

const PRIZE_ACTIVE = AppAssets.prizeActiveIcon;
const PRIZE_TODAY = AppAssets.prizeTodayIcon;
const PRIZE_NOT_ACTIVE = AppAssets.prizeNotActiveIcon;
const PERSONAL_TRAINING = AppAssets.personalTraining;

// ====================================================================
// HELPER FUNCTIONS
// ====================================================================

/**
 * Get week dates starting from Monday
 */
function getWeekDates(selectedDate: Date): Date[] {
    const weekday = selectedDate.getDay();
    const monday = new Date(selectedDate);
    monday.setDate(selectedDate.getDate() - (weekday === 0 ? 6 : weekday - 1));

    return Array.from({ length: 7 }, (_, i) => {
        const date = new Date(monday);
        date.setDate(monday.getDate() + i);
        return date;
    });
}

// ====================================================================
// MAIN COMPONENT
// ====================================================================

/**
 * Training Tab Screen
 * Active training schedule and sessions with mock data
 */
export default function TrainingScreen() {
    // [STATE] Component state
    const [selectedTab, setSelectedTab] = useState(0);
    const [selectedDayIndex, setSelectedDayIndex] = useState(new Date().getDay() - 1);
    const [isLoading, setIsLoading] = useState(true);

    // [ANIMATION] Tab animation values
    const tab0Scale = useRef(new Animated.Value(1)).current;
    const tab1Scale = useRef(new Animated.Value(0.95)).current;
    const tab0Opacity = useRef(new Animated.Value(1)).current;
    const tab1Opacity = useRef(new Animated.Value(0.7)).current;
    const contentSlide = useRef(new Animated.Value(0)).current;

    // [DATA] Các biến dữ liệu
    const today = new Date();
    const weekDates = getWeekDates(today);
    const selectedDay = today.getDay() - 1; // 0 = Monday, 6 = Sunday

    const user = mockUserProfile;
    const schedules = mockTrainingSchedules;
    const progressStatistic = mockProgressStatistic;
    const plan = user.trainingPlans?.[0];

    // Get training images
    const trainingDayImages = plan
        ? getTrainingDayImages(plan.name, plan.goals)
        : [];
    const trainingDayShapeImages = plan
        ? getTrainingDayShapeImages(plan.name, plan.goals)
        : [];

    // [EFFECT] Simulate loading data
    useEffect(() => {
        const timer = setTimeout(() => setIsLoading(false), 500);
        return () => clearTimeout(timer);
    }, []);

    // [EFFECT] Animate tab transitions
    useEffect(() => {
        Animated.parallel([
            // Tab 0 animations
            Animated.spring(tab0Scale, {
                toValue: selectedTab === 0 ? 1 : 0.95,
                useNativeDriver: true,
                friction: 8,
                tension: 40,
            }),
            Animated.timing(tab0Opacity, {
                toValue: selectedTab === 0 ? 1 : 0.7,
                duration: 200,
                useNativeDriver: true,
            }),
            // Tab 1 animations
            Animated.spring(tab1Scale, {
                toValue: selectedTab === 1 ? 1 : 0.95,
                useNativeDriver: true,
                friction: 8,
                tension: 40,
            }),
            Animated.timing(tab1Opacity, {
                toValue: selectedTab === 1 ? 1 : 0.7,
                duration: 200,
                useNativeDriver: true,
            }),
            // Content slide animation
            Animated.spring(contentSlide, {
                toValue: selectedTab,
                useNativeDriver: true,
                friction: 8,
                tension: 40,
            }),
        ]).start();
    }, [selectedTab]);

    // [RENDER] Loading State
    if (isLoading) {
        return (
            <SafeAreaWrapper backgroundColor={Colors.wWhite}>
                <View style={styles.loadingContainer}>
                    <Text style={styles.loadingText}>{AppStrings.loading}</Text>
                </View>
            </SafeAreaWrapper>
        );
    }

    return (
        <View style={styles.container}>
            <StatusBar barStyle="dark-content" backgroundColor="transparent" translucent />

            <ImageBackground
                source={AppAssets.mainBackground}
                style={styles.background}
                resizeMode="cover"
            >
                <SafeAreaWrapper backgroundColor="transparent">
                    <ScrollView
                        style={styles.scrollView}
                        contentContainerStyle={styles.scrollContent}
                        showsVerticalScrollIndicator={false}
                    >
                        {/* --- 1. WEEKLY MEDAL PROGRESS --- */}
                        <View style={styles.medalContainer}>
                            {weekDates.map((date, index) => {
                                const dayIndex = date.getDate() - 1;
                                const isCompleted =
                                    index < selectedDay &&
                                    progressStatistic.currentMonthCompletions[dayIndex];
                                const isToday = index === selectedDay;
                                const isTodayCompleted =
                                    isToday && progressStatistic.currentMonthCompletions[dayIndex];

                                // Determine medal appearance
                                let iconSource = PRIZE_NOT_ACTIVE;
                                let bgColor = 'transparent';
                                let textColor = '#b6abab';

                                if (isTodayCompleted) {
                                    iconSource = PRIZE_ACTIVE;
                                    bgColor = Colors.prizeSelected;
                                    textColor = Colors.bNormal;
                                } else if (isToday) {
                                    iconSource = PRIZE_TODAY;
                                    bgColor = Colors.prizeSelected;
                                    textColor = Colors.bNormal;
                                } else if (isCompleted) {
                                    iconSource = PRIZE_ACTIVE;
                                    bgColor = 'transparent';
                                    textColor = Colors.bNormal;
                                }

                                return (
                                    <View
                                        key={index}
                                        style={[
                                            styles.medalItem,
                                            { backgroundColor: bgColor },
                                        ]}
                                    >
                                        <Image source={iconSource} style={styles.medalIcon} resizeMode='contain' />
                                        <Text style={[styles.medalText, { color: textColor }]}>
                                            {date.getDate()}
                                        </Text>
                                    </View>
                                );
                            })}
                        </View>

                        {/* --- 2. TOGGLE TABS --- */}
                        <View style={styles.tabContainer}>
                            <TouchableOpacity
                                onPress={() => setSelectedTab(0)}
                                activeOpacity={0.7}
                                style={{ flex: 1 }}
                            >
                                <Animated.View
                                    style={[
                                        styles.tab,
                                        selectedTab === 0 && styles.tabActive,
                                        {
                                            transform: [{ scale: tab0Scale }],
                                            opacity: tab0Opacity,
                                        },
                                    ]}
                                >
                                    <Text
                                        style={[
                                            styles.tabText,
                                            selectedTab === 0 && styles.tabTextActive,
                                        ]}
                                    >
                                        {AppStrings.trainingSuggestedPlan}
                                    </Text>
                                </Animated.View>
                            </TouchableOpacity>
                            <TouchableOpacity
                                onPress={() => setSelectedTab(1)}
                                activeOpacity={0.7}
                                style={{ flex: 1 }}
                            >
                                <Animated.View
                                    style={[
                                        styles.tab,
                                        selectedTab === 1 && styles.tabActive,
                                        {
                                            transform: [{ scale: tab1Scale }],
                                            opacity: tab1Opacity,
                                        },
                                    ]}
                                >
                                    <Text
                                        style={[
                                            styles.tabText,
                                            selectedTab === 1 && styles.tabTextActive,
                                        ]}
                                    >
                                        {AppStrings.trainingYourChoice}
                                    </Text>
                                </Animated.View>
                            </TouchableOpacity>
                        </View>

                        {/* --- 3. TAB CONTENT --- */}
                        {selectedTab === 0 ? (
                            <SuggestedPlanTab
                                plan={plan}
                                schedules={schedules}
                                weekDates={weekDates}
                                selectedDayIndex={selectedDayIndex}
                                selectedDay={selectedDay}
                                trainingDayImages={trainingDayImages}
                                trainingDayShapeImages={trainingDayShapeImages}
                                onDayChange={setSelectedDayIndex}
                            />
                        ) : (
                            <YourChoiceTab />
                        )}
                    </ScrollView>
                </SafeAreaWrapper>
            </ImageBackground>
        </View>
    );
}

// ====================================================================
// SUB-COMPONENTS
// ====================================================================

// --- SUGGESTED PLAN TAB ---
interface SuggestedPlanTabProps {
    plan: any;
    schedules: any[];
    weekDates: Date[];
    selectedDayIndex: number;
    selectedDay: number;
    trainingDayImages: any[];
    trainingDayShapeImages: any[];
    onDayChange: (index: number) => void;
}

function SuggestedPlanTab({
    plan,
    schedules,
    weekDates,
    selectedDayIndex,
    selectedDay,
    trainingDayImages,
    trainingDayShapeImages,
    onDayChange,
}: SuggestedPlanTabProps) {
    // [ANIMATION] Card animations
    const cardAnimations = React.useRef(
        schedules.map(() => ({
            scale: new Animated.Value(1),
            opacity: new Animated.Value(1),
            translateY: new Animated.Value(0),
        }))
    ).current;

    // [EFFECT] Animate cards on selection change
    React.useEffect(() => {
        schedules.forEach((_, index) => {
            const isSelected = index === selectedDayIndex;

            Animated.parallel([
                // Scale animation
                Animated.spring(cardAnimations[index].scale, {
                    toValue: isSelected ? 1 : 0.95,
                    useNativeDriver: true,
                    friction: 8,
                    tension: 40,
                }),
                // Opacity animation
                Animated.timing(cardAnimations[index].opacity, {
                    toValue: isSelected ? 1 : 0.85,
                    duration: 200,
                    useNativeDriver: true,
                }),
                // Slide animation (selected cards slide in slightly)
                Animated.spring(cardAnimations[index].translateY, {
                    toValue: isSelected ? 0 : 5,
                    useNativeDriver: true,
                    friction: 8,
                    tension: 40,
                }),
            ]).start();
        });
    }, [selectedDayIndex]);

    if (!plan) return null;

    return (
        <View style={styles.tabContent}>
            {/* Goal and Plan Tag */}
            <View style={styles.goalTag}>
                <Text style={styles.goalText}>
                    {mapGoalToVietnamese(plan.goals)}  •  {plan.name}
                </Text>
            </View>

            {/* Weekly Timeline and Training Days */}
            <View style={styles.timelineContainer}>
                <WeeklyTimeline
                    selectedIndex={selectedDayIndex}
                    onChanged={onDayChange}
                />

                <View style={styles.daysContainer}>
                    {schedules.map((schedule, index) => {
                        const isSelected = index === selectedDayIndex;
                        const date = weekDates[index];

                        return (
                            <Animated.View
                                key={index}
                                style={[
                                    styles.dayWrapper,
                                    {
                                        transform: [
                                            { scale: cardAnimations[index].scale },
                                            { translateY: cardAnimations[index].translateY },
                                        ],
                                        opacity: cardAnimations[index].opacity,
                                    },
                                ]}
                            >
                                {isSelected && (
                                    <SelectedDayCard
                                        schedule={schedule}
                                        index={index}
                                        date={date}
                                        selectedDay={selectedDay}
                                        trainingDayImage={trainingDayImages[index]}
                                        trainingDayShapeImage={trainingDayShapeImages[index]}
                                    />
                                )}
                                {!isSelected && (
                                    <TouchableOpacity
                                        onPress={() => onDayChange(index)}
                                        style={styles.unselectedCard}
                                        activeOpacity={0.7}
                                    >
                                        <View style={styles.cardContent}>
                                            <View>
                                                <Text style={styles.dateText}>
                                                    {date.getDate()}/{date.getMonth() + 1}
                                                </Text>
                                                <Text style={styles.dayNumberText}>
                                                    {AppStrings.trainingDay} {index + 1}
                                                </Text>
                                                <Text style={styles.durationText}>
                                                    {schedule.duration || AppStrings.trainingRestDay}
                                                </Text>
                                            </View>
                                            <Image
                                                source={trainingDayShapeImages[index]}
                                                style={[
                                                    styles.shapeImage,
                                                    !schedule.duration && styles.shapeImageRestDay,
                                                ]}
                                                resizeMode='contain'
                                            />
                                        </View>
                                    </TouchableOpacity>
                                )}
                            </Animated.View>
                        );
                    })}
                </View>
            </View>
        </View>
    );
}

// --- SELECTED DAY CARD ---
interface SelectedDayCardProps {
    schedule: any;
    index: number;
    date: Date;
    selectedDay: number;
    trainingDayImage: any;
    trainingDayShapeImage: any;
}

function SelectedDayCard({
    schedule,
    index,
    date,
    selectedDay,
    trainingDayImage,
    trainingDayShapeImage,
}: SelectedDayCardProps) {
    // Calculate relative time text
    const dayDiff = Math.abs(selectedDay - index);
    let relativeTimeText: string = AppStrings.trainingToday;

    if (index !== selectedDay) {
        if (index > selectedDay) {
            relativeTimeText =
                dayDiff === 1
                    ? AppStrings.trainingNext
                    : `${dayDiff} ${AppStrings.trainingDaysAhead}`;
        } else {
            relativeTimeText = `${dayDiff} ${AppStrings.trainingDaysAgo}`;
        }
    }

    // Determine button state
    const isPastDay = index < selectedDay;
    const isToday = index === selectedDay;
    const isRestDay = !schedule.duration;

    let buttonText: string = AppStrings.trainingNotStarted;
    let buttonColor: string = Colors.bLightActive;
    let buttonAction = () => { };

    if (isPastDay) {
        buttonText = AppStrings.trainingCompleted;
        buttonColor = Colors.moreLighter;
    } else if (isToday) {
        if (isRestDay) {
            buttonText = AppStrings.trainingCompleted;
            buttonColor = Colors.moreLighter;
        } else {
            buttonText = AppStrings.trainingStartTraining;
            buttonColor = Colors.bNormal;
            buttonAction = () => {
                // TODO: Navigate to training detail
                console.log('Navigate to training detail');
            };
        }
    }

    return (
        <View style={styles.selectedDayContainer}>
            <Text style={styles.relativeTimeText}>{relativeTimeText}</Text>

            <View style={styles.selectedCard}>
                <View style={styles.selectedCardContent}>
                    <View>
                        <Text style={styles.selectedDateText}>
                            {date.getDate()}/{date.getMonth() + 1}
                        </Text>
                        <Text style={styles.selectedDayNumberText}>
                            {AppStrings.trainingDay} {index + 1}
                        </Text>
                        <Text style={styles.selectedDurationText}>
                            {schedule.duration || AppStrings.trainingRestDay}
                        </Text>
                    </View>
                    <Image
                        source={trainingDayShapeImage}
                        style={[
                            styles.selectedShapeImage,
                            !schedule.duration && styles.selectedShapeImageRestDay,
                        ]}
                        resizeMode='contain'
                    />
                </View>

                <TouchableOpacity
                    style={[styles.actionButton, { backgroundColor: buttonColor }]}
                    onPress={buttonAction}
                    activeOpacity={0.7}
                >
                    <Text style={styles.buttonText}>{buttonText}</Text>
                </TouchableOpacity>
            </View>

            {/* Show next day preview if not last day */}
            {index < 6 && (
                <Text style={styles.nextDayText}>
                    {index + 1 === selectedDay
                        ? AppStrings.trainingToday
                        : index + 1 > selectedDay
                            ? `${index + 1 - selectedDay} ${AppStrings.trainingDaysAhead}`
                            : `${selectedDay - index - 1} ${AppStrings.trainingDaysAgo}`}
                </Text>
            )}
        </View>
    );
}

// --- YOUR CHOICE TAB (EMPTY STATE) ---
function YourChoiceTab() {
    return (
        <View style={styles.emptyStateContainer}>
            <Image source={PERSONAL_TRAINING} style={styles.emptyStateImage} />
            <Text style={styles.emptyStateText}>
                {AppStrings.trainingNoTrainingPlan}
            </Text>
            <TouchableOpacity style={styles.addButton} activeOpacity={0.7}>
                <Text style={styles.addButtonText}>{AppStrings.trainingAddNew}</Text>
                <Text style={styles.addButtonIcon}>+</Text>
            </TouchableOpacity>
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
    background: {
        flex: 1,
    },
    scrollView: {
        flex: 1,
    },
    scrollContent: {
        paddingHorizontal: Dims.paddingM,
        paddingVertical: Dims.spacingSM,
        paddingBottom: Dims.size104,
    },

    // Loading State
    loadingContainer: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
    },
    loadingText: {
        fontSize: Dims.textSizeM,
        color: Colors.dark,
    },

    // --- 1. WEEKLY MEDAL PROGRESS ---
    medalContainer: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        backgroundColor: Colors.wWhite,
        borderRadius: Dims.borderRadius,
        padding: Dims.spacingSM,
        marginTop: Dims.spacingS,
        marginBottom: Dims.spacingM,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.05,
        shadowRadius: 8,
        elevation: 2,
    },
    medalItem: {
        width: Dims.size48,
        height: Dims.size72,
        borderRadius: Dims.borderRadiusSmall,
        justifyContent: 'center',
        alignItems: 'center',
    },
    medalIcon: {
        width: Dims.size32,
        height: Dims.size32,
        marginBottom: Dims.size4,
    },
    medalText: {
        fontSize: Dims.textSizeS,
        fontWeight: '600',
    },

    // --- 2. TOGGLE TABS ---
    tabContainer: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        gap: Dims.spacingS,
        marginBottom: Dims.spacingL,
    },
    tab: {
        flex: 1,
        height: Dims.size40,
        backgroundColor: Colors.bLightActive,
        borderRadius: Dims.borderRadiusSmall,
        justifyContent: 'center',
        alignItems: 'center',
    },
    tabActive: {
        height: Dims.size48,
        backgroundColor: Colors.bNormal,
    },
    tabText: {
        fontSize: Dims.textSizeS,
        color: Colors.dark,
        fontWeight: 'bold',
    },
    tabTextActive: {
        color: Colors.wWhite,
    },

    // --- 3. TAB CONTENT ---
    tabContent: {
        flex: 1,
    },
    goalTag: {
        backgroundColor: Colors.bNormal,
        borderRadius: Dims.borderRadiusSmall,
        paddingHorizontal: Dims.spacingSM,
        paddingVertical: Dims.paddingS + 2,
        marginBottom: Dims.spacingML,
    },
    goalText: {
        color: Colors.wWhite,
        fontSize: Dims.textSizeM,
        fontWeight: 'bold',
    },

    // Timeline Container
    timelineContainer: {
        flexDirection: 'row',
        gap: Dims.spacingM,
    },
    daysContainer: {
        flex: 1,
        gap: Dims.paddingM,
    },
    dayWrapper: {
        minHeight: Dims.size104,
    },

    // Unselected Day Card
    unselectedCard: {
        backgroundColor: Colors.wWhite,
        borderRadius: Dims.borderRadius,
        paddingHorizontal: Dims.spacingSM,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.05,
        shadowRadius: 8,
        elevation: 2,
    },
    cardContent: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
    },
    dateText: {
        fontSize: Dims.textSizeS,
        color: Colors.bNormal,
        marginBottom: Dims.size4,
    },
    dayNumberText: {
        fontSize: Dims.textSizeL,
        color: Colors.dark,
        fontWeight: 'bold',
        marginBottom: Dims.size4,
    },
    durationText: {
        fontSize: Dims.textSizeS,
        color: Colors.bNormal,
    },
    shapeImage: {
        width: Dims.size120,
        height: Dims.size104,
    },
    shapeImageRestDay: {
        width: Dims.size80,
        height: Dims.size72,
        marginVertical: Dims.spacingM,
    },

    // Selected Day Card
    selectedDayContainer: {
        marginBottom: Dims.spacingXS - Dims.spacingM,
    },
    relativeTimeText: {
        fontSize: Dims.textSizeM,
        color: Colors.dark,
        fontWeight: 'bold',
        marginBottom: Dims.paddingS,
        paddingTop: Dims.paddingS,
    },
    selectedCard: {
        backgroundColor: Colors.wWhite,
        borderRadius: Dims.borderRadius,
        paddingHorizontal: Dims.spacingSM,
        paddingVertical: Dims.spacingSM,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.05,
        shadowRadius: 8,
        elevation: 2,
    },
    selectedCardContent: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        marginBottom: Dims.spacingSM,
    },
    selectedDateText: {
        fontSize: Dims.textSizeM,
        color: Colors.bNormal,
        marginBottom: Dims.size4,
        marginTop: Dims.spacingS,
    },
    selectedDayNumberText: {
        fontSize: Dims.textSizeL,
        color: Colors.dark,
        fontWeight: 'bold',
        marginBottom: Dims.size4,
    },
    selectedDurationText: {
        fontSize: Dims.textSizeS,
        color: Colors.bNormal,
    },
    selectedShapeImage: {
        width: Dims.size120,
        height: Dims.size80,
    },
    selectedShapeImageRestDay: {
        marginTop: Dims.spacingXS,
        width: Dims.size80,
        height: Dims.size64,
    },
    actionButton: {
        height: Dims.size40,
        borderRadius: Dims.borderRadiusSmall,
        justifyContent: 'center',
        alignItems: 'center',
    },
    buttonText: {
        fontSize: Dims.textSizeS,
        color: Colors.wWhite,
        fontWeight: '600',
    },
    nextDayText: {
        fontSize: Dims.textSizeM,
        color: Colors.dark,
        fontWeight: 'bold',
        marginTop: Dims.paddingL,
    },

    // Empty State
    emptyStateContainer: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        paddingVertical: Dims.spacingXXL,
    },
    emptyStateImage: {
        width: 160,
        height: 160,
        marginBottom: Dims.spacingSM,
    },
    emptyStateText: {
        fontSize: Dims.textSizeS,
        color: Colors.dark,
        marginBottom: Dims.spacingSM,
    },
    addButton: {
        flexDirection: 'row',
        backgroundColor: Colors.bNormal,
        paddingHorizontal: Dims.paddingM,
        paddingVertical: Dims.paddingM,
        borderRadius: Dims.borderRadiusLarge,
        alignItems: 'center',
        gap: Dims.spacingS,
        minWidth: Dims.size144,
        justifyContent: 'center',
    },
    addButtonText: {
        color: Colors.wWhite,
        fontSize: Dims.textSizeM,
        fontWeight: 'bold',
    },
    addButtonIcon: {
        color: Colors.wWhite,
        fontSize: Dims.iconSizeL,
        fontWeight: 'bold',
    },
});
