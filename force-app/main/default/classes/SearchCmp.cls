public with sharing class SearchCmp {

    @AuraEnabled(cacheable = true)
    public static String search(String textInput){
        try {
            IAIService aiService = AIServiceFactory.getService();
            return aiService.getResponse(textInput);
        } catch (Exception e) {
            AuraHandledException auraEx = new AuraHandledException(e.getMessage());
            auraEx.setMessage(e.getMessage());

            LogService.logException(e);
            throw auraEx;
        }
    }
}
