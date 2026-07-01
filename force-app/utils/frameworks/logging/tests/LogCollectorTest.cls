@IsTest
private class LogCollectorTest {

    @IsTest
    static void testCollect() {
        Log__c log = new Log__c();
        log.Type__c = 'Exception';

        Test.startTest();
            LogCollector.collect(log);
        Test.stopTest();

        Assert.areEqual(1, LogCollector.collectedLogs.size(), 'Log should be collected');
    }

    @IsTest
    static void testFlush() {
        Log__c log = new Log__c();
        log.Type__c = 'Exception';
        LogCollector.collect(log);

        Test.startTest();
            LogCollector.flush();
        Test.stopTest();

        Log__c createdLog = [SELECT Type__c FROM Log__c LIMIT 1];

        Assert.areEqual(0, LogCollector.collectedLogs.size(), 'Logs should be flushed');
        Assert.areEqual(log.Type__c, createdLog.Type__c, 'Log type should be preserved');
    }
}
