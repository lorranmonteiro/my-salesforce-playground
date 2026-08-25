@IsTest
private class SearchCmpTest {

    @IsTest
    static void shouldReturnResponse() {
        Test.startTest();
            String responseMessage = SearchCmp.search('Test');
        Test.stopTest();

        Assert.areEqual('Test', responseMessage, 'Expected response message to be "Test"');
    }

    @IsTest
    static void shouldHandleServiceException() {
        AIServiceFactory.mockProvider = '';

        Test.startTest();
            try {
                SearchCmp.search('Test');
            } catch (AuraHandledException e) {
                Assert.isNotNull(e.getMessage(), 'Expected error message to be present');
            }
        Test.stopTest();
    }
}
