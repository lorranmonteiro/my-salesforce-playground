public with sharing class GitLabProjectInfo {

    @TestVisible
    private static final String GITLAB_PROJECT_CACHE_KEY = 'GitLabProject';
    private static final String ERROR_MESSAGE = 'Error while calling GitLab API: ';

    @AuraEnabled(cacheable = true)
    public static GitLabProject getProjectDetails() {
        if (Cache.Org.contains(GITLAB_PROJECT_CACHE_KEY)) { 
            return getCachedProjectDetails();
        }

        HttpResponse response;
        try {
            response = GitlabService.requestProjectDetails();
        } catch (Exception e) {
            throw new AuraHandledException(ERROR_MESSAGE + e.getMessage());
        }

        if (response.getStatusCode() != 200) {
            throwAuraException(response);
        }

        GitLabProject parsedResponse = GitLabProject.parse(response.getBody());
        Cache.Org.put(GITLAB_PROJECT_CACHE_KEY, parsedResponse);

        return parsedResponse;
    }

    private static void throwAuraException(HttpResponse response) {
        AuraHandledException auraException = new AuraHandledException(ERROR_MESSAGE + response.getStatusCode() + ' ' + response.getBody());
        auraException.setMessage(ERROR_MESSAGE + response.getStatusCode() + ' ' + response.getBody()); // used for apex tests
        throw auraException;
    }

    @TestVisible
    private static GitLabProject getCachedProjectDetails() {
        return (GitLabProject) Cache.Org.get(GITLAB_PROJECT_CACHE_KEY);
    }
}