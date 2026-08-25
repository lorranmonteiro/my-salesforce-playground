@IsTest
private class AccountNamePostNoteQueueableTest {

    @IsTest
    static void shouldEnqueueAccountNamePostNoteJob() {
        Test.setMock(HttpCalloutMock.class, new GitlabMockPostNoteOnMergeRequestSuccess());

        TestAccountFactory.bypassTriggers = false;
        Account account = TestAccountFactory.createAccount(true);

        Test.startTest();
            Id jobID = System.enqueueJob(new AccountNamePostNoteQueueable(new Set<Id>{ account.Id }));
        Test.stopTest();

        Assert.isNotNull(jobID, 'Job ID should not be null after enqueueing the job.');
        Assert.areEqual(1, Limits.getQueueableJobs(), 'There should be one job in the AsyncApexJob table.');
        Assert.areEqual('Completed', [SELECT Status FROM AsyncApexJob WHERE Id = :jobID].Status, 'The job status should be Holding after enqueueing.');
    }

    @IsTest
    static void shouldEnqueueTwoAccountNamePostNoteJobs() {
        Test.setMock(HttpCalloutMock.class, new GitlabMockPostNoteOnMergeRequestSuccess());

        Account account1 = TestAccountFactory.createAccount();
        Account account2 = TestAccountFactory.createAccount();
        insert new List<Account>{ account1, account2 };

        // Decrease the chunk size to 1 for testing purposes
        AccountNamePostNoteQueueable.chunkSize = 1;

        Test.startTest();
            Id jobID = System.enqueueJob(new AccountNamePostNoteQueueable(new Set<Id>{ account1.Id, account2.Id }));
        Test.stopTest();

        // Can't assert two jobs, because Apex Tests only allow one job to be enqueued at a time
        Assert.isNotNull(jobID, 'Job ID should not be null after enqueueing the job.');
        Assert.areEqual(1, Limits.getQueueableJobs(), 'There should be one job in the AsyncApexJob table.');
    }

    @IsTest
    static void shouldFallIntoExceptionWhenCalloutFails() {
        Account account = TestAccountFactory.createAccount(true);

        Test.startTest();
            Id jobID = System.enqueueJob(new AccountNamePostNoteQueueable(new Set<Id>{ account.Id }));
        Test.stopTest();

        Assert.isNotNull(jobID, 'Job ID should not be null after enqueueing the job.');
    }
}
