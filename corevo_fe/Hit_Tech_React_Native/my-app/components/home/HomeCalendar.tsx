import React, { useMemo, useState } from 'react';
import { View, StyleSheet, Text, TouchableOpacity } from 'react-native';
import { Calendar, LocaleConfig } from 'react-native-calendars';
import { Colors } from '@/constants/Colors';
import { Dims } from '@/constants/Dimensions';
import { Ionicons } from '@expo/vector-icons';

// 1. Cấu hình Tiếng Việt cho lịch
LocaleConfig.locales['vi'] = {
    monthNames: [
        'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
        'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'
    ],
    monthNamesShort: ['Th.1', 'Th.2', 'Th.3', 'Th.4', 'Th.5', 'Th.6', 'Th.7', 'Th.8', 'Th.9', 'Th.10', 'Th.11', 'Th.12'],
    dayNames: ['Chủ Nhật', 'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy'],
    dayNamesShort: ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'],
    today: 'Hôm nay'
};
LocaleConfig.defaultLocale = 'vi';

interface HomeCalendarProps {
    completedDays: number[]; // Mảng các ngày đã tập trong tháng hiện tại (VD: [1, 2, 5])
    scheduledWeekdays?: number[]; // Các ngày trong tuần có lịch tập (0=Sunday, 1=Monday, ..., 6=Saturday)
}

const HomeCalendar: React.FC<HomeCalendarProps> = ({ completedDays, scheduledWeekdays = [] }) => {
    const [currentDate, setCurrentDate] = useState(new Date().toISOString().split('T')[0]);

    // 2. Chuyển đổi dữ liệu ngày hoàn thành sang định dạng MarkedDates của thư viện
    const markedDates = useMemo(() => {
        const today = new Date();
        const todayDateOnly = new Date(today.getFullYear(), today.getMonth(), today.getDate());
        const year = today.getFullYear();
        const month = (today.getMonth() + 1).toString().padStart(2, '0');

        const marks: any = {};

        // Đánh dấu các ngày đã tập (completedDays) - chỉ cho quá khứ
        completedDays.forEach(day => {
            const dateString = `${year}-${month}-${day.toString().padStart(2, '0')}`;
            const date = new Date(year, today.getMonth(), day);

            // Chỉ đánh dấu xanh cho những ngày đã qua
            if (date < todayDateOnly) {
                marks[dateString] = {
                    selected: true,
                    selectedColor: Colors.bNormal, // Màu xanh chủ đạo cho ngày đã tập
                };
            }
        });

        // Đánh dấu chấm đỏ cho những ngày tương lai có lịch tập
        if (scheduledWeekdays.length > 0) {
            const daysInMonth = new Date(year, today.getMonth() + 1, 0).getDate();

            for (let day = 1; day <= daysInMonth; day++) {
                const date = new Date(year, today.getMonth(), day);
                const weekday = date.getDay(); // 0 = Sunday, 1 = Monday, ...

                // Chỉ đánh dấu cho những ngày tương lai
                if (date > todayDateOnly && scheduledWeekdays.includes(weekday)) {
                    const dateString = `${year}-${month}-${day.toString().padStart(2, '0')}`;

                    // Nếu chưa có mark nào thì tạo mới
                    if (!marks[dateString]) {
                        marks[dateString] = {
                            marked: true,
                            dotColor: '#FF0000', // Chấm đỏ
                        };
                    } else {
                        // Nếu đã có mark (selected) thì thêm dot
                        marks[dateString].marked = true;
                        marks[dateString].dotColor = '#FF0000';
                    }
                }
            }
        }

        // Đánh dấu ngày hôm nay (nếu chưa tập thì hiện border, tập rồi thì logic trên đè lên)
        const todayStr = today.toISOString().split('T')[0];
        if (!marks[todayStr]) {
            marks[todayStr] = {
                selected: true,
                selectedColor: Colors.wWhite,
                selectedTextColor: Colors.bNormal,
                // Dùng custom style qua theme để tạo border
                customStyles: {
                    container: {
                        borderWidth: 1,
                        borderColor: Colors.bNormal
                    }
                }
            };
        }

        return marks;
    }, [completedDays, scheduledWeekdays]);

    return (
        <View style={styles.container}>
            <Calendar
                // --- Cấu hình cơ bản ---
                current={currentDate}
                firstDay={1} // Bắt đầu từ Thứ 2
                enableSwipeMonths={true} // Vuốt để chuyển tháng

                // --- Cấu hình giao diện (Custom) ---
                theme={{
                    backgroundColor: Colors.wWhite,
                    calendarBackground: Colors.wWhite,
                    textSectionTitleColor: Colors.lightActive, // Màu chữ T2, T3...
                    selectedDayBackgroundColor: Colors.bNormal,
                    selectedDayTextColor: Colors.wWhite,
                    todayTextColor: Colors.bNormal,
                    dayTextColor: Colors.dark,
                    textDisabledColor: '#d9e1e8',
                    dotColor: Colors.bNormal,
                    selectedDotColor: '#ffffff',
                    arrowColor: Colors.bNormal,
                    monthTextColor: Colors.dark,
                    indicatorColor: Colors.bNormal,
                    textDayFontWeight: '500',
                    textMonthFontWeight: 'bold',
                    textDayHeaderFontWeight: '500',
                    textDayFontSize: 14,
                    textMonthFontSize: 16,
                    textDayHeaderFontSize: 13,
                    // Custom Header Container
                    'stylesheet.calendar.header': {
                        header: {
                            flexDirection: 'row',
                            justifyContent: 'space-between',
                            paddingLeft: 10,
                            paddingRight: 10,
                            marginTop: 6,
                            alignItems: 'center'
                        }
                    }
                } as any}

                // --- Đánh dấu ngày ---
                markedDates={markedDates}

                // --- Custom Header (Tùy chọn: Nếu muốn tự vẽ header) ---
                // renderHeader={(date) => {/* Custom View */}}

                // --- Xử lý sự kiện ---
                onDayPress={day => {
                    console.log('selected day', day);
                    // Logic khi bấm vào ngày (VD: xem chi tiết lịch tập)
                }}
            />
        </View>
    );
};

const styles = StyleSheet.create({
    container: {
        backgroundColor: Colors.wWhite,
        borderRadius: Dims.borderRadiusSmall,
        padding: Dims.paddingM,
        marginBottom: Dims.spacingSM,
        // Shadow
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.1,
        shadowRadius: 4,
        elevation: 3,
    },
});

export default HomeCalendar;