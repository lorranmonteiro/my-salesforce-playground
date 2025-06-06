public with sharing class GitLabProject {
    public String id;
    public String description;
    public String name;
    public Datetime created_at;
    public String default_branch;
    public String web_url;
    public Owner owner;
    
    public class Owner {
        public String name;
        public String public_email;
    }
    
    public static GitLabProject parse(String json) {
        return (GitLabProject) System.JSON.deserialize(json, GitLabProject.class);
    }
}