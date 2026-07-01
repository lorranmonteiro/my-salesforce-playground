@IsTest
public class OpenAIMockResponseSuccess implements HttpCalloutMock {

    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setHeader('Content-Type', 'application/json');
        response.setBody(successJsonSample());

        return response;
    }

    private static String successJsonSample() {
        return '{\n' +
        '  "status": "completed",\n' +
        '  "output": [\n' +
        '    {\n' +
        '      "status": "completed",\n' +
        '      "content": [\n' +
        '        {\n' +
        '          "type": "text",\n' +
        '          "text": "Hello!"' +
        '        }\n' +
        '      ]\n' +
        '    },\n' +
        '    {\n' +
        '      "status": "incomplete",\n' +
        '      "content": []\n' +
        '    }\n' +
        '  ]\n' +
        '}';
    }
}
