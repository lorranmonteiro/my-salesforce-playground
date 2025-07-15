public without sharing class FeatureFlagProvider implements IFeatureFlagProvider {
    
    @SuppressWarnings('PMD.ApexCRUDViolation')
    public Set<String> getCustomPermissionNames(){
        Set<String> customPermissionNames = new Set<String>();

        for (CustomPermission permission : [SELECT Id, DeveloperName FROM CustomPermission]){
            customPermissionNames.add(permission.DeveloperName);
        }
        return customPermissionNames;
    }

    public Map<String,FeatureFlag__mdt> getFeatureFlags(){
        return FeatureFlag__mdt.getAll();
    }
}
