package com.example.corevo.helper.training_helper;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

public class TrainingExerciseGroupDetailParserHelper {
    @AllArgsConstructor
    @NoArgsConstructor
    @Getter
    @Setter
    public static class Result {
        public String sets;
        public String repsPerSet;
        public String durationPerSet;

    }

    public static Result parse(String input) {
        String[] parts = input.split("X", 2);
        if (parts.length < 2)
            return new Result(null, null, null);

        String sets = parts[0].trim();
        sets = sets.replace("sets", "").trim();

        String secondPart = parts[1].trim().toLowerCase();

        if (secondPart.contains("giây") || secondPart.contains("phút")) {
            return new Result(sets, null, secondPart);
        }

        String reps = secondPart.replace("reps", "").replace("rep", "").trim();

        return new Result(sets, reps, null);
    }
}
