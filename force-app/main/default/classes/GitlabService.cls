public virtual with sharing class GitlabService {

    private static final String GITLAB_API = 'GitlabAPI';
    private static final String GITLAB_PROJECT_ID = 'GitlabProjectId';
    private static final String GITLAB_MERGE_REQUEST_ID = 'GitlabMergeRequestId';
    private static final String GITLAB_PROJECT_DETAILS = 'GitlabProjectDetails';
    private static final String GITLAB_CREATE_NOTE_ON_MERGE_REQUEST = 'GitlabCreateNoteOnMergeRequest';

    public virtual HttpResponse requestProjectDetails() {
        IntegrationEndpoint__mdt projectDetailEndpoint = IntegrationEndpoint__mdt.getInstance(GITLAB_PROJECT_DETAILS);
        String projectId = IntegrationSetting__mdt.getInstance(GITLAB_PROJECT_ID).Id__c;

        HttpRequest request = new HttpRequest();
        request.setMethod(projectDetailEndpoint.Method__c);
        request.setHeader('Accept', projectDetailEndpoint.Accept__c);
        request.setEndpoint('callout:' + GITLAB_API + projectDetailEndpoint.Endpoint__c.replace('{id}', projectId));

        return new Http().send(request);
    }

    public virtual HttpResponse postNoteIntoMergeRequest(GitlabMergeRequestNote noteRequest) {
        if (String.isBlank(noteRequest?.body)) {
            throw new GitlabServiceMissingParametersException('Note request body cannot be null or empty.');
        }

        IntegrationEndpoint__mdt postNoteOnMergeRequestEndpoint = IntegrationEndpoint__mdt.getInstance(GITLAB_CREATE_NOTE_ON_MERGE_REQUEST);
        String projectId = IntegrationSetting__mdt.getInstance(GITLAB_PROJECT_ID).Id__c;
        String mergeRequestId = IntegrationSetting__mdt.getInstance(GITLAB_MERGE_REQUEST_ID).Id__c;

        String endpoint = 'callout:' + GITLAB_API + postNoteOnMergeRequestEndpoint.Endpoint__c.replace('{id}', projectId)
                                                                                              .replace('{merge_request_iid}', mergeRequestId);
        endpoint += '?body=' + EncodingUtil.urlEncode(noteRequest.body, 'UTF-8');
        endpoint += '&internal=' + String.valueOf(noteRequest.internal);                           

        HttpRequest request = new HttpRequest();
        request.setMethod(postNoteOnMergeRequestEndpoint.Method__c);
        request.setHeader('Accept', postNoteOnMergeRequestEndpoint.Accept__c);
        request.setEndpoint(endpoint);

        return new Http().send(request);
    }

    public class GitlabServiceMissingParametersException extends Exception {}
}