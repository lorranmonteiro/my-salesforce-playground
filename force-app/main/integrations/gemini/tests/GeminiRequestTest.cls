@IsTest
private class GeminiRequestTest {

    @IsTest
    static void testGeminiRequest() {
        GeminiRequest request = new GeminiRequest('test input');

        Assert.areEqual('test input', request.input, 'Input should match the provided value');
        Assert.isNotNull(request.model, 'Model should not be null');
    }
}
