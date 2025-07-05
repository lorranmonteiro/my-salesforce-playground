@isTest
public class OpenAIServiceTest {

    @IsTest
    static void shouldRequestResponseFromOpenAI() {
        Test.setMock(HttpCalloutMock.class, new OpenAIMockResponseSuccess());

        Test.startTest();
            ServiceFactory.setMock(ServiceFactory.Service.OpenAI, new OpenAIService());
            OpenAIService openAIService = ServiceFactory.getOpenAIService();

            OpenAIRequest requestBody = new OpenAIRequest('test input');
            HttpResponse response = openAIService.requestResponse(requestBody);
        Test.stopTest();

        Assert.areEqual(200, response.getStatusCode(), 'Expected status code 200');
    }

    @IsTest
    static void shouldThrowMissingParameterOnRequestOpenAI() {
        Test.startTest();
            try {
                ServiceFactory.setMock(ServiceFactory.Service.OpenAI, new OpenAIService());
                OpenAIService openAIService = ServiceFactory.getOpenAIService();

                OpenAIRequest requestBody = new OpenAIRequest('');
                openAIService.requestResponse(requestBody);
            } catch (OpenAIService.OpenAIServiceMissingParametersException e) {
                Assert.areEqual(e.getMessage(), OpenAIService.MISSING_PARAMETERS_MESSAGE, 'Expected exception message');
            }
        Test.stopTest();
    }
}