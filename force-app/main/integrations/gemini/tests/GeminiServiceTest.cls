@IsTest
private class GeminiServiceTest {

    @IsTest
    static void shouldGetResponseFromGemini() {
        Test.setMock(HttpCalloutMock.class, new GeminiMockResponseSuccess());

        Test.startTest();
            GeminiService geminiService = new GeminiService();
            String response = geminiService.getResponse('test input');
        Test.stopTest();

        Assert.areEqual('Hello from Gemini!', response, 'Expected response message');
    }

    @IsTest
    static void shouldHandleErrorFromGemini() {
        Test.setMock(HttpCalloutMock.class, new GeminiMockResponseError());

        Test.startTest();
            try {
                GeminiService geminiService = new GeminiService();
                String response = geminiService.getResponse('test input');
            } catch (GeminiService.GeminiServiceErrorException e) {
                Assert.isTrue(e.getMessage().contains('Error when getting Gemini response'), 'Expected error message to contain "Error when getting Gemini response"');
            }
        Test.stopTest();
    }

    @IsTest
    static void shouldThrowMissingInputOnGetResponse() {
        Test.startTest();
            try {
                GeminiService geminiService = new GeminiService();
                geminiService.getResponse('');
            } catch (GeminiService.GeminiServiceMissingInputException e) {
                Assert.areEqual(GeminiService.MISSING_INPUT_MESSAGE, e.getMessage(), 'Expected exception message');
            }
        Test.stopTest();
    }
}
