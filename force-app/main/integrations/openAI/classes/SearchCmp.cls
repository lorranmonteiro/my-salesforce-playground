public with sharing class SearchCmp {

    @AuraEnabled(cacheable = true)
    public static String search(String textInput){
        OpenAIRequest requestBody = new OpenAIRequest(textInput);
        OpenAIService openAI = OpenAiServiceFactory.getService();
        HttpResponse response;

        try {
            response = openAI.requestResponse(requestBody);
        } catch (Exception e) {
            AuraHandledException auraEx = new AuraHandledException(e.getMessage());
            auraEx.setMessage(e.getMessage());

            LogService.logException(e);
            throw auraEx;
        }

        if (response.getStatusCode() != 200) {
            handleError(response);
        }

        return extractOutputText(response.getBody());
    }

    private static String extractOutputText(String responseBody) {
        OpenAIResponse response = OpenAIResponse.parse(responseBody);
        String outputMessage = '';

        for (OpenAIResponse.Output output : response.output) {
            if (output.status != OpenAIResponse.ResponseStatus.completed || output.content == null) {
                continue;
            }
            for (OpenAIResponse.Content content : output.content) {
                outputMessage += content.text;
            }
        }

        return outputMessage.toString();
    }

    @TestVisible
    private static void handleError(HttpResponse response) {
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

        AuraHandledException error = new AuraHandledException(errorMessage);
        error.setMessage(errorMessage); // for testing purposes

        throw error;
    }
}
