@SuppressWarnings('PMD.ApexCRUDViolation')
@RestResource(urlMapping='/v1/accounts/*')
global with sharing class AccountAPI {

    private static final Constants.HttpStatus HTTP_STATUS = Constants.getInstance().HTTP_STATUS;

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
    }
}
