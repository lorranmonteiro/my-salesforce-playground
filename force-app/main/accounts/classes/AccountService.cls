public with sharing class AccountService {

    public static void postNoteOnMergeRequestWhenNameChanges(Map<Id, Account> oldAccounts,
                                                             Map<Id, Account> newAccounts) {
        Set<Id> accountIdsToPostNote = new Set<Id>();

        for (Account newAccount : newAccounts.values()) {
            Account oldAccount = oldAccounts.get(newAccount.Id);

            if (oldAccount == null || // new Account record
                oldAccount.Name != newAccount.Name) {

                accountIdsToPostNote.add(newAccount.Id);
            }
        }

        if (!accountIdsToPostNote.isEmpty()) {
            System.enqueueJob(new AccountNamePostNoteQueueable(accountIdsToPostNote));
        }
    }

    public static void postNoteOnMergeRequestWhenAccountNumberChanges(List<AccountChangeEvent> accountEvents) {
        Set<Id> accountIdsToPostNote = new Set<Id>();

        for (AccountChangeEvent accountEvent : accountEvents) {
            EventBus.ChangeEventHeader header = accountEvent.ChangeEventHeader;

            if (header.changetype == 'UPDATE' &&
                header.changedFields.contains('AccountNumber') &&
                accountEvent.AccountNumber != null) {

                accountIdsToPostNote.add(accountEvent.Id);
            }
        }

        if (!accountIdsToPostNote.isEmpty()) {
            System.enqueueJob(new AccountNamePostNoteQueueable(accountIdsToPostNote));
        }
    }
}