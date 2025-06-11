@SuppressWarnings('PMD.ApexCRUDViolation')
@RestResource(urlMapping='/v1/accounts/*')
global with sharing class AccountAPI {

    private static final Constants.HttpStatus HTTP_STATUS = Constants.HTTP_STATUS;

    @HttpGet
    global static void getAccountById() {
        try {
            String accountId = getParameterInURL('/');
            
            if (!isRequestIdValid(accountId)) { return; }
            if (!doesAccountExist(accountId)) { return; }

            Account account = AccountSelector.getAccountById(accountId);

            returnSuccess(HTTP_STATUS.OK, JSON.serialize(account));
        } catch (Exception e) {
            returnError(HTTP_STATUS.INTERNAL_SERVER_ERROR, 'Internal error: ' + e.getMessage());
            return;
        }
    }

    @HttpPost
    global static void createAccountWithContact() {
        try {
            String requestBody = RestContext.request.requestBody.toString();

            if (!isRequestBodyValid(requestBody)) { return; }

            AccountWithContact accountWithContact = (AccountWithContact) JSON.deserialize(
                requestBody,
                AccountWithContact.class
            );

            if (accountWithContact == null || accountWithContact.account == null || accountWithContact.contact == null) {
                returnError(HTTP_STATUS.BAD_REQUEST, 'Invalid payload. Must include Account and Contact.');
                return;
            }

            try {
                insert accountWithContact.account;
            } catch (DmlException e) {
                throw new AccountWithContactDMLException('Failed to create Account: ' + e.getMessage());
            }

            try {
                accountWithContact.contact.AccountId = accountWithContact.account.Id;
                insert accountWithContact.contact;
            } catch (DmlException e) {
                throw new AccountWithContactDMLException('Failed to create Contact: ' + e.getMessage());
            }

            returnSuccess(HTTP_STATUS.CREATED, JSON.serialize(accountWithContact));
        } catch (AccountWithContactDMLException e) {
            returnError(HTTP_STATUS.BAD_REQUEST, e.getMessage());
        } catch (Exception e) {
            returnError(HTTP_STATUS.INTERNAL_SERVER_ERROR, 'Internal error: ' + e.getMessage());
        }
    }

    @HttpPatch
    global static void updateAccount() {
        try {
            String accountId = getParameterInURL('/');
            String requestBody = RestContext.request.requestBody.toString();

            if (!isRequestIdValid(accountId)) { return; }
            if (!isRequestBodyValid(requestBody)) { return; }
            if (!doesAccountExist(accountId)) { return; }

            Account account = (Account) JSON.deserialize(
                requestBody,
                Account.class
            );

            account.Id = accountId;

            try {
                update account;
            } catch (DmlException e) {
                returnError(HTTP_STATUS.BAD_REQUEST, 'Failed to update Account: ' + e.getMessage());
                return;
            }

            returnSuccess(HTTP_STATUS.OK, JSON.serialize(account));
        } catch (Exception e) {
            returnError(HTTP_STATUS.INTERNAL_SERVER_ERROR, 'Internal error: ' + e.getMessage());
        }
    }

    @HttpDelete
    global static void deleteAccount() {
        try {
            String accountId = getParameterInURL('/');

            if (!isRequestIdValid(accountId)) { return; }
            if (!doesAccountExist(accountId)) { return; }

            try {
                delete new Account(Id = accountId);
            } catch (DmlException e) {
                returnError(HTTP_STATUS.BAD_REQUEST, 'Failed to delete Account: ' + e.getMessage());
                return;
            }

            returnSuccess(HTTP_STATUS.NO_CONTENT, null);
        } catch (Exception e) {
            returnError(HTTP_STATUS.INTERNAL_SERVER_ERROR, 'Internal error: ' + e.getMessage());
        }
    }

    private static Boolean isRequestIdValid(String accountId) {
        if (!String.isBlank(accountId)) {
            return true;
        }

        returnError(HTTP_STATUS.BAD_REQUEST, 'Missing Account ID in URL');
        return false;
    }

    private static Boolean isRequestBodyValid(String requestBody) {
        if (!String.isBlank(requestBody)) {
            return true;
        }

        returnError(HTTP_STATUS.BAD_REQUEST, 'Request body is empty');
        return false;
    } 

    private static Boolean doesAccountExist(String accountId) {
        Account account = AccountSelector.getAccountById(accountId);
        
        if (account == null) {
            returnError(HTTP_STATUS.NOT_FOUND, 'Account not found');
            return false;
        }

        return true;
    }

    private static String getParameterInURL(String delimiter) {
        String uri = RestContext.request.requestURI;
        Integer idx = uri.lastIndexOf(delimiter);
        return (idx != -1 && idx < uri.length() - 1) ? uri.substring(idx + 1) : null;
    }

    private static void returnSuccess(Integer statusCode, String body) {
        RestContext.response.statusCode = statusCode;
        RestContext.response.responseBody = body != null ? Blob.valueOf(body) : null;
        RestContext.response.addHeader('Content-Type', 'application/json');
    }

    private static void returnError(Integer statusCode, String message) {
        RestContext.response.statusCode = statusCode;
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new ResponseWrapper(false, message)));
        RestContext.response.addHeader('Content-Type', 'application/json');
    }

    public class AccountWithContact {
        public Account account { get; set; }
        public Contact contact { get; set; }

        public AccountWithContact(Account account, Contact contact) {
            this.account = account;
            this.contact = contact;
        }
    }

    public class ResponseWrapper {
        public Boolean success;
        public String message;

        public ResponseWrapper(Boolean success, String message) {
            this.success = success;
            this.message = message;
        }
    }

    public class AccountWithContactDMLException extends Exception {}
}