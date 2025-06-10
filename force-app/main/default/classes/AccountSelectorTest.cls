@isTest
public class AccountSelectorTest {

    @IsTest
    static void getAccountsByAccountNumber() {
        insert new Account(
            Name = 'Test Account',
            AccountNumber = '12345'
        );

        Test.startTest();
            List<Account> accounts = AccountSelector.getAccountsByAccountNumber('12345');
        Test.stopTest();

        Assert.areEqual('Test Account', accounts[0].Name, 'Account name should match');
    }

    @IsTest
    static void getAccountsByNonExistingAccountNumber() {
        insert new Account(
            Name = 'Test Account',
            AccountNumber = '12345'
        );

        Test.startTest();
            List<Account> accounts = AccountSelector.getAccountsByAccountNumber('99999');
        Test.stopTest();

        Assert.isTrue(accounts.isEmpty(), 'No accounts should be returned for non-existing account number');
    }

    @IsTest
    static void getAccountById() {
        Account account = new Account(
            Name = 'Test Account',
            AccountNumber = '12345'
        );
        insert account;

        Test.startTest();
            Account createdAccount = AccountSelector.getAccountById(account.Id);
        Test.stopTest();

        Assert.areEqual(account.Name, createdAccount.Name, 'Account name should match');
    }

    @IsTest
    static void getAccountsByIds() {
        Account account1 = new Account(
            Name = 'Test Account 1',
            AccountNumber = '1234533'
        );
        Account account2 = new Account(
            Name = 'Test Account 2',
            AccountNumber = '12345'
        );
        insert new List<Account>{ account1, account2 };

        Test.startTest();
            List<Account> createdAccounts = AccountSelector.getAccountsByIds(new Set<Id>{ account1.Id, account2.Id });
        Test.stopTest();

        Assert.areEqual(2, createdAccounts.size(), 'Should return two accounts');
    }
}