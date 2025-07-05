public without sharing class TriggerHandlerHelper {
    
    public static TriggerHandler.TriggerContext determineContext(String ctx, Boolean testMode) {
        if (!Trigger.isExecuting && !testMode) { return null; }

        String key = ctx ?? getTriggerKey();

        Map<String, TriggerHandler.TriggerContext> contextMap = new Map<String, TriggerHandler.TriggerContext>{
            'before insert'  => TriggerHandler.TriggerContext.BEFORE_INSERT,
            'before update'  => TriggerHandler.TriggerContext.BEFORE_UPDATE,
            'before delete'  => TriggerHandler.TriggerContext.BEFORE_DELETE,
            'after insert'   => TriggerHandler.TriggerContext.AFTER_INSERT,
            'after update'   => TriggerHandler.TriggerContext.AFTER_UPDATE,
            'after delete'   => TriggerHandler.TriggerContext.AFTER_DELETE,
            'after undelete' => TriggerHandler.TriggerContext.AFTER_UNDELETE
        };

        return contextMap.get(key);
    }

    @SuppressWarnings('PMD.CyclomaticComplexity')
    private static String getTriggerKey() {
        if (Trigger.isBefore && Trigger.isInsert) { return 'before insert'; }
        if (Trigger.isBefore && Trigger.isUpdate) { return 'before update'; }
        if (Trigger.isBefore && Trigger.isDelete) { return 'before delete'; }
        if (Trigger.isAfter && Trigger.isInsert) { return 'after insert'; }
        if (Trigger.isAfter && Trigger.isUpdate) { return 'after update'; }
        if (Trigger.isAfter && Trigger.isDelete) { return 'after delete'; }
        if (Trigger.isAfter && Trigger.isUndelete) { return 'after undelete'; }

        return null;
    }

    public static Boolean hasExceededLoopCount(Map<String, TriggerHandler.LoopCount> loopCountMap, String handlerName) {
        if (!loopCountMap.containsKey(handlerName)) { return false; }
        return loopCountMap.get(handlerName).increment();
    }

    public static Boolean isExecutionBypassed(Set<String> bypassedHandlers, String handlerName) {
        return bypassedHandlers.contains(handlerName);
    }
}