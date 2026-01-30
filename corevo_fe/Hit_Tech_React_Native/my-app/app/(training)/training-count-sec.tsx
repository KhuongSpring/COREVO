import React, { useState, useEffect } from 'react';
import {
    View,
    Text,
    StyleSheet,
    ImageBackground,
    TouchableOpacity,
    ActivityIndicator,
} from 'react-native';
import { router, useLocalSearchParams } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { AppAssets } from '@/constants/AppAssets';
import { AppStrings } from '@/constants/AppStrings';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';

/**
 * Training Count Sec Screen
 * Placeholder for exercise execution with timer/counter
 * 
 * This screen will be implemented in the future to show:
 * - Exercise video/animation
 * - Set/rep counter
 * - Timer for timed exercises
 * - Rest timer between sets
 * - Mark set complete button
 * - Progress through sets
 */

export default function TrainingCountSecScreen() {
    const params = useLocalSearchParams();
    const exerciseId = params.exerciseId;
    const exerciseIndex = params.exerciseIndex;
    const totalSet = params.totalSet;
    const completedSet = params.completedSet;

    const [loading, setLoading] = useState(true);

    useEffect(() => {
        // Simulate loading
        setTimeout(() => setLoading(false), 1000);
    }, []);

    const handleBack = () => {
        router.back();
    };

    if (loading) {
        return (
            <View style={styles.loadingContainer}>
                <ActivityIndicator size="large" color={Colors.bNormal} />
            </View>
        );
    }

    return (
        <ImageBackground source={AppAssets.mainBackground} style={styles.background}>
            <View style={styles.container}>
                {/* Header */}
                <View style={styles.header}>
                    <TouchableOpacity onPress={handleBack} style={styles.backButton}>
                        <Ionicons name="chevron-back-outline" size={Dims.iconSizeM} color={Colors.dark} />
                    </TouchableOpacity>
                    <Text style={styles.headerTitle}>Exercise Execution</Text>
                    <View style={{ width: 40 }} />
                </View>

                {/* Placeholder Content */}
                <View style={styles.content}>
                    <View style={styles.placeholderCard}>
                        <Ionicons name="fitness-outline" size={64} color={Colors.bNormal} />
                        <Text style={styles.placeholderTitle}>Exercise Execution Screen</Text>
                        <Text style={styles.placeholderText}>
                            This screen will display:
                        </Text>
                        <View style={styles.featureList}>
                            <Text style={styles.featureItem}>• Exercise video/GIF</Text>
                            <Text style={styles.featureItem}>• Rep/Time counter</Text>
                            <Text style={styles.featureItem}>• Rest timer between sets</Text>
                            <Text style={styles.featureItem}>• Set completion tracking</Text>
                            <Text style={styles.featureItem}>• Progress indicator</Text>
                        </View>

                        <View style={styles.infoBox}>
                            <Text style={styles.infoText}>Exercise ID: {exerciseId}</Text>
                            <Text style={styles.infoText}>Progress: {completedSet}/{totalSet} sets</Text>
                        </View>
                    </View>

                    {/* Temporary Back Button */}
                    <TouchableOpacity
                        style={styles.backToListButton}
                        onPress={handleBack}
                    >
                        <Text style={styles.backToListButtonText}>
                            Back to Exercise List
                        </Text>
                    </TouchableOpacity>
                </View>
            </View>
        </ImageBackground>
    );
}

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
        paddingTop: Dims.spacingXL,
    },
    header: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        paddingHorizontal: Dims.paddingS,
        marginBottom: Dims.spacingL,
    },
    backButton: {
        padding: Dims.paddingS,
    },
    headerTitle: {
        fontSize: Dims.textSizeL,
        color: Colors.dark,
        fontWeight: '600',
    },
    content: {
        flex: 1,
        paddingHorizontal: Dims.paddingL,
        justifyContent: 'center',
        alignItems: 'center',
    },
    placeholderCard: {
        backgroundColor: Colors.wWhite,
        borderRadius: Dims.borderRadius,
        padding: Dims.paddingXL,
        alignItems: 'center',
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 4 },
        shadowOpacity: 0.15,
        shadowRadius: 8,
        elevation: 5,
        width: '100%',
    },
    placeholderTitle: {
        fontSize: Dims.textSizeXL,
        fontWeight: 'bold',
        color: Colors.dark,
        marginTop: Dims.spacingL,
        marginBottom: Dims.spacingM,
        textAlign: 'center',
    },
    placeholderText: {
        fontSize: Dims.textSizeM,
        color: Colors.dark,
        marginBottom: Dims.spacingM,
        textAlign: 'center',
    },
    featureList: {
        alignSelf: 'stretch',
        marginVertical: Dims.spacingL,
    },
    featureItem: {
        fontSize: Dims.textSizeM,
        color: Colors.dark,
        marginBottom: Dims.spacingS,
        paddingLeft: Dims.paddingM,
    },
    infoBox: {
        backgroundColor: Colors.lightGray,
        borderRadius: Dims.borderRadiusSmall,
        padding: Dims.paddingM,
        marginTop: Dims.spacingL,
        alignSelf: 'stretch',
    },
    infoText: {
        fontSize: Dims.textSizeS,
        color: Colors.dark,
        marginBottom: Dims.spacingXS,
    },
    backToListButton: {
        backgroundColor: Colors.bNormal,
        paddingVertical: Dims.paddingM,
        paddingHorizontal: Dims.paddingXL,
        borderRadius: Dims.borderRadiusSmall,
        marginTop: Dims.spacingXL,
    },
    backToListButtonText: {
        color: Colors.wWhite,
        fontSize: Dims.textSizeM,
        fontWeight: '600',
    },
});
