@isTest
private class LogServiceTest {

    @IsTest
    static void testLogIntegrationCallout() {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.example.com/data');
        request.setMethod('GET');
        request.setBody('{"key": "value"}');

        HttpResponse response = new HttpResponse();
        response.setBody('{"status": "success"}');
        response.setStatusCode(200);

        Test.startTest();
            LogService.logIntegrationCallout(request, response);
            LogCollector.flush();
        Test.stopTest();

        Log__c log = [SELECT Id, Type__c, Endpoint__c, HttpMethod__c, RequestBody__c, ResponseBody__c, HttpStatusCode__c FROM Log__c LIMIT 1];

        Assert.areEqual('Integration Callout', log.Type__c, 'Log type should be Integration Callout');
        Assert.areEqual(request.getEndpoint(), log.Endpoint__c, 'Endpoint should match the request endpoint');
        Assert.areEqual(request.getMethod(), log.HttpMethod__c, 'HTTP method should match the request method');
        Assert.areEqual(request.getBody(), log.RequestBody__c, 'Request body should match the request body');
        Assert.areEqual(response.getBody(), log.ResponseBody__c, 'Response body should match the response body');
        Assert.areEqual(String.valueOf(response.getStatusCode()), log.HttpStatusCode__c, 'HTTP status code should match the response status code');
    }

    @IsTest
    static void testLogIntegrationAPI() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/myendpoint/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf('{"name": "test"}');
        RestContext.request = request;

        RestResponse response = new RestResponse();
        response.statusCode = 200;
        response.responseBody = Blob.valueOf('{"success": true}');
        RestContext.response = response;

        Test.startTest();
            LogService.logIntegrationAPI();
            LogCollector.flush();
        Test.stopTest();

        Log__c log = [SELECT Id, Type__c, Endpoint__c, HttpMethod__c, RequestBody__c, ResponseBody__c, HttpStatusCode__c FROM Log__c LIMIT 1];

        Assert.areEqual('Integration API', log.Type__c, 'Log type should be Integration API');
        Assert.areEqual(request.requestURI, log.Endpoint__c, 'Endpoint should match the request URI');
        Assert.areEqual(request.httpMethod, log.HttpMethod__c, 'HTTP method should match the request method');
        Assert.areEqual(request.requestBody.toString(), log.RequestBody__c, 'Request body should match the request body');
        Assert.areEqual(response.responseBody.toString(), log.ResponseBody__c, 'Response body should match the response body');
        Assert.areEqual(String.valueOf(response.statusCode), log.HttpStatusCode__c, 'HTTP status code should match the response status code');
    }

    @IsTest
    static void testLogException() {
        Test.startTest();
            try {
                String s = null;
                s.toUpperCase();
            } catch (Exception e) {
                LogService.logException(e);
                LogCollector.flush();
            }
        Test.stopTest();

        Log__c log = [SELECT Id, Type__c, ClassName__c, MethodName__c, ExceptionType__c, ExceptionMessage__c, ExceptionCodeLine__c FROM Log__c LIMIT 1];

        Assert.areEqual('Exception', log.Type__c, 'Log type should be Exception');
        Assert.areEqual('LogServiceTest', log.ClassName__c, 'Class name should be LogServiceTest');
        Assert.areEqual('testLogException', log.MethodName__c, 'Method name should be testLogException');
        Assert.areEqual('System.NullPointerException', log.ExceptionType__c, 'Exception type should be System.NullPointerException');
        Assert.areEqual('Attempt to de-reference a null object', log.ExceptionMessage__c, 'Exception message should be Attempt to de-reference a null object');
    }
}
