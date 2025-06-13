public class GitlabServiceFactory {

    @TestVisible
    private static GitlabService mockInstance;

    public static void setMock(GitlabService mock) {
        mockInstance = mock;
    }

    public static GitlabService getInstance() {
        if (Test.isRunningTest() || mockInstance != null) {
            return mockInstance ?? new GitlabServiceMockSuccess();
        }
    
        return new GitlabService();
    }
}