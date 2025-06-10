public with sharing class AccountTypeUpdateBatch implements Database.Batchable<SObject>, Database.Stateful {

    private static final String EMAIL_SUBJECT = 'Account Type Update Batch Results';
    private static List<String> errors = new List<String>();
    private static Integer updatedAccountsCount = 0;

    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([SELECT Id
                                         FROM Account
                                         WHERE Type IN (:Constants.ACCOUNT.TYPE.PROSPECT, :Constants.ACCOUNT.TYPE.OTHER)]);
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
        List<String> emails = new List<String>();

        for (User user : [SELECT Email
                          FROM User
                          WHERE
                            Profile.Name = :Constants.PROFILE.SYSTEM_ADMINISTRATOR AND
                            IsActive = true]) {

            emails.add(user.Email);
        }

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(emails);
        email.setSubject(EMAIL_SUBJECT);
        email.setPlainTextBody(getEmailBody(context.getJobId()));

        Messaging.sendEmail(new List<Messaging.SingleEmailMessage> { email });
    }

    private static String getEmailBody(String jobId) {
        return '- JobId: ' + jobId + '\n' +
               '- Accounts updated: ' + updatedAccountsCount + '\n' +
               '- Total Errors: ' + errors.size() + '\n' +
               '- Errors: ' + (errors.isEmpty() ? 'None' : String.join(errors, '\n'));
    }
}