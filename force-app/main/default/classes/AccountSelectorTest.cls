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
}