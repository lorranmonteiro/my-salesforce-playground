@IsTest
public class OpenAIMockResponseError implements HttpCalloutMock {

    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(401);
        response.setHeader('Content-Type', 'application/json');
        response.setBody(getOpenAIResponseErrorJsonSample());

        return response;
    }

    private static String getOpenAIResponseErrorJsonSample() {
        return '{\n' +
        '  "status": "failed",\n' +
        '  "output": [],\n' +
        '  "error": {\n' +
        '    "message": "Invalid API key.",\n' +
        '    "code": "401",\n' +
        '    "type": "authentication_error",\n' +
        '    "param": "api_key"\n' +
        '  }\n' +
        '}';
    }
}
