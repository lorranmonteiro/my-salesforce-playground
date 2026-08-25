public virtual with sharing class GeminiService implements IAIService {

    private static final String GEMINI_API = 'callout:GoogleGeminiAPI';
    private static final String GEMINI_INTERACTIONS_ENDPOINT = '/interactions';

    @TestVisible
    private static final String MISSING_INPUT_MESSAGE = 'Text input is missing.';

    public virtual String getResponse(String input) {

        if (String.isBlank(input))
            throw new GeminiServiceMissingInputException(MISSING_INPUT_MESSAGE);

        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setEndpoint(GEMINI_API + GEMINI_INTERACTIONS_ENDPOINT);
        request.setBody(JSON.serialize(new GeminiRequest(input)));

        HttpResponse response = new Http().send(request);
        LogService.logIntegrationCallout(request, response);

        if (response.getStatusCode() != 200)
            handleError(response);

        return extractOutputText(response.getBody());
    }

    private String extractOutputText(String responseBody) {
        GeminiResponse parsed = GeminiResponse.parse(responseBody);
        String outputMessage = '';

        if (parsed.steps != null) {
            for (GeminiResponse.Step step : parsed.steps) {

                if (step.content != null)
                    outputMessage += step.content.text;
            }
        }

        return outputMessage;
    }

    @TestVisible
    private void handleError(HttpResponse response) {
        String errorMessage = 'Error when getting Gemini response - \n StatusCode: ' + response.getStatusCode();

        try {
            GeminiResponse parsed = GeminiResponse.parse(response.getBody());

            if (parsed.errors != null) {

                for (GeminiResponse.Error error : parsed.errors)
                    errorMessage += '\n Message: ' + error.message + '\n Code: ' + error.code;
            }
        } catch (Exception e) {
            errorMessage += '\n Response Body: ' + response.getBody();
        }

        throw new GeminiServiceErrorException(errorMessage);
    }

    public class GeminiServiceMissingInputException extends Exception {}
    public class GeminiServiceErrorException extends Exception {}
}
