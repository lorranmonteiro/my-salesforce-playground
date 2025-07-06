@isTest
public class AccountServiceTest {

    @isTest
    static void postNoteOnMergeRequestWhenNameChanges() {
        TestAccountFactory.bypassTriggers = false;
        Account oldAccount = TestAccountFactory.createAccount(true);
        Map<Id, Account> oldAccounts = new Map<Id, Account>{ oldAccount.Id => oldAccount};

        Account newAccount = new Account(Id = oldAccount.Id, Name = 'New Name');
        Map<Id, Account> newAccounts = new Map<Id, Account>{ newAccount.Id => newAccount };

        Test.startTest();
            AccountService.postNoteOnMergeRequestWhenNameChanges(oldAccounts, newAccounts);
        Test.stopTest();

        Assert.areEqual(1, Limits.getQueueableJobs(), 'One queueable job should be enqueued.');
    }

    @isTest
    static void postNoteOnMergeRequestWhenAccountNumberChanges() {
        TestAccountFactory.bypassTriggers = false;
        Account account = TestAccountFactory.createAccount(true);

        Test.getEventBus().deliver();

        Test.startTest();
            account.AccountNumber = '67890';
            update account;
        Test.stopTest();

        Test.getEventBus().deliver();

        Assert.areEqual(1, Limits.getQueueableJobs(), 'One queueable job should be enqueued.');
    }
}