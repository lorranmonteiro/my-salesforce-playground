@SuppressWarnings('PMD.FieldNamingConventions')
public with sharing class Constants {
    public static final AccountConstants ACCOUNT = new AccountConstants();
    public static final ProfileConstants PROFILE = new ProfileConstants();
    public static final HttpStatus HTTP_STATUS = new HttpStatus();

    @SuppressWarnings('PMD.MethodNamingConventions')
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

    public class HttpStatus {
        public final Integer OK = 200;
        public final Integer CREATED = 201;
        public final Integer NO_CONTENT = 204;
        public final Integer BAD_REQUEST = 400;
        public final Integer FORBIDDEN = 403;
        public final Integer NOT_FOUND = 404;
        public final Integer INTERNAL_SERVER_ERROR = 500;
    }
}
