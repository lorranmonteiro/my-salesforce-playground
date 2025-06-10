public with sharing class AccountDetails {
    
    @AuraEnabled(cacheable = true)
    public static List<Account> getAccountsByAccountNumber(String accountNumber) {
        return AccountSelector.getAccountsByAccountNumber(accountNumber);
    }
}