@IsTest
private class AccountSelectorTest {

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
    static void getAllAccounts() {
        TestAccountFactory.createAccount(true);

        Test.startTest();
            List<Account> accounts = AccountSelector.getAllAccounts();
        Test.stopTest();

        Assert.isTrue(accounts.size() == 1, 'Expected exactly one account');
    }

    @IsTest
    static void getAccountsByTypes() {
        Account prospectAccount = TestAccountFactory.createAccount();
        prospectAccount.Type = Constants.getInstance().ACCOUNT.TYPE.PROSPECT;

        Account otherAccount = TestAccountFactory.createAccount();
        otherAccount.Type = Constants.getInstance().ACCOUNT.TYPE.OTHER;

        Account customerAccount = TestAccountFactory.createAccount();
        customerAccount.Type = Constants.getInstance().ACCOUNT.TYPE.CUSTOMER_DIRECT;

        insert new List<Account> { prospectAccount, otherAccount, customerAccount };

        Test.startTest();
            List<Account> accounts = AccountSelector.getAccountsByTypes(new Set<String> {
                Constants.getInstance().ACCOUNT.TYPE.PROSPECT,
                Constants.getInstance().ACCOUNT.TYPE.OTHER
            });
        Test.stopTest();

        Assert.areEqual(2, accounts.size(), 'Should return accounts matching the requested types');
    }

    @IsTest
    static void getAccountsByTypesWithEmptyTypes() {
        TestAccountFactory.createAccount(true);

        Test.startTest();
            List<Account> accounts = AccountSelector.getAccountsByTypes(new Set<String>());
        Test.stopTest();

        Assert.isTrue(accounts.isEmpty(), 'No accounts should be returned when no types are provided');
    }

    @IsTest
    static void getAccountsByTypesQueryLocator() {
        Test.startTest();
            Database.QueryLocator queryLocator = AccountSelector.getAccountsByTypesQueryLocator(new Set<String> {
                Constants.getInstance().ACCOUNT.TYPE.PROSPECT,
                Constants.getInstance().ACCOUNT.TYPE.OTHER
            });
        Test.stopTest();

        Assert.isNotNull(queryLocator, 'Query locator should be returned for batch processing');
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
