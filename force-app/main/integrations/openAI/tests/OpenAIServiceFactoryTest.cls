@IsTest
private class OpenAIServiceFactoryTest {

    @IsTest
    static void shouldReturnOpenAIServiceInstance() {
        OpenAIServiceFactory.setMock(new OpenAIService());

        Test.startTest();
            IAIService service = OpenAIServiceFactory.getService();
        Test.stopTest();

        Assert.isTrue(service instanceof OpenAIService, 'Service should be OpenAIService');
    }

    @IsTest
    static void shouldReturnOpenAIServiceMockSuccessInstance() {
        Test.startTest();
            IAIService service = OpenAIServiceFactory.getService();
        Test.stopTest();

        Assert.isTrue(service instanceof OpenAIServiceMockSuccess, 'Service should be OpenAIServiceMockSuccess');
    }
}
