@IsTest
private class OpenAIServiceTest {

    @IsTest
    static void shouldRequestResponseFromOpenAI() {
        Test.setMock(HttpCalloutMock.class, new OpenAIMockResponseSuccess());

        Test.startTest();
            OpenAIService openAIService = new OpenAIService();
            String response = openAIService.getResponse('test input');
        Test.stopTest();

        Assert.areEqual('Hello!', response, 'Expected response message to be "Hello!"');
    }

    @IsTest
    static void shouldHandleErrorFromOpenAI() {
        Test.setMock(HttpCalloutMock.class, new OpenAIMockResponseError());

        Test.startTest();
            try {
                OpenAIService openAIService = new OpenAIService();
                openAIService.getResponse('test input');
            } catch (OpenAIService.OpenAIServiceErrorException e) {
                Assert.isTrue(e.getMessage().contains('Error when getting OpenAI response'), 'Expected error message to contain "Error when getting OpenAI response"');
            }
        Test.stopTest();
    }

    @IsTest
    static void shouldThrowMissingParameterOnRequestOpenAI() {
        Test.startTest();
            try {
                OpenAIService openAIService = new OpenAIService();
                openAIService.getResponse('');
            } catch (OpenAIService.OpenAIServiceMissingParametersException e) {
                Assert.areEqual(e.getMessage(), OpenAIService.MISSING_PARAMETERS_MESSAGE, 'Expected exception message');
            }
        Test.stopTest();
    }
}
