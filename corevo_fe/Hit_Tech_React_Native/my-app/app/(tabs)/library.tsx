import React, { useState, useRef, useEffect } from 'react';
import {
    View,
    Animated,
    Text,
    StyleSheet,
    ScrollView,
    TouchableOpacity,
    ImageBackground,
    Image,
    ActivityIndicator,
    Alert,
} from 'react-native';
import { useRouter } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { AppAssets } from '@/constants/AppAssets';
import { AppStrings } from '@/constants/AppStrings';
import { trainingService } from '@/services/api/trainingService';
import type { TrainingPlan } from '@/types/training';

// Interface for exercise category
interface ExerciseCategory {
    id: number;
    name: string;
    image: any;
    type: 'muscle' | 'type';
    queryName: string;
}

// Exercise categories matching Flutter's targetMuscleCategory
const EXERCISE_CATEGORIES: ExerciseCategory[] = [
    { id: 0, name: 'Ngực', image: AppAssets.chestCategory, type: 'muscle', queryName: 'Chest' },
    { id: 1, name: 'Lưng', image: AppAssets.backCategory, type: 'muscle', queryName: 'Back' },
    { id: 2, name: 'Vai', image: AppAssets.shouldersCategory, type: 'muscle', queryName: 'Shoulders' },
    { id: 3, name: 'Tay trước', image: AppAssets.bicepCategory, type: 'muscle', queryName: 'Biceps' },
    { id: 4, name: 'Tay sau', image: AppAssets.tricepCategory, type: 'muscle', queryName: 'Triceps' },
    { id: 5, name: 'Bụng', image: AppAssets.absCategory, type: 'muscle', queryName: 'Abs' },
    { id: 6, name: 'Mông', image: AppAssets.gluteCategory, type: 'muscle', queryName: 'Glutes' },
    { id: 7, name: 'Đùi trước', image: AppAssets.quadsCategory, type: 'muscle', queryName: 'Quads' },
    { id: 8, name: 'Đùi sau', image: AppAssets.hamstringCategory, type: 'muscle', queryName: 'Hamstrings' },
    { id: 9, name: 'Cardio', image: AppAssets.cardioCategory, type: 'type', queryName: 'Cardio' },
    { id: 10, name: 'Yoga', image: AppAssets.yogaCategory, type: 'type', queryName: 'Yoga' },
    { id: 11, name: 'Calisthenic', image: AppAssets.calisthenicCategory, type: 'type', queryName: 'Calisthenic' },
];


/**
 * Training Library Screen
 * Browse training plans and exercises
 * Converted from Flutter training_library_screen.dart
 */
export default function LibraryScreen() {
    const router = useRouter();
    const [selectedIndex, setSelectedIndex] = useState(0);
    const [isLoading, setIsLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [selectedFilter, setSelectedFilter] = useState<string | null>(null);
    const [trainingPlansByType, setTrainingPlansByType] = useState<TrainingPlan[]>([]);

    // State for training plans grouped by goals
    const [trainingPlans, setTrainingPlans] = useState<Record<string, TrainingPlan[]>>({
        loseFat: [],
        gainWeight: [],
        gainMuscle: [],
        maintainBody: [],
        increaseEndurance: [],
        improveCardiovascular: [],
        stressRelief: [],
        increaseHeight: [],
    });

    // Animation values for tabs
    const tab0FontSize = useRef(new Animated.Value(selectedIndex === 0 ? 1 : 0)).current;
    const tab1FontSize = useRef(new Animated.Value(selectedIndex === 1 ? 1 : 0)).current;
    const tab0Indicator = useRef(new Animated.Value(selectedIndex === 0 ? 1 : 0)).current;
    const tab1Indicator = useRef(new Animated.Value(selectedIndex === 1 ? 1 : 0)).current;

    // Fetch training plans on mount
    useEffect(() => {
        fetchTrainingPlans();
    }, []);

    // Animate tabs
    useEffect(() => {
        Animated.parallel([
            Animated.timing(tab0FontSize, {
                toValue: selectedIndex === 0 ? 1 : 0,
                duration: 250,
                useNativeDriver: false,
            }),
            Animated.timing(tab1FontSize, {
                toValue: selectedIndex === 1 ? 1 : 0,
                duration: 250,
                useNativeDriver: false,
            }),
            Animated.timing(tab0Indicator, {
                toValue: selectedIndex === 0 ? 1 : 0,
                duration: 250,
                useNativeDriver: false,
            }),
            Animated.timing(tab1Indicator, {
                toValue: selectedIndex === 1 ? 1 : 0,
                duration: 250,
                useNativeDriver: false,
            }),
        ]).start();
    }, [selectedIndex]);

    const fetchTrainingPlans = async () => {
        try {
            setIsLoading(true);
            setError(null);

            const responseAll = await trainingService.getAllTrainingPlan(1, 23);

            if (responseAll.status === 'SUCCESS' && responseAll.data.items) {
                const items = responseAll.data.items;
                console.log('Total items fetched:', items.length);

                // Initialize empty groupings
                const grouped: Record<string, TrainingPlan[]> = {
                    loseFat: [],
                    gainWeight: [],
                    gainMuscle: [],
                    maintainBody: [],
                    increaseEndurance: [],
                    improveCardiovascular: [],
                    stressRelief: [],
                    increaseHeight: [],
                };

                // Group plans dynamically by their "goals" property
                items.forEach((item: TrainingPlan) => {
                    const goal = item.goals?.toLowerCase() || '';

                    if (goal.includes('lose fat') || goal.includes('weight loss')) {
                        grouped.loseFat.push(item);
                    } else if (goal.includes('gain weight')) {
                        grouped.gainWeight.push(item);
                    } else if (goal.includes('gain muscle') || goal.includes('build muscle')) {
                        grouped.gainMuscle.push(item);
                    } else if (goal.includes('maintain') || goal.includes('stay fit')) {
                        grouped.maintainBody.push(item);
                    } else if (goal.includes('endurance')) {
                        grouped.increaseEndurance.push(item);
                    } else if (goal.includes('cardio')) {
                        grouped.improveCardiovascular.push(item);
                    } else if (goal.includes('stress') || goal.includes('relief')) {
                        grouped.stressRelief.push(item);
                    } else if (goal.includes('height')) {
                        grouped.increaseHeight.push(item);
                    } else {
                        // Default to lose fat if no match or add to a general list if needed
                        // For now, let's just log it if it doesn't match
                        console.warn(`Unmatched goal for plan ${item.id}: ${item.goals}`);
                    }
                });

                setTrainingPlans(grouped);
            } else {
                setError('Không thể tải danh sách kế hoạch');
            }
        } catch (err) {
            console.error('Error fetching training plans:', err);
            setError('Đã xảy ra lỗi khi tải dữ liệu');
        } finally {
            setIsLoading(false);
        }
    };

    const fetchPlansByType = async (type: string) => {
        try {
            setIsLoading(true);
            setError(null);
            const response = await trainingService.getTrainingPlanByType(type, 1, 23);

            if (response.status === 'SUCCESS' && response.data?.items) {
                setTrainingPlansByType(response.data.items || []);
            } else {
                setError('Không thể tải kế hoạch theo loại');
            }
        } catch (err) {
            console.error('Error fetching plans by type:', err);
            setError('Đã xảy ra lỗi khi tải dữ liệu');
        } finally {
            setIsLoading(false);
        }
    };

    // Call fetchPlansByType when selectedFilter changes
    useEffect(() => {
        if (selectedFilter) {
            fetchPlansByType(selectedFilter);
        }
    }, [selectedFilter]);

    const handleSearchPress = () => {
        // TODO: Navigate to search screen
        Alert.alert('Tìm kiếm', 'Tính năng tìm kiếm đang phát triển');
    };

    const handlePlanPress = (plan: TrainingPlan) => {
        router.push(`/library/training-plan-detail?id=${plan.id}`);
    };

    const handleCategoryPress = (category: ExerciseCategory) => {
        if (category.type === 'muscle') {
            router.push(`/library/exercise-list?muscle=${category.queryName}&name=${category.name}`);
        } else {
            router.push(`/library/exercise-list?type=${category.queryName}&name=${category.name}`);
        }
    };

    const handleRetry = () => {
        fetchTrainingPlans();
    };

    if (isLoading) {
        return (
            <View style={styles.loadingContainer}>
                <Text>Đang tải...</Text>
            </View>
        );
    }

    return (
        <View style={styles.container}>
            <ImageBackground
                source={AppAssets.libraryBackground1}
                style={styles.backgroundImage}
                resizeMode="cover"
            >
                <View style={styles.content}>
                    {/* Tabs */}
                    <View style={styles.tabContainer}>
                        <TouchableOpacity
                            style={styles.tabButton}
                            onPress={() => setSelectedIndex(0)}
                            activeOpacity={0.7}
                        >
                            <Animated.Text
                                style={[
                                    styles.tabText,
                                    {
                                        fontSize: tab0FontSize.interpolate({
                                            inputRange: [0, 1],
                                            outputRange: [Dims.textSizeM, Dims.textSizeXL],
                                        }),
                                    },
                                ]}
                            >
                                {AppStrings.libraryTabPlans}
                            </Animated.Text>
                            <Animated.View
                                style={[
                                    styles.tabIndicator,
                                    {
                                        width: tab0Indicator.interpolate({
                                            inputRange: [0, 1],
                                            outputRange: [0, Dims.size80],
                                        }),
                                    },
                                ]}
                            />
                        </TouchableOpacity>

                        <TouchableOpacity
                            style={styles.tabButton}
                            onPress={() => setSelectedIndex(1)}
                            activeOpacity={0.7}
                        >
                            <Animated.Text
                                style={[
                                    styles.tabText,
                                    {
                                        fontSize: tab1FontSize.interpolate({
                                            inputRange: [0, 1],
                                            outputRange: [Dims.textSizeM, Dims.textSizeXL],
                                        }),
                                    },
                                ]}
                            >
                                {AppStrings.libraryTabExercises}
                            </Animated.Text>
                            <Animated.View
                                style={[
                                    styles.tabIndicator,
                                    {
                                        width: tab1Indicator.interpolate({
                                            inputRange: [0, 1],
                                            outputRange: [0, Dims.size80],
                                        }),
                                    },
                                ]}
                            />
                        </TouchableOpacity>
                    </View>

                    {/* Search Bar */}
                    <TouchableOpacity
                        style={styles.searchBar}
                        onPress={handleSearchPress}
                        activeOpacity={0.7}
                    >
                        <Ionicons
                            name="search"
                            size={Dims.iconSizeL}
                            color={Colors.lightHover}
                        />
                        <Text style={styles.searchPlaceholder}>
                            {AppStrings.librarySearchPlaceholder}
                        </Text>
                    </TouchableOpacity>

                    {/* Content */}
                    {isLoading ? (
                        <View style={styles.centerContainer}>
                            <ActivityIndicator size="large" color={Colors.bNormal} />
                            <Text style={styles.loadingText}>{AppStrings.loadingText}</Text>
                        </View>
                    ) : error ? (
                        <View style={styles.centerContainer}>
                            <Text style={styles.errorText}>{error}</Text>
                            <TouchableOpacity
                                style={styles.retryButton}
                                onPress={handleRetry}
                                activeOpacity={0.7}
                            >
                                <Text style={styles.retryButtonText}>{AppStrings.retry}</Text>
                            </TouchableOpacity>
                        </View>
                    ) : selectedIndex === 0 ? (
                        <TrainingPlansTab
                            plans={trainingPlans}
                            onPlanPress={handlePlanPress}
                        />
                    ) : selectedFilter ? (
                        // If a filter is selected, show plans for that type
                        // This matches the user's request to call getTrainingPlanByType
                        <ScrollView
                            style={styles.scrollView}
                            contentContainerStyle={styles.plansContent}
                            showsVerticalScrollIndicator={false}
                        >
                            <TouchableOpacity
                                style={styles.backToCategories}
                                onPress={() => setSelectedFilter(null)}
                            >
                                <Ionicons name="arrow-back" size={24} color={Colors.dark} />
                                <Text style={styles.backText}>Quay lại danh mục</Text>
                            </TouchableOpacity>

                            <View style={styles.plansListVertical}>
                                {trainingPlansByType.map((plan) => (
                                    <TrainingPlanCard
                                        key={plan.id}
                                        plan={plan}
                                        onPress={() => handlePlanPress(plan)}
                                        isVertical
                                    />
                                ))}
                                {trainingPlansByType.length === 0 && (
                                    <Text style={styles.emptyText}>Không có kế hoạch nào cho mục này</Text>
                                )}
                            </View>
                            <View style={styles.bottomSpacer} />
                        </ScrollView>
                    ) : (
                        <ExercisesTab
                            categories={EXERCISE_CATEGORIES}
                            onCategoryPress={handleCategoryPress}
                        />
                    )}
                </View>
            </ImageBackground>
        </View>
    );
}

/**
 * Training Plans Tab Component
 */
interface TrainingPlansTabProps {
    plans: Record<string, TrainingPlan[]>;
    onPlanPress: (plan: TrainingPlan) => void;
}

function TrainingPlansTab({ plans, onPlanPress }: TrainingPlansTabProps) {
    const sections = [
        { key: 'loseFat', title: AppStrings.libraryGoalLoseFat },
        { key: 'gainWeight', title: AppStrings.libraryGoalGainWeight },
        { key: 'gainMuscle', title: AppStrings.libraryGoalGainMuscle },
        { key: 'maintainBody', title: AppStrings.libraryGoalMaintainBody },
        { key: 'increaseEndurance', title: AppStrings.libraryGoalIncreaseEndurance },
        {
            key: 'improveCardiovascular',
            title: AppStrings.libraryGoalImproveCardiovascular,
        },
        { key: 'stressRelief', title: AppStrings.libraryGoalStressRelief },
        { key: 'increaseHeight', title: AppStrings.libraryGoalIncreaseHeight },
    ];

    return (
        <ScrollView
            style={styles.scrollView}
            contentContainerStyle={styles.plansContent}
            showsVerticalScrollIndicator={false}
        >
            {sections.map((section) => (
                <View key={section.key} style={styles.planSection}>
                    <Text style={styles.sectionTitle}>{section.title}</Text>
                    <ScrollView
                        horizontal
                        showsHorizontalScrollIndicator={false}
                        contentContainerStyle={styles.plansList}
                    >
                        {plans[section.key]?.map((plan) => (
                            <TrainingPlanCard
                                key={plan.id}
                                plan={plan}
                                onPress={() => onPlanPress(plan)}
                            />
                        ))}
                    </ScrollView>
                </View>
            ))}
            <View style={styles.bottomSpacer} />
        </ScrollView>
    );
}

/**
 * Training Plan Card Component
 */
interface TrainingPlanCardProps {
    plan: TrainingPlan;
    onPress: () => void;
    isVertical?: boolean;
}

function TrainingPlanCard({ plan, onPress, isVertical }: TrainingPlanCardProps) {
    return (
        <View style={[styles.planCard, isVertical && styles.planCardVertical]}>
            <ImageBackground
                source={AppAssets.trainingPlan1}
                style={styles.planCardBackground}
                imageStyle={styles.planCardImage}
            >
                {/* Gradient Overlay */}
                <View style={styles.planCardGradient} />

                {/* Content */}
                <View style={styles.planCardContent}>
                    <View style={styles.planCardInfo}>
                        <View style={styles.planCardTextContainer}>
                            <Text style={styles.planCardTitle} numberOfLines={1}>
                                {plan.name}
                            </Text>
                            <Text style={styles.planCardDescription} numberOfLines={2}>
                                {plan.description}
                            </Text>
                        </View>
                        <TouchableOpacity
                            style={styles.planStartButton}
                            onPress={onPress}
                            activeOpacity={0.8}
                        >
                            <Text style={styles.planStartButtonText}>
                                {AppStrings.libraryStartButton}
                            </Text>
                        </TouchableOpacity>
                    </View>
                </View>
            </ImageBackground>
        </View>
    );
}

/**
 * Exercises Tab Component
 */
interface ExercisesTabProps {
    categories: ExerciseCategory[];
    onCategoryPress: (category: ExerciseCategory) => void;
}

function ExercisesTab({ categories, onCategoryPress }: ExercisesTabProps) {
    return (
        <ScrollView
            style={styles.scrollView}
            contentContainerStyle={styles.exercisesContent}
            showsVerticalScrollIndicator={false}
        >
            {categories.map((category) => (
                <CategoryCard
                    key={category.id}
                    category={category}
                    onPress={() => onCategoryPress(category)}
                />
            ))}
            <View style={styles.bottomSpacer} />
        </ScrollView>
    );
}

/**
 * Category Card Component
 */
interface CategoryCardProps {
    category: ExerciseCategory;
    onPress: () => void;
}

function CategoryCard({ category, onPress }: CategoryCardProps) {
    return (
        <TouchableOpacity
            style={styles.categoryCard}
            onPress={onPress}
            activeOpacity={0.8}
        >
            <ImageBackground
                source={category.image}
                style={styles.categoryCardBackground}
                imageStyle={styles.categoryCardImage}
            >
                <View style={styles.categoryCardContent}>
                    <Text style={styles.categoryCardTitle}>{category.name}</Text>
                </View>
            </ImageBackground>
        </TouchableOpacity>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: Colors.bLight,
    },
    backgroundImage: {
        flex: 1,
        width: '100%',
        height: '100%',
    },
    loadingContainer: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: Colors.bLight,
    },
    content: {
        flex: 1,
        paddingTop: Dims.spacingHuge,
    },

    // Tabs
    tabContainer: {
        flexDirection: 'row',
        justifyContent: 'center',
        marginBottom: Dims.spacingL,
    },
    tabButton: {
        alignItems: 'center',
        marginHorizontal: Dims.spacingML / 2,
    },
    tabText: {
        fontWeight: 'bold',
        color: Colors.dark,
    },
    tabIndicator: {
        marginTop: Dims.paddingXS,
        height: Dims.size4,
        backgroundColor: Colors.dark,
        borderRadius: Dims.borderRadiusLarge,
    },

    // Search Bar
    searchBar: {
        flexDirection: 'row',
        alignItems: 'center',
        backgroundColor: '#D3EDFF',
        borderRadius: Dims.borderRadiusLarge,
        paddingHorizontal: Dims.paddingM,
        height: Dims.size48,
        marginHorizontal: Dims.paddingM,
        marginBottom: Dims.spacingXL,
    },
    searchPlaceholder: {
        fontSize: Dims.textSizeS,
        color: Colors.lightHover,
        marginLeft: Dims.spacingS,
    },

    // Center Container (for loading/error states)
    centerContainer: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        paddingHorizontal: Dims.paddingL,
    },
    loadingText: {
        marginTop: Dims.spacingM,
        fontSize: Dims.textSizeM,
        color: Colors.dark,
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

    // Scroll View
    scrollView: {
        flex: 1,
    },

    // Training Plans Tab
    plansContent: {
        paddingTop: Dims.spacingSM,
        paddingBottom: Dims.spacingL,
    },
    planSection: {
        marginBottom: Dims.spacingML,
    },
    sectionTitle: {
        fontSize: Dims.textSizeM,
        fontWeight: '500',
        color: Colors.dark,
        marginLeft: Dims.paddingM,
        marginBottom: Dims.spacingS,
    },
    plansList: {
        paddingLeft: Dims.paddingM,
    },

    // Training Plan Card
    planCard: {
        width: Dims.size304,
        height: Dims.size200,
        marginRight: Dims.paddingM,
    },
    planCardVertical: {
        width: 'auto',
        marginHorizontal: Dims.paddingM,
        marginBottom: Dims.spacingML,
    },
    planCardBackground: {
        flex: 1,
        width: '100%',
        height: '100%',
    },
    planCardImage: {
        borderRadius: Dims.borderRadiusLarge,
    },
    planCardGradient: {
        position: 'absolute',
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        borderRadius: Dims.borderRadiusLarge,
    },
    planCardContent: {
        flex: 1,
        padding: Dims.paddingM,
        justifyContent: 'flex-end',
    },
    planCardInfo: {
        flexDirection: 'row',
        alignItems: 'flex-end',
        justifyContent: 'space-between',
    },
    planCardTextContainer: {
        flex: 1,
        marginRight: Dims.spacingS,
    },
    planCardTitle: {
        fontSize: Dims.textSizeM,
        fontWeight: 'bold',
        color: Colors.wWhite,
        marginBottom: Dims.size4,
    },
    planCardDescription: {
        fontSize: Dims.textSizeXS,
        color: 'rgba(255, 255, 255, 0.7)',
    },
    planStartButton: {
        backgroundColor: 'rgba(117, 117, 117, 0.6)',
        borderRadius: Dims.borderRadiusLarge,
        paddingVertical: Dims.spacingS,
        paddingHorizontal: Dims.paddingS,
    },
    planStartButtonText: {
        color: Colors.wWhite,
        fontSize: Dims.textSizeS,
        fontWeight: '500',
    },

    // Exercises Tab
    exercisesContent: {
        paddingHorizontal: Dims.paddingM,
        paddingTop: Dims.spacingSM,
        paddingBottom: Dims.spacingL,
    },

    // Category Card
    categoryCard: {
        width: '100%',
        height: Dims.size120,
        marginBottom: Dims.spacingML,
    },
    categoryCardBackground: {
        flex: 1,
        width: '100%',
        height: '100%',
    },
    categoryCardImage: {
        borderRadius: Dims.borderRadiusLarge,
    },
    categoryCardContent: {
        flex: 1,
        padding: Dims.paddingXL,
        justifyContent: 'center',
    },
    categoryCardTitle: {
        fontSize: Dims.textSizeXL,
        fontWeight: 'bold',
        color: Colors.wWhite,
    },

    // Bottom Spacer
    bottomSpacer: {
        height: Dims.size104,
    },

    // Filtered View Styles
    backToCategories: {
        flexDirection: 'row',
        alignItems: 'center',
        paddingHorizontal: Dims.paddingM,
        marginBottom: Dims.spacingM,
        marginTop: Dims.spacingS,
    },
    backText: {
        marginLeft: Dims.spacingS,
        fontSize: Dims.textSizeM,
        color: Colors.dark,
        fontWeight: '500',
    },
    plansListVertical: {
        flex: 1,
    },
    emptyText: {
        textAlign: 'center',
        marginTop: Dims.spacingHuge,
        fontSize: Dims.textSizeM,
        color: Colors.lightHover,
    },
});
