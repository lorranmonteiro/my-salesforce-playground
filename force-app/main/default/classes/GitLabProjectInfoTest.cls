@isTest
public class GitLabProjectInfoTest {

    @IsTest
    static void shouldGetProjectDetails() {
        Test.setMock(HttpCalloutMock.class, new GitlabServiceMockSuccess());

        Test.startTest();
            GitLabProject projectDetails = GitLabProjectInfo.getProjectDetails();
        Test.stopTest();

        Assert.areEqual('Salesforce Playground', projectDetails.name, 'Expected project name to be "Salesforce Playground"');
    }

    @isTest
    static void shouldHandleGitlabException() {
        Test.setMock(HttpCalloutMock.class, new GitlabServiceMockNotFound());

        Test.startTest();
            try {
                GitLabProjectInfo.getProjectDetails();
            } catch (AuraHandledException e) {
                Assert.isTrue(e.getMessage().contains('404 Project Not Found'), 'Expected exception message to contain "404 Project Not Found"');
            }
        Test.stopTest();
    }

    @isTest
    static void shouldGetResponseFromCache() {
        Test.startTest();
            GitLabProject cachedProject = GitLabProjectInfo.getCachedProjectDetails();
        Test.stopTest();

        Assert.isNull(cachedProject, 'Expected null result');
    }
}