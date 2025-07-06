@isTest
public class GitLabProjectInfoTest {

    @IsTest
    static void shouldGetProjectDetails() {
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
                ServiceFactory.setMock(ServiceFactory.Service.Gitlab, new GitlabService());
                GitLabProjectInfo.getProjectDetails();
            } catch (AuraHandledException e) {
                Assert.isTrue(e.getMessage().contains('404 Project Not Found'), 'Expected exception message to contain "404 Project Not Found"');
            }
        Test.stopTest();
    }

    @isTest
    static void shouldGetResponseFromCache() {
        GitLabProjectInfo.isCacheMockedForTesting = true;

        Test.startTest();
            GitLabProject cachedProject = GitLabProjectInfo.getProjectDetails();
        Test.stopTest();

        Assert.isNull(cachedProject, 'Expected null result');
    }
}