public with sharing class AIServiceFactory {

    @TestVisible
    private static String mockProvider;

    public static IAIService getService() {
        String provider = mockProvider ?? IntegrationSetting__mdt.getInstance('AIProvider')?.Id__c;

        switch on provider {
            when 'Openai' { return OpenAiServiceFactory.getService(); }
            when 'Gemini' { return GeminiServiceFactory.getService(); }
            when else {
                throw new AIServiceFactoryNotValidProviderException('The AI provider is not valid. Please check the Integration Setting.');
            }
        }
    }

    public class AIServiceFactoryNotValidProviderException extends Exception {}
}
