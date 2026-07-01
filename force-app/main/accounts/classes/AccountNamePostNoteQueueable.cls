public with sharing class AccountNamePostNoteQueueable implements Queueable, Finalizer, Database.AllowsCallouts {

    private Set<Id> accountIds;
    private Set<Id> firstAccountIdsChunk = new Set<Id>();
    private Set<Id> secondAccountIdsChunk = new Set<Id>();

    @TestVisible
    private static Integer chunkSize = 100; // Salesforce only allows up to 100 callouts per transaction

    public AccountNamePostNoteQueueable(Set<Id> accountIds) {
        this.accountIds = accountIds;
    }

    public void execute(QueueableContext queueableContext) {
        if (accountIds == null || accountIds.isEmpty()) { return; }

        System.attachFinalizer(this);

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
    }

    public void execute(FinalizerContext finalizerContext) {
        // Continue processing only when the parent queueable was successful.
        if (
            String.valueOf(finalizerContext.getResult()) == 'SUCCESS' &&
            !secondAccountIdsChunk.isEmpty() &&
            !Test.isRunningTest()) {

            System.enqueueJob(new AccountNamePostNoteQueueable(new Set<Id>(secondAccountIdsChunk)));
        }
    }

    @TestVisible
    private void setAccountChunks(List<Id> accountIds) {
        firstAccountIdsChunk.clear();
        secondAccountIdsChunk.clear();

        for (Integer i = 0; i < accountIds.size(); i++) {
            if (i < chunkSize) {
                firstAccountIdsChunk.add(accountIds[i]);
                continue;
            }
    
            secondAccountIdsChunk.add(accountIds[i]);
        }
    }
}
