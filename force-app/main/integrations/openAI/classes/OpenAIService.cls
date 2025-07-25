public virtual with sharing class OpenAIService {

    private static final String OPENAI_API = 'callout:OpenAIAPI';
    private static final String OPENAI_RESPONSE_ENDPOINT = 'OpenAIGetResponse';

    @TestVisible
    private static final String MISSING_PARAMETERS_MESSAGE = 'Request body or text input is missing.';

    public virtual HttpResponse requestResponse(OpenAIRequest requestBody) {
        if (requestBody == null || String.isBlank(requestBody.input)) {
            throw new OpenAIServiceMissingParametersException(MISSING_PARAMETERS_MESSAGE);
        }

        IntegrationEndpoint__mdt responseEndpoint = IntegrationEndpoint__mdt.getInstance(OPENAI_RESPONSE_ENDPOINT);

        HttpRequest request = new HttpRequest();
        request.setMethod(responseEndpoint.Method__c);
        request.setHeader('Content-Type', responseEndpoint.ContentType__c);
        request.setEndpoint(OPENAI_API + responseEndpoint.Endpoint__c);
        request.setBody(JSON.serialize(requestBody));

        HttpResponse response = new Http().send(request);
        LogService.logIntegrationCallout(request, response);

        return response;
    }

    public class OpenAIServiceMissingParametersException extends Exception {}
}
