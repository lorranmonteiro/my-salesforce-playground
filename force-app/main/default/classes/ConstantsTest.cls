@isTest
public class ConstantsTest {

    @IsTest
    static void testAccountRecordTypeCustomer() {
        Test.startTest();
            String customerRecordTypeId = Constants.ACCOUNT.RECORDTYPE_CUSTOMER();
            String partnerRecordTypeId = Constants.ACCOUNT.RECORDTYPE_PARTNER();
            String accountProspectStatus = Constants.ACCOUNT.TYPE.PROSPECT;
        Test.stopTest();

        String expectedCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
        String expectedPartnerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Partner').getRecordTypeId();

        Assert.areEqual(expectedCustomerRecordTypeId, customerRecordTypeId, 'Record Type ID for Customer should match expected value');
        Assert.areEqual(expectedPartnerRecordTypeId, partnerRecordTypeId, 'Record Type ID for Partner should match expected value');
        Assert.areEqual('Prospect', accountProspectStatus, 'Account Prospect Status should be Prospect');
    }
}