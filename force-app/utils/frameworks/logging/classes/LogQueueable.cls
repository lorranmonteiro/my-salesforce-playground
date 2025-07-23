public without sharing class LogQueueable implements Queueable {

    private List<Log__c> logs;

    public LogQueueable(List<Log__c> logs) {
        this.logs = logs;
    }

    public void execute(QueueableContext context) {
        insert logs;
    }
}
