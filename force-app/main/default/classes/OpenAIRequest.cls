public with sharing class OpenAIRequest {

    @TestVisible
    private static final String OPENAI_MODEL = 'OpenAIModel';

    public String input;
    public Boolean store;
    public String model;

    public OpenAIRequest(String input) {
        this.input = input;
        this.store = false;
        this.model = IntegrationSetting__mdt.getInstance(OPENAI_MODEL).Id__c;
    }
}