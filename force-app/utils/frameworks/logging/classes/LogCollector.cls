public without sharing class LogCollector {

    @TestVisible
    private static Set<Log__c> collectedLogs = new Set<Log__c>();

    public static void collect(Log__c log) {
        if (log == null) { return; }

        collectedLogs.add(log);
    }

    public static void flush() {
        if (collectedLogs.isEmpty()) { return; }

        System.enqueueJob(new LogQueueable(new List<Log__c>(collectedLogs)));
        collectedLogs.clear();
    }
}
