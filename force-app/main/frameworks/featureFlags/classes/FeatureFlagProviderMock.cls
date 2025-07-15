public without sharing class FeatureFlagProviderMock implements IFeatureFlagProvider {
    
    public Set<String> getCustomPermissionNames(){
        return new Set<String>{
            'permission1'
        };
    }

    public Map<String,FeatureFlag__mdt> getFeatureFlags(){
        return new Map<String,FeatureFlag__mdt>{
            'flag1' => new FeatureFlag__mdt(
                DeveloperName = 'flag1',
                Is_Active__c = true
            ),
            'flag2' => new FeatureFlag__mdt(
                DeveloperName = 'flag2',
                Is_Active__c = false
            )
        };
    }
}
