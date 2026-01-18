import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import SafeAreaWrapper from '@/components/common/SafeAreaWrapper';

/**
 * Library Tab Screen
 * Browse training plans and exercises
 */
export default function LibraryScreen() {
    return (
        <SafeAreaWrapper backgroundColor={Colors.wWhite}>
            <View style={styles.container}>
                <Text style={styles.title}>Thư viện Tập luyện</Text>
                <Text style={styles.subtitle}>
                    Danh sách bài tập và kế hoạch tập luyện
                </Text>
                <View style={styles.placeholder}>
                    <Text style={styles.placeholderText}>📚</Text>
                    <Text style={styles.placeholderDescription}>
                        Sẽ hiển thị danh sách exercises và training plans
                    </Text>
                </View>
            </View>
        </SafeAreaWrapper>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        padding: Dims.paddingL,
    },
    title: {
        fontSize: Dims.textSizeXXL,
        fontWeight: 'bold',
        color: Colors.dark,
        marginBottom: Dims.spacingS,
        marginTop: Dims.spacingM,
    },
    subtitle: {
        fontSize: Dims.textSizeM,
        color: Colors.lighter,
        marginBottom: Dims.spacingXL,
    },
    placeholder: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
    },
    placeholderText: {
        fontSize: 80,
        marginBottom: Dims.spacingL,
    },
    placeholderDescription: {
        fontSize: Dims.textSizeM,
        color: Colors.lighter,
        textAlign: 'center',
    },
});
