public with sharing class GeminiResponse {

    public String status;
    public List<Step> steps;

    public List<Error> errors;

    public class Step {
        public Content content;
    }

    public class Content {
        public String text;
    }

    public class Error {
        public String code;
        public String message;
    }

    public static GeminiResponse parse(String json) {
        return (GeminiResponse) System.JSON.deserialize(json, GeminiResponse.class);
    }
}
