@IsTest
private class GeminiResponseTest {

    @IsTest
    static void testParseOnSuccess() {
        String json = getResponseSuccessJsonSample();

        Test.startTest();
            GeminiResponse response = GeminiResponse.parse(json);
        Test.stopTest();

        Assert.areEqual('Hello from Gemini!', response.steps[0].content.text, 'The text content should match the expected value');
    }

    private static String getResponseSuccessJsonSample() {
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
