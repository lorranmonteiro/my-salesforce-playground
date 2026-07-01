@IsTest
private class OpenAIResponseTest {

    @IsTest
    static void testParseOnSuccess() {
        String json = getResponseSuccessJsonSample();

        Test.startTest();
            OpenAIResponse response = OpenAIResponse.parse(json);
        Test.stopTest();

        Assert.areEqual('Hello!', response.output[0].content[0].text, 'Expected text to be "Hello!"');
    }

    @IsTest
    static void testParseOnFail() {
        String json = getOpenAIResponseErrorJsonSample();

        Test.startTest();
            OpenAIResponse response = OpenAIResponse.parse(json);
        Test.stopTest();

        Assert.areEqual('401', response.error.code, 'Expected error code to be 401');
    }

    private static String getResponseSuccessJsonSample() {
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
