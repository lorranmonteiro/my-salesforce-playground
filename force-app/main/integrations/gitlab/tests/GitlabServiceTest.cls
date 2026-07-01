@IsTest
public class GitlabServiceTest {

    @IsTest
    static void shouldRequestProjectDetails() {
        Test.setMock(HttpCalloutMock.class, new GitlabMockGetProjectSuccess());

        Test.startTest();
            GitlabServiceFactory.setMock(new GitlabService());
            GitlabService gitlabService = GitlabServiceFactory.getService();

            HttpResponse response = gitlabService.requestProjectDetails();
        Test.stopTest();

        Assert.areEqual(200, response.getStatusCode(), 'Expected status code 200');
    }

    @IsTest
    static void shouldPostNoteOnMergeRequest() {
        Test.setMock(HttpCalloutMock.class, new GitlabMockPostNoteOnMergeRequestSuccess());

        GitlabMergeRequestNote noteRequest = new GitlabMergeRequestNote('This is a test note', false);

        Test.startTest();
            GitlabServiceFactory.setMock(new GitlabService());
            GitlabService gitlabService = GitlabServiceFactory.getService();

            HttpResponse response = gitlabService.postNoteIntoMergeRequest(noteRequest);
        Test.stopTest();

        Assert.areEqual(200, response.getStatusCode(), 'Expected status code 200');
    }

    @IsTest
    static void shouldThrowMissingParameterOnPostNoteOnMergeRequestWhenSendBlankBody() {
        GitlabMergeRequestNote noteRequest = new GitlabMergeRequestNote(null, false);

        Test.startTest();
            try {
                GitlabServiceFactory.setMock(new GitlabService());
                GitlabService gitlabService = GitlabServiceFactory.getService();

                gitlabService.postNoteIntoMergeRequest(noteRequest);
            } catch (GitlabService.GitlabServiceMissingParametersException e) {
                Assert.areEqual(e.getMessage(), GitlabService.NOTE_EMPTY_MESSAGE, 'Expected exception message');
            }
        Test.stopTest();
    }
}
