public with sharing class GitLabProjectInfo {

    private static final String ERROR_MESSAGE = 'Error while calling GitLab API: ';

    @AuraEnabled(cacheable = true)
    public static GitLabProject getProjectDetails() {

        HttpResponse response;
        try {
            response = GitlabService.requestProjectDetails();
        } catch (Exception e) {
            throw new AuraHandledException(ERROR_MESSAGE + e.getMessage());
        }

        if (response.getStatusCode() != 200) {
            throwAuraException(response);
        }

        return GitLabProject.parse(response.getBody());
    }

    private static void throwAuraException(HttpResponse response) {
        AuraHandledException auraException = new AuraHandledException(ERROR_MESSAGE + response.getStatusCode() + ' ' + response.getBody());
        auraException.setMessage(ERROR_MESSAGE + response.getStatusCode() + ' ' + response.getBody()); // used for apex tests
        throw auraException;
    }
}