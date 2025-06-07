trigger OpportunityChangeTrigger on OpportunityChangeEvent (after insert) {
  //   List<Task> tasks = new List<Task>();
  // // Iterate through each event message.

  // for (OpportunityChangeEvent event : Trigger.New) {
  //   // Get some event header fields
  //   EventBus.ChangeEventHeader header = event.ChangeEventHeader;

  //   if (header.changetype == 'UPDATE' && event.isWon) {
  //       Task tk = new Task();
  //       tk.Subject = 'Follow up on won opportunities: ' + header.recordIds;
  //       tk.OwnerId = header.CommitUser;
  //       tasks.add(tk);
  //   }

  //   if (tasks.isEmpty()) return;

  //   insert tasks;
  // }
}