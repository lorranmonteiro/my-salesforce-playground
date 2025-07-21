public with sharing class OpenAiServiceFactory implements IServiceFactory {

    @TestVisible
    private static OpenAIService mock;

    public static void setMock(Object mockInstance) {
        mock = (OpenAIService) mockInstance;
    }

    public static OpenAIService getService() {
        if (Test.isRunningTest() && mock == null) {
            return (OpenAIService) new OpenAIServiceMockSuccess();
        }

        return mock ?? new OpenAIService();
    }
}
