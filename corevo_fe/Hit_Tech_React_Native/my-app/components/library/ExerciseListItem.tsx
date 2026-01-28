import React from 'react';
import { View, Text, TouchableOpacity, Image, StyleSheet } from 'react-native';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import type { TrainingExercisePreview } from '@/types/training';

interface ExerciseListItemProps {
    exercise: TrainingExercisePreview;
    onPress: () => void;
}

/**
 * Exercise List Item Component
 * Reusable component for displaying exercise in a list with thumbnail, name, and level info
 */
export default function ExerciseListItem({ exercise, onPress }: ExerciseListItemProps) {
    return (
        <TouchableOpacity
            style={styles.container}
            onPress={onPress}
            activeOpacity={0.7}
        >
            <View style={styles.thumbnail}>
                {exercise.imageURL ? (
                    <Image
                        source={{ uri: exercise.imageURL }}
                        style={styles.image}
                        resizeMode="cover"
                    />
                ) : (
                    <View style={styles.placeholderImage}>
                        <Text style={styles.placeholderText}>No Image</Text>
                    </View>
                )}
            </View>
            <View style={styles.info}>
                <Text style={styles.name} numberOfLines={1}>
                    {exercise.name}
                </Text>
                <Text style={styles.levelName} numberOfLines={1}>
                    {exercise.levelName}
                </Text>
            </View>
        </TouchableOpacity>
    );
}

const styles = StyleSheet.create({
    container: {
        flexDirection: 'row',
        paddingVertical: Dims.paddingS,
        backgroundColor: 'transparent',
    },
    thumbnail: {
        width: Dims.size112,
        height: Dims.size64,
        backgroundColor: Colors.bLight,
        borderRadius: Dims.borderRadiusSmall,
        overflow: 'hidden',
    },
    image: {
        width: '100%',
        height: '100%',
    },
    placeholderImage: {
        width: '100%',
        height: '100%',
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: Colors.bLightHover,
    },
    placeholderText: {
        fontSize: Dims.textSizeXS,
        color: Colors.lightHover,
    },
    info: {
        flex: 1,
        marginLeft: Dims.spacingSM,
        justifyContent: 'center',
    },
    name: {
        fontSize: Dims.textSizeM,
        fontWeight: '600',
        color: Colors.dark,
        marginBottom: Dims.spacingSM,
    },
    levelName: {
        fontSize: Dims.textSizeS,
        color: Colors.bNormal,
    },
});
