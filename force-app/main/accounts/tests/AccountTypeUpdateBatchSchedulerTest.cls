@IsTest
private class AccountTypeUpdateBatchSchedulerTest {

    @IsTest
    static void scheduleAccountTypeUpdateBatch() {
        Test.startTest();
            String jobId = AccountTypeUpdateBatchScheduler.run();
        Test.stopTest();

        CronTrigger cronTrigger = [SELECT CronExpression, CronJobDetail.Name
                                   FROM CronTrigger
                                   WHERE Id = :jobId
                                   LIMIT 1];

        Assert.areEqual(AccountTypeUpdateBatchScheduler.JOB_NAME, cronTrigger.CronJobDetail.Name,
                        'Job name should match the scheduler name.');
        Assert.areEqual(AccountTypeUpdateBatchScheduler.CRON, cronTrigger.CronExpression,
                        'Cron expression should match the expected value.');
    }
}
