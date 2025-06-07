public with sharing class GitlabService {

    public static HttpResponse requestProjectDetails() {
        IntegrationEndpoint__mdt projectDetailEndpoint = IntegrationEndpoint__mdt.getInstance('GitlabProjectDetails');
        String projectId = IntegrationSetting__mdt.getInstance('GitlabProjectId').Id__c;

        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:GitlabAPI' + projectDetailEndpoint.Endpoint__c.replace('{id}', projectId));
        request.setMethod(projectDetailEndpoint.Method__c);
        request.setHeader('Accept', projectDetailEndpoint.Accept__c);

        return new Http().send(request);
    }
}