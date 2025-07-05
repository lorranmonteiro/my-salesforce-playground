@isTest
public class SearchCmpTest {

    @IsTest
    static void shouldExtractResponse() {
        ServiceFactory.setMock(ServiceFactory.Service.OpenAI, new OpenAIService());
        Test.setMock(HttpCalloutMock.class, new OpenAIMockResponseSuccess());

        Test.startTest();
            String responseMessage = SearchCmp.search('Test');
        Test.stopTest();

        Assert.areEqual('Hello!', responseMessage, 'Expected response message to be "Hello!"');
    }

    @IsTest
    static void shouldHandleCalloutException() {
        ServiceFactory.setMock(ServiceFactory.Service.OpenAI, new OpenAIService());

        Test.startTest();
            try {
                SearchCmp.search('');
            } catch (AuraHandledException e) {
                Assert.areEqual(OpenAIService.MISSING_PARAMETERS_MESSAGE, e.getMessage(), 'Expected exception message');
            }
        Test.stopTest();
    }

    @IsTest
    static void shouldHandleError() {
        ServiceFactory.setMock(ServiceFactory.Service.OpenAI, new OpenAIService());
        Test.setMock(HttpCalloutMock.class, new OpenAIMockResponseError());

        Test.startTest();
            try {
                SearchCmp.search('Test');
            } catch (AuraHandledException e) {
                Assert.isTrue(e.getMessage().contains('Invalid API key'), 'Expected exception message');
            }
        Test.stopTest();
    }

    @IsTest
    static void shouldHandleParsingException() {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(401);

        Test.startTest();
            try {
                SearchCmp.handleError(response);
            } catch (AuraHandledException e) {
                Assert.isTrue(e.getMessage().contains('Error when getting OpenAI response'), 'Expected exception message');
            }
        Test.stopTest();
    }
}