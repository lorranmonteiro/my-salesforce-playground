public with sharing class EmailNotificationService {

    private static final String ACCOUNT_TYPE_UPDATE_BATCH_SUBJECT = 'Account Type Update Batch Results';

    public static void sendAccountTypeUpdateBatchResults(String jobId, Integer updatedAccountsCount, List<String> errors) {
        List<String> adminEmails = UserSelector.getActiveAdminsEmails();
        if (adminEmails.isEmpty()) { return; }

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(adminEmails);
        email.setSubject(ACCOUNT_TYPE_UPDATE_BATCH_SUBJECT);
        email.setPlainTextBody(getAccountTypeUpdateBatchEmailBody(jobId, updatedAccountsCount, errors));

        Messaging.sendEmail(new List<Messaging.SingleEmailMessage> { email });
    }

    private static String getAccountTypeUpdateBatchEmailBody(String jobId, Integer updatedAccountsCount, List<String> errors) {
        List<String> safeErrors = errors == null ? new List<String>() : errors;

        return '- JobId: ' + jobId + '\n' +
               '- Accounts updated: ' + updatedAccountsCount + '\n' +
               '- Total Errors: ' + safeErrors.size() + '\n' +
               '- Errors: ' + (safeErrors.isEmpty() ? 'None' : String.join(safeErrors, '\n'));
    }
}
