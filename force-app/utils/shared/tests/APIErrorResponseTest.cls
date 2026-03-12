@isTest
private class APIErrorResponseTest {

    @isTest
    static void setErrorMessage() {
        String errorMessage = 'This is an error message';

        APIErrorResponse error = new APIErrorResponse(errorMessage);

        Assert.areEqual(errorMessage, error.message, 'Should set message on ErrorResponse parser');
    }
}
