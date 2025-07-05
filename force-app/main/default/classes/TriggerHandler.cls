public without sharing virtual class TriggerHandler {

    private static Map<String, LoopCount> loopCountMap;
    private static Set<String> bypassedHandlers;

    @TestVisible
    private TriggerContext context;

    @TestVisible
    private Boolean isTriggerExecuting;

    static {
        loopCountMap = new Map<String, LoopCount>();
        bypassedHandlers = new Set<String>();
    }
    
    public TriggerHandler() {
        this.setTriggerContext();
    }

    public void run() {
        if (!validateRun()) { return; }

        addToLoopCount();

        switch on this.context {
            when BEFORE_INSERT { this.beforeInsert(); }
            when BEFORE_UPDATE { this.beforeUpdate(); }
            when BEFORE_DELETE { this.beforeDelete(); }
            when AFTER_INSERT { this.afterInsert(); }
            when AFTER_UPDATE { this.afterUpdate(); }
            when AFTER_DELETE { this.afterDelete(); }
            when AFTER_UNDELETE { this.afterUndelete(); }
        }
    }

    public void setMaxLoopCount(Integer max) {
        String handlerName = getHandlerName();

        if (!TriggerHandler.loopCountMap.containsKey(handlerName)) {
            TriggerHandler.loopCountMap.put(handlerName, new LoopCount(max));
            return;
        }

        TriggerHandler.loopCountMap.get(handlerName).setMax(max);
    }

    public void clearMaxLoopCount() {
        this.setMaxLoopCount(-1);
    }

    public static void bypass(String handlerName) {
        TriggerHandler.bypassedHandlers.add(handlerName);
    }

    public static void clearBypass(String handlerName) {
        TriggerHandler.bypassedHandlers.remove(handlerName);
    }

    public static Boolean isBypassed(String handlerName) {
        return TriggerHandler.bypassedHandlers.contains(handlerName);
    }

    public static void clearAllBypasses() {
        TriggerHandler.bypassedHandlers.clear();
    }

    @TestVisible
    private void setTriggerContext() {
        this.setTriggerContext(null, false);
    }

    @TestVisible
    private void setTriggerContext(String ctx, Boolean testMode) {
        this.isTriggerExecuting = Trigger.isExecuting || testMode;
        this.context = TriggerHandlerHelper.determineContext(ctx, testMode);
    }

    @TestVisible
    private void addToLoopCount() {
        String handlerName = getHandlerName();

        if (TriggerHandlerHelper.hasExceededLoopCount(loopCountMap, handlerName)) {
            Integer max = loopCountMap.get(handlerName).getMax();
            throw new TriggerHandlerException('Maximum loop count of ' + String.valueOf(max) + ' reached in ' + handlerName);
        }
    }

    @TestVisible
    private Boolean validateRun() {
        if (!this.isTriggerExecuting || this.context == null) {
            throw new TriggerHandlerException('Trigger handler called outside of Trigger execution');
        }

        return !TriggerHandlerHelper.isExecutionBypassed(bypassedHandlers, getHandlerName());
    }

    @TestVisible
    private String getHandlerName() {
        return this.toString().substringBefore(':');
    }

    @SuppressWarnings('PMD.EmptyStatementBlock')
    @TestVisible protected virtual void beforeInsert(){}

    @SuppressWarnings('PMD.EmptyStatementBlock')
    @TestVisible protected virtual void beforeUpdate(){}

    @SuppressWarnings('PMD.EmptyStatementBlock')
    @TestVisible protected virtual void beforeDelete(){}

    @SuppressWarnings('PMD.EmptyStatementBlock')
    @TestVisible protected virtual void afterInsert(){}

    @SuppressWarnings('PMD.EmptyStatementBlock')
    @TestVisible protected virtual void afterUpdate(){}

    @SuppressWarnings('PMD.EmptyStatementBlock')
    @TestVisible protected virtual void afterDelete(){}
    
    @SuppressWarnings('PMD.EmptyStatementBlock')
    @TestVisible protected virtual void afterUndelete(){}

    @TestVisible
    public class LoopCount {
        private Integer max;
        private Integer count;

        public LoopCount() {
            this.max = 5;
            this.count = 0;
        }

        public LoopCount(Integer max) {
            this.max = max;
            this.count = 0;
        }

        public Boolean increment() {
            this.count++;
            return this.exceeded();
        }

        public Boolean exceeded() {
            return this.max >= 0 && this.count > this.max;
        }

        public Integer getMax() { return this.max; }
        public Integer getCount() { return this.count; }
        public void setMax(Integer max) { this.max = max; }
    }

    @TestVisible
    public enum TriggerContext {
        BEFORE_INSERT, BEFORE_UPDATE, BEFORE_DELETE,
        AFTER_INSERT, AFTER_UPDATE, AFTER_DELETE,
        AFTER_UNDELETE
    }

    public class TriggerHandlerException extends Exception {}
}