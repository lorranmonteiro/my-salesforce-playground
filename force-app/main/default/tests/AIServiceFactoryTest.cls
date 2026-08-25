@IsTest
private class AIServiceFactoryTest {

    @IsTest
    static void shouldReturnGeminiServiceWhenProviderOverridden() {
        AIServiceFactory.mockProvider = 'Gemini';

        Test.startTest();
            IAIService service = AIServiceFactory.getService();
        Test.stopTest();

        Assert.isTrue(service instanceof GeminiServiceMockSuccess, 'Service should be GeminiService');
    }

    @IsTest
    static void shouldReturnOpenAIServiceWhenProviderOverriddenToOpenAI() {
        AIServiceFactory.mockProvider = 'Openai';

        Test.startTest();
            IAIService service = AIServiceFactory.getService();
        Test.stopTest();

        Assert.isTrue(service instanceof OpenAIService, 'Service should be OpenAIService');
    }

    @IsTest
    static void shouldRaiseExceptionWhenProviderIsInvalid() {
        AIServiceFactory.mockProvider = 'Test';

        Test.startTest();
            try {
                IAIService service = AIServiceFactory.getService();
            } catch (AIServiceFactory.AIServiceFactoryNotValidProviderException e) {
                Assert.isTrue(e.getMessage().contains('The AI provider is not valid'), 'Exception message should indicate invalid provider');
            }
        Test.stopTest();
    }
}
