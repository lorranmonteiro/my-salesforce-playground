public with sharing class Constants {
    public static final AccountConstants ACCOUNT = new AccountConstants();
    public static final ProfileConstants PROFILE = new ProfileConstants();

    public class AccountConstants {
        public AccountType TYPE = new AccountType();

        public String RECORDTYPE_CUSTOMER() {
            return Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(); 
        }

        public String RECORDTYPE_PARTNER() {
            return Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Partner').getRecordTypeId(); 
        }
    }

    public class ProfileConstants {
        public final String SYSTEM_ADMINISTRATOR = 'System Administrator';
    }

    public class AccountType {
        public final String
            PROSPECT = 'Prospect',
            CUSTOMER_DIRECT = 'Customer - Direct',
            CUSTOMER_CHANNEL = 'Customer - Channel',
            CHANNEL_PARTNER_RESELLER = 'Channel Partner / Reseller',
            INSTALLATION_PARTNER = 'Installation Partner',
            TECHNOLOGY_PARTNER = 'Technology Partner',
            OTHER = 'Other';
	}
}