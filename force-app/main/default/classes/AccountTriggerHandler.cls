public with sharing class AccountTriggerHandler extends TriggerHandler {

    Map<Id, Account> oldAccounts;
    Map<Id, Account> newAccounts;

    public AccountTriggerHandler() {
        this.newAccounts = (Map<Id, Account>) Trigger.newMap;
        this.oldAccounts = (Map<Id, Account>) Trigger.oldMap ?? new Map<Id, Account>();
    }

    public override void afterInsert() {
        AccountService.postNoteOnMergeRequestWhenNameChanges(oldAccounts, newAccounts);
    }

    public override void afterUpdate() {
        AccountService.postNoteOnMergeRequestWhenNameChanges(oldAccounts, newAccounts);
    }
}