@isTest
public class OpenAIServiceMockSuccess extends OpenAIService {

    public override HttpResponse requestResponse(OpenAIRequest requestBody) {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setBody(successJsonSample());
        response.setHeader('Content-Type', 'application/json');

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
        '    }\n' +
        '  ]\n' +
        '}';
    }
}