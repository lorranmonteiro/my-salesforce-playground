@IsTest
private class FeatureFlagsTests {

    @IsTest
    static void testFeatureEnabledWithMockCustomMetadata() {
        FeatureFlagProviderMock mockFlags = new FeatureFlagProviderMock();
        FeatureFlags flags = new FeatureFlags(mockFlags);

        Test.startTest();
            FeatureFlags.FeatureEvaluationResult result = flags.evaluate('flag1');
        Test.stopTest();

        Assert.isTrue(result.isEnabled(), 'Feature should be enabled');
        Assert.areEqual('flag1', result.getFeatureName(), 'Feature name should match');
        Assert.areEqual(FeatureFlags.FeatureReason.CUSTOM_METADATA_TYPE_ENABLED, result.getReason(), 'Reason should be CUSTOM_METADATA_TYPE_ENABLED');
    }

    @IsTest
    static void testFeatureEnabledWithCustomMetadata() {
        FeatureFlags flags = new FeatureFlags();
        FeatureFlags.FeatureEvaluationResult result;

        User testUser = UserFactory.createUser(true);
        UserFactory.assignPermissionSetToUser(testUser.Id, 'ViewSearchComponent');

        Test.startTest();
            System.runAs(testUser) {
                result = flags.evaluate('canViewSearchComponent');
            }
        Test.stopTest();

        Assert.isTrue(result.isEnabled(), 'Feature should be enabled');
        Assert.areEqual('canViewSearchComponent', result.getFeatureName(), 'Feature name should match');
        Assert.areEqual(FeatureFlags.FeatureReason.HAS_CUSTOM_PERMISSION, result.getReason(), 'Reason should be HAS_CUSTOM_PERMISSION');
    }

    @IsTest
    static void testFeatureDisabledWithCustomMetadata() {
        FeatureFlagProviderMock mockFlags = new FeatureFlagProviderMock();
        FeatureFlags flags = new FeatureFlags(mockFlags);

        Test.startTest();
            FeatureFlags.FeatureEvaluationResult result = flags.evaluate('flag2');
        Test.stopTest();

        Assert.isFalse(result.isEnabled(), 'Feature should be disabled');
        Assert.areEqual(FeatureFlags.FeatureReason.CUSTOM_METADATA_TYPE_DISABLED, result.getReason(), 'Reason should be CUSTOM_METADATA_TYPE_DISABLED');
    }

    @IsTest
    static void testFeatureDisabledWithMissingCustomPermission() {
        FeatureFlagProviderMock mockFlags = new FeatureFlagProviderMock();
        FeatureFlags flags = new FeatureFlags(mockFlags);

        Test.startTest();
            FeatureFlags.FeatureEvaluationResult result = flags.evaluate('permission1');
        Test.stopTest();
    
        Assert.isFalse(result.isEnabled(), 'Feature should be disabled due to missing custom permission');
        Assert.areEqual('permission1', result.getFeatureName(), 'Feature name should match');
        Assert.areEqual(FeatureFlags.FeatureReason.MISSING_CUSTOM_PERMISSION, result.getReason(), 'Reason should be MISSING_CUSTOM_PERMISSION');
    }

    @IsTest
    static void testFeatureNotFound() {
        FeatureFlagProviderMock mockFlags = new FeatureFlagProviderMock();
        FeatureFlags flags = new FeatureFlags(mockFlags);

        Test.startTest();
            FeatureFlags.FeatureEvaluationResult result = flags.evaluate('RandomFeature');
        Test.stopTest();
    
        Assert.isFalse(result.isEnabled(), 'Feature should be disabled as it does not exist');
        Assert.areEqual('RandomFeature', result.getFeatureName(), 'Feature name should match');
        Assert.areEqual(FeatureFlags.FeatureReason.FLAG_NOT_FOUND, result.getReason(), 'Reason should be FLAG_NOT_FOUND');
    }

    @IsTest
    static void testLwcEvaluate() {
        Test.startTest();
            Boolean result  = FeatureFlags.lwcEvaluate('RandomFeature');
        Test.stopTest();
    
        Assert.isFalse(result, 'Feature should be disabled as it does not exist');
    }

    @IsTest
    @SuppressWarnings('PMD.ApexUnitTestClassShouldHaveAsserts')
    static void testFeatureFlagProvider(){
        FeatureFlagProvider provider = new FeatureFlagProvider();
        provider.getCustomPermissionNames();
        provider.getFeatureFlags();
    }

    @IsTest 
    static void testMockValues(){
        FeatureFlags.setMockValue('mockedFeatureValue', true);

        Test.startTest();
            FeatureFlags flags = new FeatureFlags();
            FeatureFlags.FeatureEvaluationResult result = flags.evaluate('mockedFeatureValue');
        Test.stopTest();

        Assert.isTrue(result.isEnabled(), 'Mocked feature should be enabled');
        Assert.areEqual('mockedFeatureValue', result.getFeatureName(), 'Feature name should match mocked value');
        Assert.areEqual(FeatureFlags.FeatureReason.MOCK_VALUE, result.getReason(), 'Reason should be MOCK_VALUE');
    }
}
