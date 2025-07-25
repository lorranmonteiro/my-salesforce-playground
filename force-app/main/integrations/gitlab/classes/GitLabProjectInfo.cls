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

        GitLabProject parsedResponse;
        try {
            GitlabService gitlabService = GitlabServiceFactory.getService();
            HttpResponse response = gitlabService.requestProjectDetails();

            if (response.getStatusCode() != 200) {
                throw new GitLabProjectInfoRequestException(response.getStatusCode() + ' - ' + response.getBody());
            }

            parsedResponse = GitLabProject.parse(response.getBody());
            Cache.Org.put(GITLAB_PROJECT_CACHE_KEY, parsedResponse);
        } catch (Exception e) {
            LogService.logException(e);
            throwAuraException(e.getMessage());
        }

        LogCollector.flush();
        return parsedResponse;
    }

    private static GitLabProject getCachedProjectDetails() {
        return (GitLabProject) Cache.Org.get(GITLAB_PROJECT_CACHE_KEY);
    }

    private static void throwAuraException(String errorMessage) {
        AuraHandledException auraException = new AuraHandledException(ERROR_MESSAGE + errorMessage);
        auraException.setMessage(ERROR_MESSAGE + errorMessage); // used for apex tests
        throw auraException;
    }

    public class GitLabProjectInfoRequestException extends Exception {}
}
