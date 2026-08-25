public virtual with sharing class OpenAIService implements IAIService {

    private static final String OPENAI_API = 'callout:OpenAIAPI';
    private static final String OPENAI_RESPONSE_ENDPOINT = '/v1/responses';

    @TestVisible
    private static final String MISSING_PARAMETERS_MESSAGE = 'Request body or text input is missing.';

    public virtual String getResponse(String input) {

        if (String.isBlank(input))
            throw new OpenAIServiceMissingParametersException(MISSING_PARAMETERS_MESSAGE);

        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setEndpoint(OPENAI_API + OPENAI_RESPONSE_ENDPOINT);
        request.setBody(JSON.serialize(new OpenAIRequest(input)));

        HttpResponse response = new Http().send(request);
        LogService.logIntegrationCallout(request, response);

        if (response.getStatusCode() != 200)
            handleError(response);

        return extractOutputText(response.getBody());
    }

    @TestVisible
    private String extractOutputText(String responseBody) {
        OpenAIResponse parsed = OpenAIResponse.parse(responseBody);
        String outputMessage = '';

        for (OpenAIResponse.Output output : parsed.output) {
            if (output.status != OpenAIResponse.ResponseStatus.completed || output.content == null) {
                continue;
            }
            for (OpenAIResponse.Content content : output.content) {
                outputMessage += content.text;
            }
        }

        return outputMessage;
    }

    @TestVisible
    private void handleError(HttpResponse response) {
        String errorMessage = 'Error when getting OpenAI response - \n StatusCode: ' + response.getStatusCode();

        try {
            OpenAIResponse parsed = OpenAIResponse.parse(response.getBody());
            errorMessage += '\n Message: ' + parsed.error?.message +
                            '\n Code: ' + parsed.error?.code +
                            '\n Type: ' + parsed.error?.type +
                            '\n Param: ' + parsed.error?.param;
        } catch (Exception e) {
            errorMessage += '\n Response Body: ' + response.getBody();
        }

        throw new OpenAIServiceErrorException(errorMessage);
    }

    public class OpenAIServiceMissingParametersException extends Exception {}
    public class OpenAIServiceErrorException extends Exception {}
}
