package com.example.corevo.helper;

import lombok.AccessLevel;
import lombok.experimental.FieldDefaults;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@FieldDefaults(level = AccessLevel.PRIVATE)
public class StringToTrainingIDHelper {
    public static final class Equipment {
        private static final Map<String, Long> NAME_TO_ID = Map.of(
                "None", 1L,
                "Yoga mat", 2L,
                "Treadmill", 3L,
                "Resistance Band", 4L,
                "Gym equipment", 5L,
                "Pull up bar", 6L,
                "Parallel bars", 7L
        );

        public static Optional<Long> toId(String name) {
            if (name == null) return Optional.empty();
            return Optional.ofNullable(NAME_TO_ID.get(name));
        }

        public static List<Long> toIds(List<String> names) {
            if (names == null || names.isEmpty()) return List.of();
            return names.stream()
                    .map(Equipment::toId)
                    .flatMap(Optional::stream)
                    .toList();
        }
    }

    public static final class Goal {
        private static final Map<String, Long> NAME_TO_ID = Map.of(
                "Lose weight, Lose fat", 1L,
                "Gain weight", 2L,
                "Gain muscle", 3L,
                "Maintain body", 4L,
                "Increase endurance", 5L,
                "Improve cardiovascular", 6L,
                "Stress relief/relaxation", 7L,
                "Increase height", 8L
        );

        public static Optional<Long> toId(String name) {
            if (name == null) return Optional.empty();
            return Optional.ofNullable(NAME_TO_ID.get(name));
        }

        public static List<Long> toIds(List<String> names) {
            if (names == null || names.isEmpty()) return List.of();
            return names.stream()
                    .map(Goal::toId)
                    .flatMap(Optional::stream)
                    .toList();
        }
    }

    public static final class Level {
        private static final Map<String, Long> NAME_TO_ID = Map.of(
                "BEGINNER", 1L,
                "INTERMEDIATE", 2L,
                "ADVANCED", 3L
        );

        public static Optional<Long> toId(String name) {
            if (name == null) return Optional.empty();
            return Optional.ofNullable(NAME_TO_ID.get(name.toUpperCase()));
        }

        public static List<Long> toIds(List<String> names) {
            if (names == null || names.isEmpty()) return List.of();
            return names.stream()
                    .map(Level::toId)
                    .flatMap(Optional::stream)
                    .toList();
        }
    }

    public static final class Location {
        private static final Map<String, Long> NAME_TO_ID = Map.of(
                "HOME", 1L,
                "GYM", 2L,
                "OUTSIDE", 3L,
                "ANYWHERE", 4L
        );

        public static Optional<Long> toId(String name) {
            if (name == null) return Optional.empty();
            return Optional.ofNullable(NAME_TO_ID.get(name.toUpperCase()));
        }

        public static List<Long> toIds(List<String> names) {
            if (names == null || names.isEmpty()) return List.of();
            return names.stream()
                    .map(Location::toId)
                    .flatMap(Optional::stream)
                    .toList();
        }
    }

//    public static final class TargetMuscle {
//        private static final Map<String, Long> NAME_TO_ID = Map.of(
//                "Chest", 1L,
//                "Back", 2L,
//                "Shoulders", 3L,
//                "Biceps", 4L,
//                "Triceps", 5L,
//                "Forearms", 6L,
//                "Abs", 7L,
//                "Obliques", 8L,
//                "Lower Back", 9L,
//                "Glutes", 10L,
//                "Quads", 11L,
//                "Hamstrings", 12L,
//                "Calves", 13L
//                );
//
//        public static Optional<Long> toId(String name) {
//            if (name == null) return Optional.empty();
//            return Optional.ofNullable(NAME_TO_ID.get(name));
//        }
//
//        public static List<Long> toIds(List<String> names) {
//            if (names == null || names.isEmpty()) return List.of();
//            return names.stream()
//                    .map(TargetMuscle::toId)
//                    .flatMap(Optional::stream)
//                    .toList();
//        }
//    }

    public static final class Type {
        private static final Map<String, Long> NAME_TO_ID = Map.of(
                "Gym", 1L,
                "Cardio", 2L,
                "Yoga", 3L,
                "Calisthenic", 4L
        );

        public static Optional<Long> toId(String name) {
            if (name == null) return Optional.empty();
            return Optional.ofNullable(NAME_TO_ID.get(name.toUpperCase()));
        }

        public static List<Long> toIds(List<String> names) {
            if (names == null || names.isEmpty()) return List.of();
            return names.stream()
                    .map(Type::toId)
                    .flatMap(Optional::stream)
                    .toList();
        }
    }
}
