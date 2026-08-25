@IsTest
private class GeminiServiceFactoryTest {

    @IsTest
    static void shouldReturnGeminiServiceInstance() {
        GeminiServiceFactory.setMock(new GeminiService());

        Test.startTest();
            IAIService service = GeminiServiceFactory.getService();
        Test.stopTest();

        Assert.isTrue(service instanceof GeminiService, 'Service should be GeminiService');
    }

    @IsTest
    static void shouldReturnGeminiServiceMockSuccessInstance() {
        Test.startTest();
            IAIService service = GeminiServiceFactory.getService();
        Test.stopTest();

        Assert.isTrue(service instanceof GeminiServiceMockSuccess, 'Service should be GeminiServiceMockSuccess');
    }
}
