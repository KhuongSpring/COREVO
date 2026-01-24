import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet, Image, ImageSourcePropType, Switch } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { useTheme } from '@/hooks/useTheme';

interface SettingItemProps {
    icon: ImageSourcePropType;
    title: string;
    onPress?: () => void;
    showArrow?: boolean;
    showSwitch?: boolean;
    switchValue?: boolean;
    onSwitchChange?: (value: boolean) => void;
    showDivider?: boolean;
    value?: string;
}

/**
 * Setting Item Component
 * Displays a single setting option with icon, title, and optional trailing element
 */
export default function SettingItem({
    icon,
    title,
    onPress,
    showArrow = true,
    showSwitch = false,
    switchValue = false,
    onSwitchChange,
    showDivider = false,
    value,
}: SettingItemProps) {
    const { colors } = useTheme();
    return (
        <>
            <TouchableOpacity
                style={styles.container}
                onPress={onPress}
                disabled={!onPress && !showSwitch}
                activeOpacity={0.7}
            >
                <Image source={icon} style={[styles.icon, {
                    tintColor: colors.interactive.active
                }]} resizeMode="contain" />
                <Text style={[styles.title,
                { color: colors.text.primary }
                ]}>{title}</Text>

                {value && (
                    <Text style={[styles.value,
                    { color: colors.text.secondary }
                    ]}>{value}</Text>
                )}

                {showSwitch && (
                    <Switch
                        value={switchValue}
                        onValueChange={onSwitchChange}
                        trackColor={{
                            false: Colors.moreLighter,
                            true: Colors.bNormal,
                        }}
                        thumbColor={Colors.wWhite}
                        style={styles.switch}
                    />
                )}

                {showArrow && !showSwitch && !value && (
                    <Ionicons
                        name="chevron-forward"
                        size={Dims.iconSizeM}
                        color={colors.interactive.darkHover}
                    />
                )}
            </TouchableOpacity>

            {showDivider && <View style={[styles.divider,
            { backgroundColor: colors.interactive.disabled, }
            ]} />}
        </>
    );
}

const styles = StyleSheet.create({
    container: {
        flexDirection: 'row',
        alignItems: 'center',
        paddingVertical: Dims.spacingSM,
        paddingHorizontal: Dims.paddingM,
    },
    icon: {
        width: Dims.iconSizeL,
        height: Dims.iconSizeL,
        marginRight: Dims.spacingM,
    },
    title: {
        flex: 1,
        fontSize: Dims.textSizeS,
    },
    value: {
        fontSize: Dims.textSizeS,
        fontWeight: '500',
        marginRight: Dims.spacingS,
    },
    switch: {
        transform: [{ scaleX: 0.8 }, { scaleY: 0.8 }],
    },
    divider: {
        height: 1,
        marginLeft: Dims.size56,
    },
});
