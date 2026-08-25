@IsTest
public class GeminiMockResponseError implements HttpCalloutMock {

    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(401);
        response.setHeader('Content-Type', 'application/json');
        response.setBody(getGeminiResponseErrorJsonSample());

        return response;
    }

    private static String getGeminiResponseErrorJsonSample() {
        return '''
        {
            "id": "response-id",
            "status": "failed",
            "created": "2024-06-01T12:00:00Z",
            "object": "response",
            "model": "gemini-model",
            "errors": [{
                "code": "invalid_request",
                "message": "The model failed to generate a valid response."
            }]
        }
        ''';
    }
}
