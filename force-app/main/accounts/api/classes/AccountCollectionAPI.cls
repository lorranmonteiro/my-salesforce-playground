@SuppressWarnings('PMD.ApexCRUDViolation')
@RestResource(urlMapping='/v1/accounts')
global with sharing class AccountCollectionAPI {

    private static final Constants.HttpStatus HTTP_STATUS = Constants.getInstance().HTTP_STATUS;

    @HttpGet
    global static void getAllAccounts() {
        try {

            if (!AccountAPIHelper.canExecuteAction()) { return; }

            List<Account> accounts = AccountSelector.getAllAccounts();

            AccountAPIHelper.returnSuccess(HTTP_STATUS.OK, JSON.serialize(accounts));
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

    @TestVisible
    private class AccountWithContact {
        public Account account { get; set; }
        public Contact contact { get; set; }

        public AccountWithContact(Account account, Contact contact) {
            this.account = account;
            this.contact = contact;
        }
    }

    @TestVisible
    private class AccountWithContactDMLException extends Exception {}
}
