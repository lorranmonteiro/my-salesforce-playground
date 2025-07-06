@isTest
public class AccountDetailsTest {

    @IsTest
    static void getAccountsByAccountNumber() {
        Account account = TestAccountFactory.createAccount(true);

        Test.startTest();
            List<Account> accounts = AccountDetails.getAccountsByAccountNumber(account.AccountNumber);
        Test.stopTest();

        Assert.areEqual(account.Name, accounts[0].Name, 'Account name should match');
    }
}