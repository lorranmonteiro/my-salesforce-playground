public with sharing class GitLabProjectInfo {

    @TestVisible
    private static final String GITLAB_PROJECT_CACHE_KEY = 'GitLabProject';

    @TestVisible
    private static final String ERROR_MESSAGE = 'Error while calling GitLab API: ';
    
    @TestVisible
    private static Boolean isCacheMockedForTesting = false;

    @AuraEnabled(cacheable = true)
    public static GitLabProject getProjectDetails() {
        if (Cache.Org.contains(GITLAB_PROJECT_CACHE_KEY) || isCacheMockedForTesting) { 
            return getCachedProjectDetails();
        }

        HttpResponse response;
        try {
            GitlabService gitlabService = ServiceFactory.getGitlabService();
            response = gitlabService.requestProjectDetails();
        } catch (Exception e) {
            throwAuraException(e.getMessage());
        }

        if (response.getStatusCode() != 200) {
            throwAuraException(response);
        }

        GitLabProject parsedResponse = GitLabProject.parse(response.getBody());
        Cache.Org.put(GITLAB_PROJECT_CACHE_KEY, parsedResponse);

        return parsedResponse;
    }

    private static GitLabProject getCachedProjectDetails() {
        return (GitLabProject) Cache.Org.get(GITLAB_PROJECT_CACHE_KEY);
    }

    private static void throwAuraException(HttpResponse response) {
        AuraHandledException auraException = new AuraHandledException(ERROR_MESSAGE + response.getStatusCode() + ' ' + response.getBody());
        auraException.setMessage(ERROR_MESSAGE + response.getStatusCode() + ' ' + response.getBody()); // used for apex tests
        throw auraException;
    }

    private static void throwAuraException(String errorMessage) {
        AuraHandledException auraException = new AuraHandledException(ERROR_MESSAGE + errorMessage);
        auraException.setMessage(ERROR_MESSAGE); // used for apex tests
        throw auraException;
    }
}