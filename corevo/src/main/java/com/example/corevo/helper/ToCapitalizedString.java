package com.example.corevo.helper;

import java.util.Arrays;
import java.util.stream.Collectors;

public class ToCapitalizedString {

    public static String toCapitalized(String input) {
        if (input == null || input.isEmpty())
            return input;

        return Arrays.stream(input.trim().toLowerCase().split("\\s+"))
                .map(word -> word.substring(0, 1).toUpperCase() + word.substring(1))
                .collect(Collectors.joining(" "));
    }

}
