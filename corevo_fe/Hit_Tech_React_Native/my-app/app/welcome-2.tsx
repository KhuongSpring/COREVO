import React, { useEffect, useRef } from 'react';
import {
    View,
    Text,
    StyleSheet,
    ImageBackground,
    TouchableOpacity,
    Animated,
    PanResponder,
} from 'react-native';
import { useRouter } from 'expo-router';
// import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { AppAssets } from '@/constants/AppAssets';

/**
 * Welcome Screen - Part 1
 * Introduction screen with body metrics theme
 */
export default function Welcome1Screen() {
    const router = useRouter();
    const translateX = useRef(new Animated.Value(0)).current;

    // Auto-navigation after 3 seconds
    // useEffect(() => {
    //     const timer = setTimeout(() => {
    //         router.push('/welcome-2' as any);
    //     }, 3000);

    //     return () => clearTimeout(timer);
    // }, [router]);

    // Swipe gesture handler
    const panResponder = useRef(
        PanResponder.create({
            onStartShouldSetPanResponder: () => true,
            onMoveShouldSetPanResponder: (_, gestureState) => {
                return Math.abs(gestureState.dx) > 5;
            },
            onPanResponderMove: (_, gestureState) => {
                if (gestureState.dx < 0) {
                    translateX.setValue(gestureState.dx);
                }
            },
            onPanResponderRelease: (_, gestureState) => {
                if (gestureState.dx < -50) {
                    // Swipe left detected - navigate
                    Animated.timing(translateX, {
                        toValue: -Dims.width,
                        duration: 200,
                        useNativeDriver: true,
                    }).start(() => {
                        router.push('/welcome-2' as any);
                    });
                } else {
                    // Reset position
                    Animated.spring(translateX, {
                        toValue: 0,
                        useNativeDriver: true,
                    }).start();
                }
            },
        })
    ).current;

    const handleNext = () => {
        router.push('/welcome-2' as any);
    };

    return (
        <ImageBackground
            source={AppAssets.startBackground}
            style={styles.background}
            resizeMode="cover"
        >
            <Animated.View
                style={[
                    styles.container,
                    {
                        transform: [{ translateX }],
                    },
                ]}
                {...panResponder.panHandlers}
            >
                <View style={styles.content}>
                    {/* Part indicator */}
                    <Text style={styles.partText}>Phần 1</Text>

                    {/* Main heading */}
                    <View style={styles.headingContainer}>
                        <Text style={styles.heading}>Chỉ Số Cơ Thể</Text>

                        {/* Forward arrow */}
                        <TouchableOpacity
                            style={styles.arrowButton}
                            onPress={handleNext}
                            activeOpacity={0.7}
                        >
                            <Ionicons
                                name="chevron-forward"
                                size={Dims.iconSizeXXXL}
                                color={Colors.wWhite}
                            />
                            <Ionicons
                                name="chevron-forward"
                                size={Dims.iconSizeXXXL}
                                color={Colors.wWhite}
                                style={styles.arrowSecond}
                            />
                        </TouchableOpacity>
                    </View>
                </View>
            </Animated.View>
        </ImageBackground>
    );
}

const styles = StyleSheet.create({
    background: {
        flex: 1,
        width: '100%',
        height: '100%',
    },
    gradient: {
        flex: 1,
    },
    container: {
        flex: 1,
        justifyContent: 'center',
        paddingHorizontal: Dims.paddingL,
    },
    content: {
        alignItems: 'flex-start',
    },
    partText: {
        fontSize: Dims.textSizeM,
        color: Colors.wWhite,
        opacity: 0.9,
        marginBottom: Dims.spacingS,
        fontWeight: '400',
    },
    headingContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        width: '100%',
    },
    heading: {
        fontSize: Dims.textSizeXXXL + 4,
        fontWeight: 'bold',
        color: Colors.wWhite,
        lineHeight: Dims.textSizeXXXL + 12,
        flex: 1,
    },
    arrowButton: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        padding: Dims.paddingS,
        marginLeft: Dims.spacingM,
    },
    arrowSecond: {
        marginLeft: -Dims.spacingM,
    },
});
