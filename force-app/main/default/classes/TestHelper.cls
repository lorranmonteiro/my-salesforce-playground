@isTest
public class TestHelper {

    private static final String ALPHA_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    private static final String NUMERIC_CHARS = '0123456789';

    public static String generateEmail() {
        return generateRandomString() + '@mail.com';
    }

    public static String generateRandomString() {
        return generateRandomString(10);
    }

    public static String generateRandomString(Integer stringLength) {
        String randomString = '';    

        while (randomString.length() < stringLength) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), ALPHA_CHARS.length());
           randomString += ALPHA_CHARS.substring(idx, idx + 1);
        }

        return randomString;
    }

    public static Integer generateRandomInteger() {
        return generateRandomInteger(5);
    }

    public static Integer generateRandomInteger(Integer numberLength) {
        // Limited by Integer size
        if (string.ValueOf(numberLength).length() > 10) { numberLength = 10; }

        String stringNumber = '';
    
        while (stringNumber.length() < numberLength) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), NUMERIC_CHARS.length());
            stringNumber += NUMERIC_CHARS.substring(idx, idx + 1);
        }

        Integer randomNumber = Integer.valueOf(stringNumber);
        return randomNumber; 
    }

    public static String generateRandomNumericString() {
        return generateRandomNumericString(5);
    }

    public static String generateRandomNumericString(Integer numberLength) {
        Integer randomNumber = generateRandomInteger(numberLength);

        String randomNumericString = String.valueOf(randomNumber);
        return randomNumericString; 
    }


    public static String generateMobilePhone() {
        String stringNumber = '8599';
    
        while (stringNumber.length() < 11) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), NUMERIC_CHARS.length());
            stringNumber += NUMERIC_CHARS.substring(idx, idx + 1);
        }

        return stringNumber; 
    }
}