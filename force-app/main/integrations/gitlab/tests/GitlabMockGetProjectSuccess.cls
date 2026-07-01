@IsTest
public class GitlabMockGetProjectSuccess implements HttpCalloutMock {

    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setHeader('Content-Type', 'application/json');
        response.setBody(getGitLabProjectJsonSample());

        return response;
    }

    private static String getGitLabProjectJsonSample() {
        return '{\n' +
    '  "id": 70541783,\n' +
    '  "description": "",\n' +
    '  "name": "Salesforce Playground",\n' +
    '  "name_with_namespace": "Lorran Monteiro / Salesforce Playground",\n' +
    '  "path": "salesforce-playground",\n' +
    '  "path_with_namespace": "lorranmonteiro/salesforce-playground",\n' +
    '  "created_at": "2025-06-05T18:31:28.941Z",\n' +
    '  "default_branch": "master",\n' +
    '  "tag_list": [],\n' +
    '  "topics": [],\n' +
    '  "ssh_url_to_repo": "git@*.com:lorranmonteiro/salesforce-playground.git",\n' +
    '  "http_url_to_repo": "https://*.com/lorranmonteiro/salesforce-playground.git",\n' +
    '  "web_url": "https://*.com/lorranmonteiro/salesforce-playground",\n' +
    '  "readme_url": "https://*.com/lorranmonteiro/salesforce-playground/-/blob/master/README.md",\n' +
    '  "forks_count": 0,\n' +
    '  "avatar_url": "https://*.com/uploads/-/system/project/avatar/70541783/Salesforce.com_logo.svg.png",\n' +
    '  "star_count": 0,\n' +
    '  "last_activity_at": "2025-06-05T18:44:30.930Z",\n' +
    '  "namespace": {\n' +
    '    "id": 4333031,\n' +
    '    "name": "Lorran Monteiro",\n' +
    '    "path": "lorranmonteiro",\n' +
    '    "kind": "user",\n' +
    '    "full_path": "lorranmonteiro",\n' +
    '    "parent_id": null,\n' +
    '    "avatar_url": "/uploads/-/system/user/avatar/3340738/avatar.png",\n' +
    '    "web_url": "https://*.com/lorranmonteiro"\n' +
    '  },\n' +
    '  "container_registry_image_prefix": "registry.*.com/lorranmonteiro/salesforce-playground",\n' +
    '  "_links": {\n' +
    '    "self": "https://*.com/api/v4/projects/70541783",\n' +
    '    "issues": "https://*.com/api/v4/projects/70541783/issues",\n' +
    '    "merge_requests": "https://*.com/api/v4/projects/70541783/merge_requests",\n' +
    '    "repo_branches": "https://*.com/api/v4/projects/70541783/repository/branches",\n' +
    '    "labels": "https://*.com/api/v4/projects/70541783/labels",\n' +
    '    "events": "https://*.com/api/v4/projects/70541783/events",\n' +
    '    "members": "https://*.com/api/v4/projects/70541783/members",\n' +
    '    "cluster_agents": "https://*.com/api/v4/projects/70541783/cluster_agents"\n' +
    '  },\n' +
    '  "marked_for_deletion_at": null,\n' +
    '  "marked_for_deletion_on": null,\n' +
    '  "packages_enabled": true,\n' +
    '  "empty_repo": false,\n' +
    '  "archived": false,\n' +
    '  "visibility": "private",\n' +
    '  "owner": {\n' +
    '    "id": 3340738,\n' +
    '    "username": "lorranmonteiro",\n' +
    '    "public_email": "lorrandec@gmail.com",\n' +
    '    "name": "Lorran Monteiro",\n' +
    '    "state": "active",\n' +
    '    "locked": false,\n' +
    '    "avatar_url": "https://*.com/uploads/-/system/user/avatar/3340738/avatar.png",\n' +
    '    "web_url": "https://*.com/lorranmonteiro"\n' +
    '  },\n' +
    '  "resolve_outdated_diff_discussions": false,\n' +
    '  "container_expiration_policy": {\n' +
    '    "cadence": "1d",\n' +
    '    "enabled": false,\n' +
    '    "keep_n": 10,\n' +
    '    "older_than": "90d",\n' +
    '    "name_regex": ".*",\n' +
    '    "name_regex_keep": null,\n' +
    '    "next_run_at": "2025-06-06T18:31:28.980Z"\n' +
    '  },\n' +
    '  "repository_object_format": "sha1",\n' +
    '  "issues_enabled": true,\n' +
    '  "merge_requests_enabled": true,\n' +
    '  "wiki_enabled": true,\n' +
    '  "jobs_enabled": true,\n' +
    '  "snippets_enabled": true,\n' +
    '  "container_registry_enabled": true,\n' +
    '  "service_desk_enabled": true,\n' +
    '  "service_desk_address": "contact-project+lorranmonteiro-salesforce-playground-70541783-issue-@incoming.*.com",\n' +
    '  "can_create_merge_request_in": true,\n' +
    '  "issues_access_level": "enabled",\n' +
    '  "repository_access_level": "enabled",\n' +
    '  "merge_requests_access_level": "enabled",\n' +
    '  "forking_access_level": "enabled",\n' +
    '  "wiki_access_level": "enabled",\n' +
    '  "builds_access_level": "enabled",\n' +
    '  "snippets_access_level": "enabled",\n' +
    '  "pages_access_level": "private",\n' +
    '  "analytics_access_level": "enabled",\n' +
    '  "container_registry_access_level": "enabled",\n' +
    '  "security_and_compliance_access_level": "private",\n' +
    '  "releases_access_level": "enabled",\n' +
    '  "environments_access_level": "enabled",\n' +
    '  "feature_flags_access_level": "enabled",\n' +
    '  "infrastructure_access_level": "enabled",\n' +
    '  "monitor_access_level": "enabled",\n' +
    '  "model_experiments_access_level": "enabled",\n' +
    '  "model_registry_access_level": "enabled",\n' +
    '  "emails_disabled": false,\n' +
    '  "emails_enabled": true,\n' +
    '  "shared_runners_enabled": true,\n' +
    '  "lfs_enabled": true,\n' +
    '  "creator_id": 3340738,\n' +
    '  "import_url": null,\n' +
    '  "import_type": null,\n' +
    '  "import_status": "none",\n' +
    '  "import_error": null,\n' +
    '  "open_issues_count": 0,\n' +
    '  "description_html": "",\n' +
    '  "updated_at": "2025-06-05T18:44:31.001Z",\n' +
    '  "ci_default_git_depth": 20,\n' +
    '  "ci_delete_pipelines_in_seconds": null,\n' +
    '  "ci_forward_deployment_enabled": true,\n' +
    '  "ci_forward_deployment_rollback_allowed": true,\n' +
    '  "ci_job_token_scope_enabled": false,\n' +
    '  "ci_separated_caches": true,\n' +
    '  "ci_allow_fork_pipelines_to_run_in_parent_project": true \n' +
    '}';
    }
}
