public with sharing class GeminiServiceFactory {

    @TestVisible
    private static GeminiService mock;

    public static void setMock(GeminiService mockInstance) {
        mock = mockInstance;
    }

    public static GeminiService getService() {
        if (Test.isRunningTest() && mock == null)
            return new GeminiServiceMockSuccess();

        return mock ?? new GeminiService();
    }
}
