public with sharing class AccountNamePostNoteQueueable implements Queueable, Database.AllowsCallouts {

    private Set<Id> accountIds;
    private static Set<Id> firstAccountIdsChunk = new Set<Id>();
    private static Set<Id> secondAccountIdsChunk = new Set<Id>();

    @TestVisible
    private static Integer chunkSize = 100; // Salesforce only allows up to 100 callouts per transaction

    public AccountNamePostNoteQueueable(Set<Id> accountIds) {
        this.accountIds = accountIds;
    }

    public void execute(QueueableContext context) {
        if (accountIds == null || accountIds.isEmpty()) { return; }

        // Separate the first 100 and the rest for processing later
        setAccountChunks(new List<Id>(accountIds));

        for (Account account : AccountSelector.getAccountsByIds(new Set<Id>(firstAccountIdsChunk))) {

            GitlabMergeRequestNote noteRequest = new GitlabMergeRequestNote(
                '- Account Name: ' + account.Name + '\n' +
                '- Updated at: ' + account.LastModifiedDate.format(),
                false
            );

            GitlabService gitlabService = GitlabServiceFactory.getService();
            gitlabService.postNoteIntoMergeRequest(noteRequest);
        }

        // Enqueue next chunk if there are more to process
        if (!secondAccountIdsChunk.isEmpty()) {
            if (!Test.isRunningTest()) { System.enqueueJob(new AccountNamePostNoteQueueable(secondAccountIdsChunk)); }
        }
    }

    @TestVisible
    private void setAccountChunks(List<Id> accountIds) {
        for (Integer i = 0; i < accountIds.size(); i++) {
            if (i < chunkSize) {
                firstAccountIdsChunk.add(accountIds[i]);
                continue;
            }
    
            secondAccountIdsChunk.add(accountIds[i]);
        }
    }
}
