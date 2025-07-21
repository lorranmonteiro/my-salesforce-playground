public with sharing class GitlabServiceFactory implements IServiceFactory {

    @TestVisible
    private static GitlabService mock;

    public static void setMock(Object mockInstance) {
        mock = (GitlabService) mockInstance;
    }

    public static GitlabService getService() {
        if (Test.isRunningTest() && mock == null) {
            return (GitlabService) new GitlabServiceMockSuccess();
        }
    
        return mock ?? new GitlabService();
    }
}
