@isTest
private class LogQueueableTest {

    @isTest
    static void shouldEnqueueLogQueueableJob() {
        Log__c log = new Log__c();
        log.Type__c = 'Exception';

        Test.startTest();
            Id jobID = System.enqueueJob(new LogQueueable(new List<Log__c>{ log }));
        Test.stopTest();

        Log__c createdLog = [SELECT Type__c FROM Log__c LIMIT 1];

        Assert.isNotNull(jobID, 'Job ID should not be null after enqueueing the job.');
        Assert.areEqual(log.Type__c, createdLog.Type__c, 'Log type should be Exception');
    }
}
