public with sharing class AccountTypeUpdateBatch implements Database.Batchable<SObject>, Database.Stateful {

    private List<String> errors = new List<String>();
    private Integer updatedAccountsCount = 0;

    public Database.QueryLocator start(Database.BatchableContext context) {
        return AccountSelector.getAccountsByTypesQueryLocator(new Set<String> {
            Constants.ACCOUNT.TYPE.PROSPECT,
            Constants.ACCOUNT.TYPE.OTHER
        });
    }

    public void execute(Database.BatchableContext context, List<Account> scope) {
        List<Account> accountsToUpdate = new List<Account>();
        
        for (Account account : scope) {
            account.Type = Constants.ACCOUNT.TYPE.CUSTOMER_DIRECT;
            accountsToUpdate.add(account);
        }

        List<Database.SaveResult> results = Database.update(accountsToUpdate, false);

        for (Database.SaveResult result : results) {
            if (result.isSuccess()) {
                updatedAccountsCount++;
                continue;
            }

            for (Database.Error error : result.getErrors()) {
                errors.add('Error updating account with Id ' + result.getId() + ' - Fields: ' + error.getFields() + 
                                ' - Status code: ' + error.getStatusCode() + ' - Message: ' + error.getMessage());
            }
        }
    }

    public void finish(Database.BatchableContext context) {
        EmailNotificationService.sendAccountTypeUpdateBatchResults(context.getJobId(), updatedAccountsCount, errors);
    }
}
