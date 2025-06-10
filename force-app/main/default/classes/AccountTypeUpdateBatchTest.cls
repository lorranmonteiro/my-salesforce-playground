@isTest
public class AccountTypeUpdateBatchTest {

    private static final Integer BATCH_SIZE = 200;
    private static final Integer ACCOUNTS_TO_INSERT = 5;

    @isTest
    static void accountUpdateTypesBatchWithSuccess() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < ACCOUNTS_TO_INSERT; i++) {
            accounts.add(new Account(
                Name = 'Test Account ' + i,
                Type = Constants.ACCOUNT.TYPE.PROSPECT)
            );
        }
        insert accounts;

        Test.startTest();
            Database.executeBatch(new AccountTypeUpdateBatch(), 200);
        Test.stopTest();

        Account updatedAccountSample = [SELECT Type FROM Account WHERE Id IN :accounts LIMIT 1];

        Assert.areEqual(Constants.ACCOUNT.TYPE.CUSTOMER_DIRECT, updatedAccountSample.Type, 'Account Type should be updated to Customer');
    }

    @isTest
    static void accountUpdateTypesBatchWithErrors() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < ACCOUNTS_TO_INSERT; i++) {
            accounts.add(new Account(
                Name = 'Test Account ' + i,
                Type = Constants.ACCOUNT.TYPE.PROSPECT)
            );
        }

        accounts.add(new Account(
            Name = 'Account with type Other',
            Type = Constants.ACCOUNT.TYPE.OTHER)
        );

        insert accounts;

        Test.startTest();
            Database.executeBatch(new AccountTypeUpdateBatch(), 200);
        Test.stopTest();

        Account updatedAccountSample = [SELECT Type FROM Account WHERE Id IN :accounts AND Name != 'Account with type Other' LIMIT 1];

        Assert.areEqual(Constants.ACCOUNT.TYPE.CUSTOMER_DIRECT, updatedAccountSample.Type, 'Account Type should be updated to Customer');
    }
}