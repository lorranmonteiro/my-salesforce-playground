public with sharing class AccountSelector {

    public static Database.QueryLocator getAccountsByTypesQueryLocator(Set<String> accountTypes) {
        Set<String> safeAccountTypes = accountTypes == null ? new Set<String>() : accountTypes;

        return Database.getQueryLocator([
            SELECT Id
            FROM Account
            WHERE Type IN :safeAccountTypes
        ]);
    }

    public static List<Account> getAccountsByTypes(Set<String> accountTypes) {
        if (accountTypes == null || accountTypes.isEmpty()) { return new List<Account>(); }

        return [
            SELECT Id, Type
            FROM Account
            WHERE Type IN :accountTypes
            WITH USER_MODE
        ];
    }

    @SuppressWarnings('PMD.AvoidNonRestrictiveQueries')
    public static List<Account> getAllAccounts() {
        return [
            SELECT Id, Name, Type, CreatedDate, Site, AccountNumber
            FROM Account 
            WITH USER_MODE
        ];
    }

    public static List<Account> getAccountsByAccountNumber(String accountNumber) {
        if (accountNumber == null) { return new List<Account>(); }

        return [
            SELECT Id, Name, Type, CreatedDate, Site, AccountNumber
            FROM Account 
            WHERE AccountNumber = :accountNumber
            WITH USER_MODE
        ];
    }

    public static Account getAccountById(Id accountId) {
        if (String.isBlank(accountId)) { return null; }

        List<Account> accounts = [
            SELECT Id, Name, LastModifiedDate
            FROM Account 
            WHERE Id = :accountId
            WITH USER_MODE
        ];

        return accounts.isEmpty() ? null : accounts[0];
    }

    public static List<Account> getAccountsByIds(Set<Id> accountIds) {
        if (accountIds.isEmpty()) { return new List<Account>(); }

        return [
            SELECT Id, Name, LastModifiedDate
            FROM Account 
            WHERE Id IN :accountIds
            WITH USER_MODE
        ];
    }
}
