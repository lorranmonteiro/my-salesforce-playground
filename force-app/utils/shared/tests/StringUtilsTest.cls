@IsTest
private class StringUtilsTest {

    @IsTest
    static void testTruncate() {
        String input = 'This is a long string that needs to be truncated.';
        String expected = 'This is a long string that needs to be t';
        Integer maxLength = 40;

        String result = StringUtils.truncate(input, maxLength);

        Assert.areEqual(expected, result, 'The string should be truncated correctly.');
    }
}
