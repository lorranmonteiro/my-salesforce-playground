@SuppressWarnings('PMD.ApexCRUDViolation')
@RestResource(urlMapping='/v1/accounts/*')
global with sharing class AccountAPI {

    private static final Constants.HttpStatus HTTP_STATUS = Constants.HTTP_STATUS;

    @HttpGet
    global static void getAccountById() {
        try {
            String accountId = AccountAPIHelper.getParameterInURL('/');
            
            if (!AccountAPIHelper.canExecuteAction()) { return; }
            if (!AccountAPIHelper.isRequestIdValid(accountId)) { return; }
            if (!AccountAPIHelper.doesAccountExist(accountId)) { return; }

            Account account = AccountSelector.getAccountById(accountId);

            AccountAPIHelper.returnSuccess(HTTP_STATUS.OK, JSON.serialize(account));
        } catch (Exception e) {
            AccountAPIHelper.returnError(HTTP_STATUS.INTERNAL_SERVER_ERROR, 'Internal error: ' + e.getMessage());
        }

        LogCollector.flush();
    }

    @HttpPost
    global static void createAccountWithContact() {
        try {
            String requestBody = RestContext.request.requestBody.toString();

            if (!AccountAPIHelper.canExecuteAction()) { return; }
            if (!AccountAPIHelper.isRequestBodyValid(requestBody)) { return; }

            AccountWithContact accountWithContact = (AccountWithContact) JSON.deserialize(
                requestBody,
                AccountWithContact.class
            );

            if (accountWithContact == null || accountWithContact.account == null || accountWithContact.contact == null) {
                AccountAPIHelper.returnError(HTTP_STATUS.BAD_REQUEST, 'Invalid payload. Must include Account and Contact.');
                return;
            }

            insertAccountAndContact(accountWithContact);

            AccountAPIHelper.returnSuccess(HTTP_STATUS.CREATED, JSON.serialize(accountWithContact));
        } catch (AccountWithContactDMLException e) {
            AccountAPIHelper.returnError(HTTP_STATUS.BAD_REQUEST, e.getMessage());
        } catch (Exception e) {
            AccountAPIHelper.returnError(HTTP_STATUS.INTERNAL_SERVER_ERROR, 'Internal error: ' + e.getMessage());
        }

        LogCollector.flush();
    }

    @HttpPatch
    global static void updateAccount() {
        try {
            String accountId = AccountAPIHelper.getParameterInURL('/');
            String requestBody = RestContext.request.requestBody.toString();

            if (!AccountAPIHelper.canExecuteAction()) { return; }
            if (!AccountAPIHelper.isRequestIdValid(accountId)) { return; }
            if (!AccountAPIHelper.isRequestBodyValid(requestBody)) { return; }
            if (!AccountAPIHelper.doesAccountExist(accountId)) { return; }

            Account account = (Account) JSON.deserialize(
                requestBody,
                Account.class
            );

            account.Id = accountId;

            try {
                update account;
            } catch (DmlException e) {
                AccountAPIHelper.returnError(HTTP_STATUS.BAD_REQUEST, 'Failed to update Account: ' + e.getMessage());
                return;
            }

            AccountAPIHelper.returnSuccess(HTTP_STATUS.OK, JSON.serialize(account));
        } catch (Exception e) {
            AccountAPIHelper.returnError(HTTP_STATUS.INTERNAL_SERVER_ERROR, 'Internal error: ' + e.getMessage());
        }

        LogCollector.flush();
    }

    @HttpDelete
    global static void deleteAccount() {
        try {
            String accountId = AccountAPIHelper.getParameterInURL('/');

            if (!AccountAPIHelper.canExecuteAction()) { return; }
            if (!AccountAPIHelper.isRequestIdValid(accountId)) { return; }
            if (!AccountAPIHelper.doesAccountExist(accountId)) { return; }

            try {
                delete new Account(Id = accountId);
            } catch (DmlException e) {
                AccountAPIHelper.returnError(HTTP_STATUS.BAD_REQUEST, 'Failed to delete Account: ' + e.getMessage());
                return;
            }

            AccountAPIHelper.returnSuccess(HTTP_STATUS.NO_CONTENT, null);
        } catch (Exception e) {
            AccountAPIHelper.returnError(HTTP_STATUS.INTERNAL_SERVER_ERROR, 'Internal error: ' + e.getMessage());
        }

        LogCollector.flush();
    }

    private static void insertAccountAndContact(AccountWithContact accountWithContact) {
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
    }

    public class AccountWithContact {
        public Account account { get; set; }
        public Contact contact { get; set; }

        public AccountWithContact(Account account, Contact contact) {
            this.account = account;
            this.contact = contact;
        }
    }

    public class AccountWithContactDMLException extends Exception {}
}
