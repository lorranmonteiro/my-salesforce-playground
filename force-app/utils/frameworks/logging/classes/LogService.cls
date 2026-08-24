public without sharing class LogService {

    private static final String LOG_TYPE_INTEGRATION_API = 'Integration API';
    private static final String LOG_TYPE_INTEGRATION_CALLOUT= 'Integration Callout';
    private static final String LOG_TYPE_EXCEPTION= 'Exception';

    public static void logIntegrationCallout(HttpRequest request, HttpResponse response) {
        LogEvent__e log = new LogEvent__e();
        log.Type__c = LOG_TYPE_INTEGRATION_CALLOUT;
        log.Endpoint__c = request?.getEndpoint();
        log.HttpMethod__c = request?.getMethod();
        log.HttpStatusCode__c = response?.getStatusCode();
        log.RequestBody__c = StringUtils.truncate(request?.getBody(), 10000);
        log.ResponseBody__c = StringUtils.truncate(response?.getBody(), 10000);

        EventBus.publish(log);
    }

    public static void logIntegrationAPI() {
        if (RestContext.request == null) { return; }

        LogEvent__e log = new LogEvent__e();
        log.Type__c = LOG_TYPE_INTEGRATION_API;
        log.Endpoint__c = RestContext.request?.requestURI;
        log.HttpMethod__c = RestContext.request?.httpMethod;
        log.HttpStatusCode__c = RestContext.response?.statusCode;
        log.RequestBody__c = StringUtils.truncate(RestContext.request?.requestBody?.toString(), 10000);
        log.ResponseBody__c = StringUtils.truncate(RestContext.response?.responseBody?.toString(), 10000);

        EventBus.publish(log);
    }

    public static void logException(Exception e) {
        if (e == null) { return; }

        final String stackTrace = e.getStackTraceString().substringBefore('\n');
        final String className = stackTrace.substringAfter('.').substringBefore('.');
        final String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');

        LogEvent__e log = new LogEvent__e();
        log.Type__c = LOG_TYPE_EXCEPTION;
        log.ApexClassName__c = className;
        log.ApexMethodName__c = methodName;
        log.StackTrace__c = e.getStackTraceString();
        log.ExceptionType__c = e.getTypeName();
        log.ExceptionMessage__c = e.getMessage();

        EventBus.publish(log);
    }
}
