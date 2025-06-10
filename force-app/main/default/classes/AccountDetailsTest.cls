@isTest
public class AccountDetailsTest {

    @IsTest
    static void getAccountsByAccountNumber() {
        insert new Account(
            Name = 'Test Account',
            AccountNumber = '12345'
        );

        Test.startTest();
            List<Account> accounts = AccountDetails.getAccountsByAccountNumber('12345');
        Test.stopTest();

        Assert.areEqual('Test Account', accounts[0].Name, 'Account name should match');
    }
}