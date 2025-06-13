trigger AccountChangeTrigger on AccountChangeEvent (after insert) {
	new AccountChangeTriggerHandler().run();
}