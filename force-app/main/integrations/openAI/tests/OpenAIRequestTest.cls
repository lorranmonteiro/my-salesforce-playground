@IsTest
private class OpenAIRequestTest {

    @IsTest
    static void testOpenAIRequest() {
        OpenAIRequest request = new OpenAIRequest('test input');

        Assert.areEqual('test input', request.input, 'Input should match the provided value');
        Assert.isFalse(request.store, 'Store should be false by default');
        Assert.areEqual(IntegrationSetting__mdt.getInstance(OpenAIRequest.OPENAI_MODEL).Id__c, request.model,
                        'Model should match the integration setting value');
    }
}
