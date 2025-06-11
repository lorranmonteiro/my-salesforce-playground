@isTest
public class AccountAPITest {

    private static final Constants.HttpStatus HTTP_STATUS = Constants.HTTP_STATUS;

    @isTest
    static void getAccount() {
        Account account = new Account(Name = 'Test Account');
        insert account;

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

    @isTest
    static void getAccountRequestWithoutId() {
        Account account = new Account(Name = 'Test Account');
        insert account;

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1/accounts/'; // No ID in the URI
        req.httpMethod = 'GET';
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
            AccountAPI.getAccountById();
        Test.stopTest();

        AccountAPI.ResponseWrapper responseBody =
            (AccountAPI.ResponseWrapper) JSON.deserialize(res.responseBody.toString(), AccountAPI.ResponseWrapper.class);

        Assert.areEqual(HTTP_STATUS.BAD_REQUEST, res.statusCode, 'Expected status code 400');
        Assert.isFalse(responseBody.success, 'Expected success to be false');
        Assert.isNotNull(responseBody.message, 'Expected error message about missing ID');
    }

    @isTest
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

        AccountAPI.ResponseWrapper responseBody =
            (AccountAPI.ResponseWrapper) JSON.deserialize(res.responseBody.toString(), AccountAPI.ResponseWrapper.class);

        Assert.areEqual(404, res.statusCode, 'Expected status code 404');
        Assert.isFalse(responseBody.success, 'Expected success to be false');
        Assert.isNotNull(responseBody.message, 'Expected error message about account not found');
    }

    @isTest
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

        AccountAPI.ResponseWrapper responseBody =
            (AccountAPI.ResponseWrapper) JSON.deserialize(res.responseBody.toString(), AccountAPI.ResponseWrapper.class);

        Assert.areEqual(HTTP_STATUS.INTERNAL_SERVER_ERROR, res.statusCode, 'Expected status code 500');
        Assert.isFalse(responseBody.success, 'Expected success to be false');
        Assert.isNotNull(responseBody.message, 'Expected error message about internal error');
    }

    @isTest
    static void updateAccount() {
        Account account = new Account(Name = 'Test Account', AccountNumber = '12345');
        insert account;

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

    @isTest
    static void updateAccountWithNullName() {
        Account account = new Account(Name = 'Test Account', AccountNumber = '12345');
        insert account;

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

        AccountAPI.ResponseWrapper responseBody =
            (AccountAPI.ResponseWrapper) JSON.deserialize(res.responseBody.toString(), AccountAPI.ResponseWrapper.class);

        Assert.areEqual(HTTP_STATUS.BAD_REQUEST, res.statusCode, 'Expected status code 400');
        Assert.isFalse(responseBody.success, 'Expected success to be false');
        Assert.isNotNull(responseBody.message, 'Expected error message about missing Name field');
    }

    @isTest
    static void updateAccountWithInvalidId() {
        Account account = new Account(Name = 'Test Account', AccountNumber = '12345');
        insert account;

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

        AccountAPI.ResponseWrapper responseBody =
            (AccountAPI.ResponseWrapper) JSON.deserialize(res.responseBody.toString(), AccountAPI.ResponseWrapper.class);

        Assert.areEqual(HTTP_STATUS.INTERNAL_SERVER_ERROR, res.statusCode, 'Expected status code 500');
        Assert.isFalse(responseBody.success, 'Expected success to be false');
        Assert.isNotNull(responseBody.message, 'Expected error message about internal error');
    }

    @isTest
    static void createAccountWithContact() {
        Account account = new Account(Name = 'Test Account', AccountNumber = '12345');
        Contact contact = new Contact(FirstName = 'This is', LastName = 'a Test');

        String payload = JSON.serialize(new AccountAPI.AccountWithContact(account, contact));

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/AccountAPI';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(payload);
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
            AccountAPI.createAccountWithContact();
        Test.stopTest();

        AccountAPI.AccountWithContact responseBody = (AccountAPI.AccountWithContact) JSON.deserialize(
            res.responseBody.toString(),
            AccountAPI.AccountWithContact.class
        );

        Assert.areEqual(HTTP_STATUS.CREATED, res.statusCode, 'Expected status code 200');
        Assert.isNotNull(responseBody.account.Id, 'Expected account ID to be set');
        Assert.isNotNull(responseBody.contact.Id, 'Expected contact ID to be set');
    }

    @isTest
    static void createAccountWithContactEmptyRequestBody() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/AccountAPI';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(''); // Empty request body
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
            AccountAPI.createAccountWithContact();
        Test.stopTest();

        AccountAPI.ResponseWrapper responseBody =
            (AccountAPI.ResponseWrapper) JSON.deserialize(res.responseBody.toString(), AccountAPI.ResponseWrapper.class);

        Assert.areEqual(HTTP_STATUS.BAD_REQUEST, res.statusCode, 'Expected status code 400');
        Assert.isFalse(responseBody.success, 'Expected success to be false');
        Assert.isNotNull(responseBody.message, 'Expected error message about empty request body');
    }

    @isTest
    static void createAccountWithContactInvalidRequestBody() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/AccountAPI';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(''); // Empty request body
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
            AccountAPI.createAccountWithContact();
        Test.stopTest();

        AccountAPI.ResponseWrapper responseBody =
            (AccountAPI.ResponseWrapper) JSON.deserialize(res.responseBody.toString(), AccountAPI.ResponseWrapper.class);

        Assert.areEqual(HTTP_STATUS.BAD_REQUEST, res.statusCode, 'Expected status code 400');
        Assert.isFalse(responseBody.success, 'Expected success to be false');
        Assert.isNotNull(responseBody.message, 'Expected error message about empty request body');
    }

    @isTest
    static void createAccountWithContactMissingContactInRequestBody() {
        Account account = new Account(Name = 'Test Account', AccountNumber = '12345');

        String payload = JSON.serialize(new AccountAPI.AccountWithContact(account, null));

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/AccountAPI';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(payload);
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
            AccountAPI.createAccountWithContact();
        Test.stopTest();

        AccountAPI.ResponseWrapper responseBody =
            (AccountAPI.ResponseWrapper) JSON.deserialize(res.responseBody.toString(), AccountAPI.ResponseWrapper.class);

        Assert.areEqual(HTTP_STATUS.BAD_REQUEST, res.statusCode, 'Expected status code 400');
        Assert.isFalse(responseBody.success, 'Expected success to be false');
        Assert.isNotNull(responseBody.message, 'Expected error message about invalid payload');
    }

    @isTest
    static void createAccountWithContactMissingFieldInRequestBody() {
        Account account = new Account(Name = 'Test Account', AccountNumber = '12345');
        Contact contact = new Contact(FirstName = 'This is'); // Missing LastName, should fail insertion

        String payload = JSON.serialize(new AccountAPI.AccountWithContact(account, contact));

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/AccountAPI';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(payload);
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
            AccountAPI.createAccountWithContact();
        Test.stopTest();

        AccountAPI.ResponseWrapper responseBody =
            (AccountAPI.ResponseWrapper) JSON.deserialize(res.responseBody.toString(), AccountAPI.ResponseWrapper.class);

        Assert.areEqual(HTTP_STATUS.BAD_REQUEST, res.statusCode, 'Expected status code 400');
        Assert.isFalse(responseBody.success, 'Expected success to be false');
        Assert.isNotNull(responseBody.message, 'Expected error message about Contact Missing LastName');
    }

    @isTest
    static void createAccountWithAccountMissingFieldInRequestBody() {
        Account account = new Account(AccountNumber = '12345'); // Missing Name, should fail insertion
        Contact contact = new Contact(FirstName = 'This is', LastName = 'a Test');

        String payload = JSON.serialize(new AccountAPI.AccountWithContact(account, contact));

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/AccountAPI';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(payload);
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
            AccountAPI.createAccountWithContact();
        Test.stopTest();

        AccountAPI.ResponseWrapper responseBody =
            (AccountAPI.ResponseWrapper) JSON.deserialize(res.responseBody.toString(), AccountAPI.ResponseWrapper.class);

        Assert.areEqual(HTTP_STATUS.BAD_REQUEST, res.statusCode, 'Expected status code 400');
        Assert.isFalse(responseBody.success, 'Expected success to be false');
        Assert.isNotNull(responseBody.message, 'Expected error message about Contact Missing LastName');
    }

    @isTest
    static void deleteAccount() {
        Account account = new Account(Name = 'Test Account', AccountNumber = '12345');
        insert account;

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
}