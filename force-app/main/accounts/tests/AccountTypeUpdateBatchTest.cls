@IsTest
public class AccountTypeUpdateBatchTest {

    private static final Integer BATCH_SIZE = 200;
    private static final Integer ACCOUNTS_TO_INSERT = 5;

    @IsTest
    static void accountUpdateTypesBatchWithSuccess() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < ACCOUNTS_TO_INSERT; i++) {
            Account account = TestAccountFactory.createAccount();
            account.Type = Constants.getInstance().ACCOUNT.TYPE.PROSPECT;

            accounts.add(account);
        }
        insert accounts;

        Test.startTest();
            Database.executeBatch(new AccountTypeUpdateBatch(), BATCH_SIZE);
        Test.stopTest();

        Account updatedAccountSample = [SELECT Type FROM Account WHERE Id IN :accounts LIMIT 1];

        Assert.areEqual(Constants.getInstance().ACCOUNT.TYPE.CUSTOMER_DIRECT, updatedAccountSample.Type, 'Account Type should be updated to Customer');
    }

    @IsTest
    static void accountUpdateTypesBatchWithErrors() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < ACCOUNTS_TO_INSERT; i++) {
            Account account = TestAccountFactory.createAccount();
            account.Type = Constants.getInstance().ACCOUNT.TYPE.PROSPECT;

            accounts.add(account);
        }

        Account account = TestAccountFactory.createAccount();
        account.Type = Constants.getInstance().ACCOUNT.TYPE.OTHER;
        accounts.add(account);

        insert accounts;

        Test.startTest();
            Database.executeBatch(new AccountTypeUpdateBatch(), 200);
        Test.stopTest();

        Account updatedAccountSample = [SELECT Type FROM Account WHERE Id IN :accounts AND Name != 'Account with type Other' LIMIT 1];

        Assert.areEqual(Constants.getInstance().ACCOUNT.TYPE.CUSTOMER_DIRECT, updatedAccountSample.Type, 'Account Type should be updated to Customer');
    }
}
