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
    Alert,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { AppAssets } from '@/constants/AppAssets';
import { AppStrings } from '@/constants/AppStrings';
import { TrainingPlan, TrainingPlanResponse } from '@/types/training';

// Mock data for training plans
const MOCK_TRAINING_PLANS: Record<string, TrainingPlan[]> = {
    loseFat: [
        {
            id: 1,
            name: 'Giảm mỡ toàn thân',
            goals: 'Lose fat',
            description: 'Đốt cháy mỡ thừa hiệu quả với cardio và HIIT',
            aim: 'Giảm 5kg trong 8 tuần',
            type: 'CARDIO',
            duration: '45',
            frequency: '5',
            levelIds: [1],
            locationIds: [1],
            equipmentIds: [1],
        },
        {
            id: 2,
            name: 'Cardio cơ bản',
            goals: 'Lose fat',
            description: 'Tập cardio nhẹ nhàng cho người mới bắt đầu',
            aim: 'Giảm mỡ bụng',
            type: 'CARDIO',
            duration: '30',
            frequency: '4',
            levelIds: [1],
            locationIds: [1],
            equipmentIds: [1],
        },
        {
            id: 3,
            name: 'HIIT nâng cao',
            goals: 'Lose fat',
            description: 'HIIT cường độ cao để đốt cháy calories tối đa',
            aim: 'Giảm 8kg trong 12 tuần',
            type: 'CARDIO',
            duration: '40',
            frequency: '6',
            levelIds: [3],
            locationIds: [1],
            equipmentIds: [1],
        },
    ],
    gainWeight: [
        {
            id: 4,
            name: 'Tăng cân khỏe mạnh',
            goals: 'Gain weight',
            description: 'Kế hoạch tăng cân và cơ bắp cho người gầy',
            aim: 'Tăng 5kg trong 12 tuần',
            type: 'GYM',
            duration: '60',
            frequency: '5',
            levelIds: [2],
            locationIds: [2],
            equipmentIds: [4],
        },
        {
            id: 5,
            name: 'Tăng cơ và cân nặng',
            goals: 'Gain weight',
            description: 'Tập tạ kết hợp dinh dưỡng để tăng cân',
            aim: 'Tăng 3kg trong 8 tuần',
            type: 'GYM',
            duration: '50',
            frequency: '4',
            levelIds: [1],
            locationIds: [2],
            equipmentIds: [4],
        },
    ],
    gainMuscle: [
        {
            id: 6,
            name: 'Tăng cơ toàn diện',
            goals: 'Gain muscle',
            description: 'Xây dựng khối cơ với các bài tập phức hợp',
            aim: 'Tăng 4kg cơ trong 12 tuần',
            type: 'GYM',
            duration: '60',
            frequency: '6',
            levelIds: [2],
            locationIds: [2],
            equipmentIds: [4],
        },
        {
            id: 7,
            name: 'Cơ bắp thẩm mỹ',
            goals: 'Gain muscle',
            description: 'Tăng cơ và định hình body đẹp mắt',
            aim: 'Tăng 3kg cơ trong 10 tuần',
            type: 'GYM',
            duration: '55',
            frequency: '5',
            levelIds: [2],
            locationIds: [2],
            equipmentIds: [4],
        },
        {
            id: 8,
            name: 'Bodybuilding',
            goals: 'Gain muscle',
            description: 'Chương trình tăng cơ chuyên nghiệp',
            aim: 'Tăng 6kg cơ trong 16 tuần',
            type: 'GYM',
            duration: '75',
            frequency: '6',
            levelIds: [3],
            locationIds: [2],
            equipmentIds: [4],
        },
    ],
    maintainBody: [
        {
            id: 9,
            name: 'Duy trì vóc dáng',
            goals: 'Maintain Body',
            description: 'Giữ gìn thể hình hiện tại với tập luyện đều đặn',
            aim: 'Duy trì cân nặng ổn định',
            type: 'GYM',
            duration: '45',
            frequency: '4',
            levelIds: [2],
            locationIds: [1, 2],
            equipmentIds: [1],
        },
        {
            id: 10,
            name: 'Fitness tổng hợp',
            goals: 'Maintain Body',
            description: 'Kết hợp cardio và tạ để duy trì sức khỏe',
            aim: 'Giữ body fit',
            type: 'GYM',
            duration: '50',
            frequency: '5',
            levelIds: [2],
            locationIds: [2],
            equipmentIds: [4],
        },
        {
            id: 11,
            name: 'Tập nhẹ duy trì',
            goals: 'Maintain Body',
            description: 'Tập luyện nhẹ nhàng để giữ vóc dáng',
            aim: 'Duy trì thể hình',
            type: 'CALISTHENIC',
            duration: '35',
            frequency: '3',
            levelIds: [1],
            locationIds: [1],
            equipmentIds: [1],
        },
    ],
    increaseEndurance: [
        {
            id: 12,
            name: 'Tăng sức bền',
            goals: 'Increase endurance',
            description: 'Cải thiện sức bền tim phổi và cơ bắp',
            aim: 'Chạy 5km không nghỉ',
            type: 'CARDIO',
            duration: '40',
            frequency: '5',
            levelIds: [2],
            locationIds: [3],
            equipmentIds: [1],
        },
        {
            id: 13,
            name: 'Marathon cơ bản',
            goals: 'Increase endurance',
            description: 'Chuẩn bị cho cuộc đua marathon',
            aim: 'Chạy 10km',
            type: 'CARDIO',
            duration: '60',
            frequency: '6',
            levelIds: [2],
            locationIds: [3],
            equipmentIds: [1],
        },
        {
            id: 14,
            name: 'Endurance Pro',
            goals: 'Increase endurance',
            description: 'Tăng sức bền chuyên nghiệp',
            aim: 'Chạy 21km',
            type: 'CARDIO',
            duration: '75',
            frequency: '6',
            levelIds: [3],
            locationIds: [3],
            equipmentIds: [1],
        },
    ],
    improveCardiovascular: [
        {
            id: 15,
            name: 'Tim mạch khỏe',
            goals: 'Improve cardiovascular',
            description: 'Cải thiện sức khỏe tim mạch',
            aim: 'Nhịp tim khỏe hơn',
            type: 'CARDIO',
            duration: '30',
            frequency: '4',
            levelIds: [1],
            locationIds: [1, 3],
            equipmentIds: [1],
        },
        {
            id: 16,
            name: 'Cardio nâng cao',
            goals: 'Improve cardiovascular',
            description: 'Tăng cường tim mạch với các bài tập cardio',
            aim: 'Cải thiện hệ tim mạch',
            type: 'CARDIO',
            duration: '45',
            frequency: '5',
            levelIds: [2],
            locationIds: [2, 3],
            equipmentIds: [1, 6],
        },
        {
            id: 17,
            name: 'Sức khỏe tim mạch',
            goals: 'Improve cardiovascular',
            description: 'Chương trình cho người bệnh tim mạch',
            aim: 'Phục hồi sức khỏe',
            type: 'CARDIO',
            duration: '25',
            frequency: '3',
            levelIds: [1],
            locationIds: [1],
            equipmentIds: [1],
        },
    ],
    stressRelief: [
        {
            id: 18,
            name: 'Yoga thư giãn',
            goals: 'Stress relief/relaxation',
            description: 'Giảm stress với yoga nhẹ nhàng',
            aim: 'Thư giãn tinh thần',
            type: 'YOGA',
            duration: '30',
            frequency: '4',
            levelIds: [1],
            locationIds: [1],
            equipmentIds: [7],
        },
        {
            id: 19,
            name: 'Meditation',
            goals: 'Stress relief/relaxation',
            description: 'Thiền và yoga để giảm căng thẳng',
            aim: 'Bình an nội tâm',
            type: 'YOGA',
            duration: '35',
            frequency: '5',
            levelIds: [1],
            locationIds: [1],
            equipmentIds: [7],
        },
        {
            id: 20,
            name: 'Yoga nâng cao',
            goals: 'Stress relief/relaxation',
            description: 'Yoga chuyên sâu để cân bằng cơ thể và tâm trí',
            aim: 'Thư giãn sâu',
            type: 'YOGA',
            duration: '45',
            frequency: '6',
            levelIds: [2],
            locationIds: [1],
            equipmentIds: [7],
        },
    ],
    increaseHeight: [
        {
            id: 21,
            name: 'Tăng chiều cao',
            goals: 'Increase height',
            description: 'Các bài tập hỗ trợ tăng chiều cao',
            aim: 'Tăng 2-3cm',
            type: 'CALISTHENIC',
            duration: '30',
            frequency: '6',
            levelIds: [1],
            locationIds: [1],
            equipmentIds: [1, 3],
        },
        {
            id: 22,
            name: 'Kéo giãn cột sống',
            goals: 'Increase height',
            description: 'Kéo giãn để tăng chiều cao tối ưu',
            aim: 'Tăng 1-2cm',
            type: 'YOGA',
            duration: '25',
            frequency: '7',
            levelIds: [1],
            locationIds: [1],
            equipmentIds: [7, 3],
        },
        {
            id: 23,
            name: 'Tăng chiều cao toàn diện',
            goals: 'Increase height',
            description: 'Kết hợp nhiều phương pháp tăng chiều cao',
            aim: 'Tăng 3-5cm',
            type: 'CALISTHENIC',
            duration: '40',
            frequency: '6',
            levelIds: [2],
            locationIds: [1, 2],
            equipmentIds: [1, 3],
        },
    ],
};

// Categories for exercises tab
const EXERCISE_CATEGORIES = [
    {
        id: 1,
        name: AppStrings.libraryCategoryChest,
        image: AppAssets.chestCategory,
        type: 'muscle',
    },
    {
        id: 2,
        name: AppStrings.libraryCategoryBack,
        image: AppAssets.backCategory,
        type: 'muscle',
    },
    {
        id: 3,
        name: AppStrings.libraryCategoryShoulders,
        image: AppAssets.shouldersCategory,
        type: 'muscle',
    },
    {
        id: 4,
        name: AppStrings.libraryCategoryBiceps,
        image: AppAssets.bicepCategory,
        type: 'muscle',
    },
    {
        id: 5,
        name: AppStrings.libraryCategoryTriceps,
        image: AppAssets.tricepCategory,
        type: 'muscle',
    },
    {
        id: 6,
        name: AppStrings.libraryCategoryAbs,
        image: AppAssets.absCategory,
        type: 'muscle',
    },
    {
        id: 7,
        name: AppStrings.libraryCategoryGlutes,
        image: AppAssets.gluteCategory,
        type: 'muscle',
    },
    {
        id: 8,
        name: AppStrings.libraryCategoryQuads,
        image: AppAssets.quadsCategory,
        type: 'muscle',
    },
    {
        id: 9,
        name: AppStrings.libraryCategoryHamstrings,
        image: AppAssets.hamstringCategory,
        type: 'muscle',
    },
    {
        id: 10,
        name: AppStrings.libraryCategoryCardio,
        image: AppAssets.cardioCategory,
        type: 'type',
    },
    {
        id: 11,
        name: AppStrings.libraryCategoryYoga,
        image: AppAssets.yogaCategory,
        type: 'type',
    },
    {
        id: 12,
        name: AppStrings.libraryCategoryCalisthenic,
        image: AppAssets.calisthenicCategory,
        type: 'type',
    },
];

/**
 * Training Library Screen
 * Browse training plans and exercises
 * Converted from Flutter training_library_screen.dart
 */
export default function LibraryScreen() {
    const [selectedIndex, setSelectedIndex] = useState(0);
    const [isLoading, setIsLoading] = useState(false);

    // Animation values for tabs
    const tab0FontSize = useRef(new Animated.Value(selectedIndex === 0 ? 1 : 0)).current;
    const tab1FontSize = useRef(new Animated.Value(selectedIndex === 1 ? 1 : 0)).current;
    const tab0Indicator = useRef(new Animated.Value(selectedIndex === 0 ? 1 : 0)).current;
    const tab1Indicator = useRef(new Animated.Value(selectedIndex === 1 ? 1 : 0)).current;

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

    const handleSearchPress = () => {
        Alert.alert('Tìm kiếm', 'Tính năng đang phát triển');
    };

    const handlePlanPress = (plan: TrainingPlan) => {
        Alert.alert('Chi tiết kế hoạch', `Kế hoạch: ${plan.name}`);
    };

    const handleCategoryPress = (categoryName: string) => {
        Alert.alert('Danh sách bài tập', `Nhóm cơ: ${categoryName}`);
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
                    {selectedIndex === 0 ? (
                        <TrainingPlansTab
                            plans={MOCK_TRAINING_PLANS}
                            onPlanPress={handlePlanPress}
                        />
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
}

function TrainingPlanCard({ plan, onPress }: TrainingPlanCardProps) {
    return (
        <View style={styles.planCard}>
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
    categories: Array<{
        id: number;
        name: string;
        image: any;
        type: string;
    }>;
    onCategoryPress: (categoryName: string) => void;
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
                    onPress={() => onCategoryPress(category.name)}
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
    category: {
        id: number;
        name: string;
        image: any;
        type: string;
    };
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
        backgroundColor: 'transparent',
        borderRadius: Dims.borderRadiusLarge,
        background: 'linear-gradient(180deg, transparent 0%, rgba(0,0,0,0.4) 100%)',
    } as any,
    planCardContent: {
        flex: 1,
        padding: Dims.paddingM,
        justifyContent: 'space-between',
        flexDirection: 'row',
    },
    planCardInfo: {
        flex: 1,
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
});
