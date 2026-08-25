@IsTest
public class GeminiMockResponseSuccess implements HttpCalloutMock {

    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setHeader('Content-Type', 'application/json');
        response.setBody(successJsonSample());

        return response;
    }

    private static String successJsonSample() {
        return '{' +
            '"id": "response-id",' +
            '"status": "success",' +
            '"created": "2024-06-01T12:00:00Z",' +
            '"object": "response",' +
            '"model": "gemini-model",' +
            '"steps": [{' +
                '"type": "output",' +
                '"content": {' +
                    '"type": "text",' +
                    '"text": "Hello from Gemini!"' +
                '}' +
            '}]' +
        '}';
    }
}
