public with sharing class OpenAIResponse {

    public ResponseStatus status; // completed, failed, in_progress, cancelled, queued, or incomplete
    public List<Output> output;
    public Error error;

    public class Output {
        public ResponseStatus status; // in_progress, completed, or incomplete
        public List<Content> content;
    }

    public class Content {
        public String type;
        public String text;
    }

    public class Error {
        public String message;
        public String code;
        public String type;
        public String param;
    }

    @SuppressWarnings('PMD.FieldNamingConventions')
    public enum ResponseStatus {
        completed,
        failed,
        in_progress,
        cancelled,
        queued,
        incomplete
    }

    public static OpenAIResponse parse(String json) {
        return (OpenAIResponse) System.JSON.deserialize(json, OpenAIResponse.class);
    }
}