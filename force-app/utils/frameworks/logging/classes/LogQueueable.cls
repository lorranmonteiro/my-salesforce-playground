public without sharing class LogQueueable implements Queueable {

    private List<Log__c> logs;

    public LogQueueable(List<Log__c> logs) {
        this.logs = logs;
    }

    public void execute(QueueableContext context) {
        try {
            insert logs;
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Error inserting logs: ' + e.getMessage());
        }
    }
}
