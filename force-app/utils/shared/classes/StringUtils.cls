public with sharing class StringUtils {

    public static String truncate(String input, Integer maxLength) {
        if (input == null) { return null; }
        if (input.length() <= maxLength) { return input; }

        return input.substring(0, maxLength);
    }
}
