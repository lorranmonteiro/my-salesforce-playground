@IsTest
private class AccountAPITest {

    private static final Constants.HttpStatus HTTP_STATUS = Constants.getInstance().HTTP_STATUS;

    @IsTest
    static void getAccount() {
        Account account = TestAccountFactory.createAccount(true);

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1/accounts/' + account.Id;
        req.httpMethod = 'GET';
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
            AccountAPI.getAccountById();
        Test.stopTest();

        Account responseBody = (Account) JSON.deserialize(res.responseBody.toString(), Account.class);

        Assert.areEqual(HTTP_STATUS.OK, res.statusCode, 'Expected status code 200');
        Assert.areEqual(account.Id, responseBody.Id, 'Expected account ID to match');
    }

    @IsTest
    static void getAccountRequestWithoutId() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1/accounts/'; // No ID in the URI
        req.httpMethod = 'GET';
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
            AccountAPI.getAccountById();
        Test.stopTest();

        APIErrorResponse responseBody = (APIErrorResponse) JSON.deserialize(res.responseBody.toString(), APIErrorResponse.class);

        Assert.areEqual(HTTP_STATUS.BAD_REQUEST, res.statusCode, 'Expected status code 400');
        Assert.isNotNull(responseBody.message, 'Expected error message about missing ID');
    }

    @IsTest
    static void getAccountNotFound() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1/accounts/001aj000018x40sAAA'; // Non-existing ID
        req.httpMethod = 'GET';
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
            AccountAPI.getAccountById();
        Test.stopTest();

        APIErrorResponse responseBody = (APIErrorResponse) JSON.deserialize(res.responseBody.toString(), APIErrorResponse.class);

        Assert.areEqual(404, res.statusCode, 'Expected status code 404');
        Assert.isNotNull(responseBody.message, 'Expected error message about account not found');
    }

    @IsTest
    static void getAccountInternalError() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1/accounts/123'; // Invalid ID
        req.httpMethod = 'GET';
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
            AccountAPI.getAccountById();
        Test.stopTest();

        APIErrorResponse responseBody = (APIErrorResponse) JSON.deserialize(res.responseBody.toString(), APIErrorResponse.class);

        Assert.areEqual(HTTP_STATUS.INTERNAL_SERVER_ERROR, res.statusCode, 'Expected status code 500');
        Assert.isNotNull(responseBody.message, 'Expected error message about internal error');
    }

    @IsTest
    static void updateAccount() {
        Account account = TestAccountFactory.createAccount(true);

        String payload = JSON.serialize(new Account(AccountNumber = '67890'));

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1/accounts/' + account.Id;
        req.httpMethod = 'PATCH';
        req.requestBody = Blob.valueOf(payload);
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
            AccountAPI.updateAccount();
        Test.stopTest();

        Account responseBody = (Account) JSON.deserialize(
            res.responseBody.toString(),
            Account.class
        );

        Account updatedAccount = [SELECT AccountNumber FROM Account WHERE Id = :account.Id];

        Assert.areEqual(HTTP_STATUS.OK, res.statusCode, 'Expected status code 200');
        Assert.isNotNull(responseBody.Id, 'Expected account ID to be retuned');
        Assert.isNotNull(responseBody.AccountNumber, 'Expected account number to be updated');
        Assert.areEqual('67890', updatedAccount.AccountNumber, 'Expected account number to be updated to 67890');
    }

    @IsTest
    static void updateAccountWithNullName() {
        Account account = TestAccountFactory.createAccount(true);

        String payload = JSON.serialize(new Account(Name = null, AccountNumber = '67890'));

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1/accounts/' + account.Id;
        req.httpMethod = 'PATCH';
        req.requestBody = Blob.valueOf(payload);
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
            AccountAPI.updateAccount();
        Test.stopTest();

        APIErrorResponse responseBody = (APIErrorResponse) JSON.deserialize(res.responseBody.toString(), APIErrorResponse.class);

        Assert.areEqual(HTTP_STATUS.BAD_REQUEST, res.statusCode, 'Expected status code 400');
        Assert.isNotNull(responseBody.message, 'Expected error message about missing Name field');
    }

    @IsTest
    static void updateAccountWithInvalidId() {
        String payload = JSON.serialize(new Account(Name = null, AccountNumber = '67890'));

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1/accounts/123'; // Invalid ID
        req.httpMethod = 'PATCH';
        req.requestBody = Blob.valueOf(payload);
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
            AccountAPI.updateAccount();
        Test.stopTest();

        APIErrorResponse responseBody = (APIErrorResponse) JSON.deserialize(res.responseBody.toString(), APIErrorResponse.class);

        Assert.areEqual(HTTP_STATUS.INTERNAL_SERVER_ERROR, res.statusCode, 'Expected status code 500');
        Assert.isNotNull(responseBody.message, 'Expected error message about internal error');
    }

    @IsTest
    static void deleteAccount() {
        Account account = TestAccountFactory.createAccount(true);

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1/accounts/' + account.Id;
        req.httpMethod = 'DELETE';
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
            AccountAPI.deleteAccount();
        Test.stopTest();

        List<Account> accounts = [SELECT AccountNumber FROM Account WHERE Id = :account.Id];

        Assert.areEqual(HTTP_STATUS.NO_CONTENT, res.statusCode, 'Expected status code 204');
        Assert.isTrue(accounts.isEmpty(), 'Expected account to be deleted');
    }

    @IsTest
    static void deleteAccountWithInvalidId() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1/accounts/121';
        req.httpMethod = 'DELETE';
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
            AccountAPI.deleteAccount();
        Test.stopTest();

        APIErrorResponse responseBody = (APIErrorResponse) JSON.deserialize(res.responseBody.toString(), APIErrorResponse.class);

        Assert.areEqual(HTTP_STATUS.INTERNAL_SERVER_ERROR, res.statusCode, 'Expected status code 500');
        Assert.isNotNull(responseBody.message, 'Expected error message about internal error');
    }
}
