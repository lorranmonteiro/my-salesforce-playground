@IsTest
public class OpenAIServiceTest {

    @IsTest
    static void shouldRequestResponseFromOpenAI() {
        Test.setMock(HttpCalloutMock.class, new OpenAIMockResponseSuccess());

        Test.startTest();
            OpenAiServiceFactory.setMock(new OpenAIService());
            OpenAIService openAIService = OpenAiServiceFactory.getService();

            OpenAIRequest requestBody = new OpenAIRequest('test input');
            HttpResponse response = openAIService.requestResponse(requestBody);
        Test.stopTest();

        Assert.areEqual(200, response.getStatusCode(), 'Expected status code 200');
    }

    @IsTest
    static void shouldThrowMissingParameterOnRequestOpenAI() {
        Test.startTest();
            try {
                OpenAiServiceFactory.setMock(new OpenAIService());
                OpenAIService openAIService = OpenAiServiceFactory.getService();

                OpenAIRequest requestBody = new OpenAIRequest('');
                openAIService.requestResponse(requestBody);
            } catch (OpenAIService.OpenAIServiceMissingParametersException e) {
                Assert.areEqual(e.getMessage(), OpenAIService.MISSING_PARAMETERS_MESSAGE, 'Expected exception message');
            }
        Test.stopTest();
    }
}
