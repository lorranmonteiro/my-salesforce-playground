@IsTest
public class ConstantsTest {

    @IsTest
    static void testAccountRecordTypeCustomer() {
        Test.startTest();
            Constants.AccountConstants accountConstants = Constants.getInstance().ACCOUNT;
            Constants.AccountType accountTypes = Constants.getInstance().ACCOUNT.TYPE;
            Constants.ProfileConstants profiles = Constants.getInstance().PROFILE;
            Constants.HttpStatus httpStatus = Constants.getInstance().HTTP_STATUS;
        Test.stopTest();

        String expectedCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
        String expectedPartnerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Partner').getRecordTypeId();

        Assert.areEqual(expectedCustomerRecordTypeId, accountConstants.RECORDTYPE_CUSTOMER(), 'Record Type ID for Customer should match expected value');
        Assert.areEqual(expectedPartnerRecordTypeId, accountConstants.RECORDTYPE_PARTNER(), 'Record Type ID for Partner should match expected value');
        Assert.areEqual('System Administrator', profiles.SYSTEM_ADMINISTRATOR, 'Profile name for System Administrator should match expected value');
        Assert.areEqual('Prospect', accountTypes.PROSPECT, 'Account Prospect Status should be Prospect');
        Assert.areEqual(400, httpStatus.BAD_REQUEST, 'HTTP Status for Bad Request should be 400');
    }
}
