@IsTest
private class AccountCollectionAPITest {

    private static final Constants.HttpStatus HTTP_STATUS = Constants.getInstance().HTTP_STATUS;

    @IsTest
    static void getAccounts() {
        Account account = TestAccountFactory.createAccount(true);

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1/accounts';
        req.httpMethod = 'GET';
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
            AccountCollectionAPI.getAllAccounts();
        Test.stopTest();

        List<Account> responseBody = (List<Account>) JSON.deserialize(res.responseBody.toString(), List<Account>.class);

        Assert.areEqual(HTTP_STATUS.OK, res.statusCode, 'Expected status code 200');
        Assert.areEqual(account.Id, responseBody[0].Id, 'Expected account ID to match');
    }

    @IsTest
    static void createAccountWithContact() {
        Account account = new Account(Name = 'Test Account', AccountNumber = '12345');
        Contact contact = new Contact(FirstName = 'This is', LastName = 'a Test');

        String payload = JSON.serialize(new AccountCollectionAPI.AccountWithContact(account, contact));

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1/accounts';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(payload);
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
            AccountCollectionAPI.createAccountWithContact();
        Test.stopTest();

        AccountCollectionAPI.AccountWithContact responseBody = (AccountCollectionAPI.AccountWithContact) JSON.deserialize(
            res.responseBody.toString(),
            AccountCollectionAPI.AccountWithContact.class
        );

        Assert.areEqual(HTTP_STATUS.CREATED, res.statusCode, 'Expected status code 200');
        Assert.isNotNull(responseBody.account.Id, 'Expected account ID to be set');
        Assert.isNotNull(responseBody.contact.Id, 'Expected contact ID to be set');
    }

    @IsTest
    static void createAccountWithContactEmptyRequestBody() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1/accounts';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(''); // Empty request body
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
            AccountCollectionAPI.createAccountWithContact();
        Test.stopTest();

        APIErrorResponse responseBody = (APIErrorResponse) JSON.deserialize(res.responseBody.toString(), APIErrorResponse.class);

        Assert.areEqual(HTTP_STATUS.BAD_REQUEST, res.statusCode, 'Expected status code 400');
        Assert.isNotNull(responseBody.message, 'Expected error message about empty request body');
    }

    @IsTest
    static void createAccountWithContactInvalidRequestBody() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1/accounts';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(''); // Empty request body
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
            AccountCollectionAPI.createAccountWithContact();
        Test.stopTest();

        APIErrorResponse responseBody = (APIErrorResponse) JSON.deserialize(res.responseBody.toString(), APIErrorResponse.class);

        Assert.areEqual(HTTP_STATUS.BAD_REQUEST, res.statusCode, 'Expected status code 400');
        Assert.isNotNull(responseBody.message, 'Expected error message about empty request body');
    }

    @IsTest
    static void createAccountWithContactMissingContactInRequestBody() {
        Account account = new Account(Name = 'Test Account', AccountNumber = '12345');

        String payload = JSON.serialize(new AccountCollectionAPI.AccountWithContact(account, null));

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1/accounts';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(payload);
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
            AccountCollectionAPI.createAccountWithContact();
        Test.stopTest();

        APIErrorResponse responseBody = (APIErrorResponse) JSON.deserialize(res.responseBody.toString(), APIErrorResponse.class);

        Assert.areEqual(HTTP_STATUS.BAD_REQUEST, res.statusCode, 'Expected status code 400');
        Assert.isNotNull(responseBody.message, 'Expected error message about invalid payload');
    }

    @IsTest
    static void createAccountWithContactMissingFieldInRequestBody() {
        Account account = new Account(Name = 'Test Account', AccountNumber = '12345');
        Contact contact = new Contact(FirstName = 'This is'); // Missing LastName, should fail insertion

        String payload = JSON.serialize(new AccountCollectionAPI.AccountWithContact(account, contact));

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1/accounts';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(payload);
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
            AccountCollectionAPI.createAccountWithContact();
        Test.stopTest();

        APIErrorResponse responseBody = (APIErrorResponse) JSON.deserialize(res.responseBody.toString(), APIErrorResponse.class);

        Assert.areEqual(HTTP_STATUS.BAD_REQUEST, res.statusCode, 'Expected status code 400');
        Assert.isNotNull(responseBody.message, 'Expected error message about Contact Missing LastName');
    }

    @IsTest
    static void createAccountWithAccountMissingFieldInRequestBody() {
        Account account = new Account(AccountNumber = '12345'); // Missing Name, should fail insertion
        Contact contact = new Contact(FirstName = 'This is', LastName = 'a Test');

        String payload = JSON.serialize(new AccountCollectionAPI.AccountWithContact(account, contact));

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1/accounts';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(payload);
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
            AccountCollectionAPI.createAccountWithContact();
        Test.stopTest();

        APIErrorResponse responseBody = (APIErrorResponse) JSON.deserialize(res.responseBody.toString(), APIErrorResponse.class);

        Assert.areEqual(HTTP_STATUS.BAD_REQUEST, res.statusCode, 'Expected status code 400');
        Assert.isNotNull(responseBody.message, 'Expected error message about Contact Missing LastName');
    }
}
