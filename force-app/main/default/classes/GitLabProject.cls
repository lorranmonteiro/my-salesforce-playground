@SuppressWarnings('PMD.PropertyNamingConventions')
public with sharing class GitLabProject {
    @AuraEnabled public String id { get; set; }
    @AuraEnabled public String description { get; set; }
    @AuraEnabled public String name { get; set; }
    @AuraEnabled public String default_branch { get; set; }
    @AuraEnabled public String web_url { get; set; }
    @AuraEnabled public Datetime created_at { get; set; }
    @AuraEnabled public Owner owner { get; set; }

    public class Owner {
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public String public_email { get; set; }
    }
    
    public static GitLabProject parse(String json) {
        return (GitLabProject) System.JSON.deserialize(json, GitLabProject.class);
    }
}