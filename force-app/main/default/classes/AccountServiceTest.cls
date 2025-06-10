@isTest
public class AccountServiceTest {

    @isTest
    static void testPostNoteOnMergeRequestWhenNameChanges() {
        Account oldAccount = new Account(Name = 'Old Name');
        insert oldAccount;
        Map<Id, Account> oldAccounts = new Map<Id, Account>{ oldAccount.Id => oldAccount};

        Account newAccount = new Account(Id = oldAccount.Id, Name = 'New Name');
        Map<Id, Account> newAccounts = new Map<Id, Account>{ newAccount.Id => newAccount };

        Test.startTest();
            AccountService.postNoteOnMergeRequestWhenNameChanges(oldAccounts, newAccounts);
        Test.stopTest();

        Integer jobsCreated = Limits.getQueueableJobs();
        Assert.areEqual(1, jobsCreated, 'One queueable job should be enqueued.');
    }
}