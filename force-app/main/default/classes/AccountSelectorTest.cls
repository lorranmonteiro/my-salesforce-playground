@isTest
public class AccountSelectorTest {

    @IsTest
    static void getAccountsByAccountNumber() {
        Account account = TestAccountFactory.createAccount(true);

        Test.startTest();
            List<Account> accounts = AccountSelector.getAccountsByAccountNumber(account.AccountNumber);
        Test.stopTest();

        Assert.areEqual(account.Name, accounts[0].Name, 'Account name should match');
    }

    @IsTest
    static void getAccountsByNonExistingAccountNumber() {
        TestAccountFactory.createAccount(true);

        Test.startTest();
            List<Account> accounts = AccountSelector.getAccountsByAccountNumber('99999');
        Test.stopTest();

        Assert.isTrue(accounts.isEmpty(), 'No accounts should be returned for non-existing account number');
    }

    @IsTest
    static void getAccountById() {
        Account account = TestAccountFactory.createAccount(true);

        Test.startTest();
            Account createdAccount = AccountSelector.getAccountById(account.Id);
        Test.stopTest();

        Assert.areEqual(account.Name, createdAccount.Name, 'Account name should match');
    }

    @IsTest
    static void getAccountsByIds() {
        Account account1 = TestAccountFactory.createAccount(true);
        Account account2 = TestAccountFactory.createAccount(true);

        Test.startTest();
            List<Account> createdAccounts = AccountSelector.getAccountsByIds(new Set<Id>{ account1.Id, account2.Id });
        Test.stopTest();

        Assert.areEqual(2, createdAccounts.size(), 'Should return two accounts');
    }
}