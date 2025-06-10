public with sharing class GitlabMergeRequestNote {
    public String body;
    public Boolean internal;

    public GitlabMergeRequestNote(String body, Boolean internal) {
        this.body = body;
        this.internal = internal;
    }
}