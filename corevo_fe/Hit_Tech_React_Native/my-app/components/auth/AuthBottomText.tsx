import React from 'react';
import { TouchableOpacity, Text, StyleSheet, View } from 'react-native';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';

interface AuthBottomTextProps {
    normalText: string;
    linkText: string;
    onPress: () => void;
}

/**
 * Auth Bottom Text Component
 * Text with clickable link (e.g., "Don't have an account? Sign up")
 */
export default function AuthBottomText({
    normalText,
    linkText,
    onPress,
}: AuthBottomTextProps) {
    return (
        <View style={styles.container}>
            <Text style={styles.normalText}>{normalText} </Text>
            <TouchableOpacity onPress={onPress} activeOpacity={0.7}>
                <Text style={styles.linkText}>{linkText}</Text>
            </TouchableOpacity>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        marginTop: Dims.spacingL,
    },
    normalText: {
        fontSize: Dims.textSizeM,
        color: Colors.lighter,
    },
    linkText: {
        fontSize: Dims.textSizeM,
        color: Colors.bNormal,
        fontWeight: '600',
    },
});
