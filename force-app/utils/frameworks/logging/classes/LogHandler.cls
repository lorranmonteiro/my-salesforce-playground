@SuppressWarnings('PMD.ApexCRUDViolation')
public without sharing class LogHandler {

    public static void logIntegrationCallout(HttpRequest request, HttpResponse response) {
        Log__c log = new Log__c();
        log.Type__c = 'Integration Callout';
        log.Endpoint__c = request?.getEndpoint();
        log.HttpMethod__c = request?.getMethod();
        log.RequestBody__c = request?.getBody();
        log.ResponseBody__c = response?.getBody();
        log.HttpStatusCode__c = response?.getStatusCode().toString();

        insert log;
    }

    public static void logIntegrationAPI() {
        if (RestContext.request == null) { return; }

        Log__c log = new Log__c();
        log.Type__c = 'Integration API';
        log.Endpoint__c = RestContext.request?.requestURI;
        log.HttpMethod__c = RestContext.request?.httpMethod;
        log.HttpStatusCode__c = RestContext.response?.statusCode.toString();
        log.RequestBody__c = RestContext.request?.requestBody?.toString();
        log.ResponseBody__c = RestContext.response?.responseBody?.toString();

        insert log;
    }

    public static void logException(Exception e) {
        if (e == null) { return; }

        final String stackTrace = e.getStackTraceString().substringBefore('\n');
        final String className = stackTrace.substringAfter('.').substringBefore('.');
        final String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');

        Log__c log = new Log__c();
        log.Type__c = 'Exception';
        log.ClassName__c = className;
        log.MethodName__c = methodName;
        log.StackTrace__c = e.getStackTraceString();
        log.ExceptionType__c = e.getTypeName();
        log.ExceptionMessage__c = e.getMessage();
        log.ExceptionCodeLine__c = e.getLineNumber();

        insert log;
    }
}
