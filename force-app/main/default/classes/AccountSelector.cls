public with sharing class AccountSelector {

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountsByAccountNumber(String accountNumber) {
        if (String.isBlank(accountNumber)) return new List<Account>();

        return [
            SELECT Id, Name, Type, CreatedDate, Site, AccountNumber
            FROM Account 
            WHERE AccountNumber = :accountNumber
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];
    }
}