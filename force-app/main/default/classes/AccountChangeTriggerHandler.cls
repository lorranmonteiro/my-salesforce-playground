public with sharing class AccountChangeTriggerHandler extends TriggerHandler {

    private List<AccountChangeEvent> accountEvents;

    public AccountChangeTriggerHandler() {
        this.accountEvents = Trigger.new;
    }

    public override void afterInsert() {
        AccountService.postNoteOnMergeRequestWhenAccountNumberChanges(accountEvents);
    }
}