@isTest
public class GitlabMockPostNoteOnMergeRequestSuccess implements HttpCalloutMock {

    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setHeader('Content-Type', 'application/json');

        return response;
    }
}