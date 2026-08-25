public with sharing class FeatureFlags implements IFeatureFlags {
    
    private Map<String,FeatureFlag__mdt> features; 
    private Set<String> customPermissionNames; 
    private static Map<String,Boolean> mockValues = new Map<String,Boolean>();

    public FeatureFlags(){
        this(new FeatureFlagProvider());
    }

    public FeatureFlags(IFeatureFlagProvider provider){
        features = provider.getFeatureFlags();
        customPermissionNames = provider.getCustomPermissionNames();
    }

    public FeatureEvaluationResult evaluate(String featureName) {

        if (Test.isRunningTest() && mockValues.containsKey(featureName)) {
            return new FeatureEvaluationResult(mockValues.get(featureName), featureName, FeatureReason.MOCK_VALUE);
        }

        if (customPermissionNames.contains(featureName)) {

            if (FeatureManagement.checkPermission(featureName)) {
                return new FeatureEvaluationResult(true, featureName, FeatureReason.HAS_CUSTOM_PERMISSION);
            }

            return new FeatureEvaluationResult(false, featureName, FeatureReason.MISSING_CUSTOM_PERMISSION);
        }

        if (features.containsKey(featureName)){
            
            if (features.get(featureName).Is_Active__c) {
                return new FeatureEvaluationResult(true, featureName, FeatureReason.CUSTOM_METADATA_TYPE_ENABLED);
            }

            return new FeatureEvaluationResult(false, featureName, FeatureReason.CUSTOM_METADATA_TYPE_DISABLED);
        }

        return new FeatureEvaluationResult(false, featureName, FeatureReason.FLAG_NOT_FOUND);
    }

    @AuraEnabled(cacheable=true)
    public static Boolean lwcEvaluate(String featureName){
        return new FeatureFlags().evaluate(featureName).isEnabled();
    }

    @TestVisible
    private static void setMockValue(String featureName, Boolean value){
        mockValues.put(featureName, value);
    }

    public class FeatureEvaluationResult{

        private Boolean result;
        private String featureName;
        private FeatureReason reason;

        public FeatureEvaluationResult(Boolean result, String featureName, FeatureReason reason){
            this.result = result;
            this.featureName = featureName;
            this.reason = reason;
        }

        public Boolean isEnabled(){
            return result;
        }

        public String getFeatureName(){
            return featureName;
        }

        public FeatureReason getReason(){
            return reason;
        }
    }

    public enum FeatureReason {
        HAS_CUSTOM_PERMISSION,
        MISSING_CUSTOM_PERMISSION, 
        CUSTOM_METADATA_TYPE_ENABLED,
        CUSTOM_METADATA_TYPE_DISABLED,
        FLAG_NOT_FOUND,
        MOCK_VALUE
    }
}
