@isTest
public class GitlabServiceTest {

    @IsTest
    static void shouldRequestProjectDetails() {
        Test.setMock(HttpCalloutMock.class, new GitlabServiceMockSuccess());

        Test.startTest();
            HttpResponse response = GitlabService.requestProjectDetails();
        Test.stopTest();

        Assert.areEqual(200, response.getStatusCode(), 'Expected status code 200');
    }
}