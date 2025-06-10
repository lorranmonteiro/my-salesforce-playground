public with sharing class AccountTypeUpdateBatchScheduler implements Schedulable {

    @TestVisible
    private static final String JOB_NAME = 'Update Account Type Batch Scheduler';

    @TestVisible
    private static final String CRON = '0 0 8 * * ?'; // Runs every day at 8 AM

    private static final Integer BATCH_SIZE = 200;

    public void execute (SchedulableContext context) {
        Database.executeBatch(new AccountTypeUpdateBatch(), BATCH_SIZE);
    }

    public static String run() {
        return System.schedule(JOB_NAME, CRON, new AccountTypeUpdateBatchScheduler());
    }
}