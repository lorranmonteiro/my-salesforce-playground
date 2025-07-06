@isTest
public class GitlabServiceMockNotFound implements HttpCalloutMock {

    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(404);
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"message": "404 Project Not Found"}');

        return response;
    }
}