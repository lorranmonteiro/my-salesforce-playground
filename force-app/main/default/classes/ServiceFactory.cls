public class ServiceFactory {

    @TestVisible
    private static Map<Service, Object> mockInstances = new Map<Service, Object>();

    public static void setMock(Service key, Object mockInstance) {
        mockInstances.put(key, mockInstance);
    }

    public static GitlabService getGitlabService() {
        Object mock = mockInstances.get(Service.Gitlab);

        if (Test.isRunningTest() || mock != null) {
            return (GitlabService) mock ?? new GitlabServiceMockSuccess();
        }
    
        return new GitlabService();
    }

    public static OpenAIService getOpenAIService() {
        Object mock = mockInstances.get(Service.OpenAI);

        if (Test.isRunningTest() || mock != null) {
            return (OpenAIService) (mock ?? new OpenAIServiceMockSuccess());
        }

        return new OpenAIService();
    }

    @SuppressWarnings('PMD.FieldNamingConventions')
    public enum Service {
        Gitlab, OpenAI
    }
}