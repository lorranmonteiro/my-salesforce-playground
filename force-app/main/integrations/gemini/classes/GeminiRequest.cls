public with sharing class GeminiRequest {

    public String model;
    public String input;

    public GeminiRequest(String input) {
        this.model = IntegrationSetting__mdt.getInstance('GeminiModel').Id__c;
        this.input = input;
    }
}
