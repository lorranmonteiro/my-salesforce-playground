public with sharing class AccountSelector {

    public static List<Account> getAccountsByAccountNumber(String accountNumber) {
        if (String.isBlank(accountNumber)) { return new List<Account>(); }

        return [
            SELECT Id, Name, Type, CreatedDate, Site, AccountNumber
            FROM Account 
            WHERE AccountNumber = :accountNumber
            WITH SECURITY_ENFORCED
        ];
    }

    public static Account getAccountById(Id accountId) {
        if (String.isBlank(accountId)) { return null; }

        List<Account> accounts = [
            SELECT Id, Name, LastModifiedDate
            FROM Account 
            WHERE Id = :accountId
            WITH SECURITY_ENFORCED
        ];

        return accounts.isEmpty() ? null : accounts[0];
    }

    public static List<Account> getAccountsByIds(Set<Id> accountIds) {
        if (accountIds.isEmpty()) { return null; }

        return [
            SELECT Id, Name, LastModifiedDate
            FROM Account 
            WHERE Id IN :accountIds
            WITH SECURITY_ENFORCED
        ];
    }
}