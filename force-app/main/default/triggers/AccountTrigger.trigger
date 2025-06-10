trigger AccountTrigger on Account (after insert, after update) {
    new AccountTriggerHandler().run();
}