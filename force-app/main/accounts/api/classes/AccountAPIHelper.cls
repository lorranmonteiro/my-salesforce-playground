public with sharing class AccountAPIHelper {

    private static final Constants.HttpStatus HTTP_STATUS = Constants.HTTP_STATUS;

    public static Boolean canExecuteAction() {
        Boolean isValid = false;
        
        switch on RestContext.request.httpMethod {
            when 'GET' {
                if (Schema.sObjectType.Account.isAccessible()) { isValid = true; }
            }
            when 'POST' {
                if (Schema.sObjectType.Account.isCreateable() && Schema.sObjectType.Contact.isCreateable()) { isValid = true; }
            }
            when 'PATCH' {
                if (Schema.sObjectType.Account.isUpdateable()) { isValid = true; }
            }
            when 'DELETE' {
                if (Schema.sObjectType.Account.isDeletable()) { isValid = true; }
            }
        }

        if (!isValid) { returnError(HTTP_STATUS.FORBIDDEN, 'User is not authorized to execute this action'); }

        return isValid;
    }

    public static Boolean isRequestIdValid(String accountId) {
        if (!String.isBlank(accountId)) {
            return true;
        }

        returnError(HTTP_STATUS.BAD_REQUEST, 'Missing Account ID in URL');
        return false;
    }

    public static Boolean isRequestBodyValid(String requestBody) {
        if (!String.isBlank(requestBody)) {
            return true;
        }

        returnError(HTTP_STATUS.BAD_REQUEST, 'Request body is empty');
        return false;
    } 

    public static Boolean doesAccountExist(String accountId) {
        Account account = AccountSelector.getAccountById(accountId);
        
        if (account == null) {
            returnError(HTTP_STATUS.NOT_FOUND, 'Account not found');
            return false;
        }

        return true;
    }

    public static String getParameterInURL(String delimiter) {
        String uri = RestContext.request.requestURI;
        Integer idx = uri.lastIndexOf(delimiter);
        return (idx != -1 && idx < uri.length() - 1) ? uri.substring(idx + 1) : null;
    }

    public static void returnSuccess(Integer statusCode, String body) {
        RestContext.response.statusCode = statusCode;
        RestContext.response.responseBody = body != null ? Blob.valueOf(body) : null;

        if (statusCode != HTTP_STATUS.NO_CONTENT) {
            RestContext.response.addHeader('Content-Type', 'application/json');
        }

        LogService.logIntegrationAPI();
    }

    public static void returnError(Integer statusCode, String message) {
        RestContext.response.statusCode = statusCode;
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new APIErrorResponse(message)));
        RestContext.response.addHeader('Content-Type', 'application/json');

        LogService.logIntegrationAPI();
    }
}
