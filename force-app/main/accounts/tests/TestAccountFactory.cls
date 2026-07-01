@IsTest
public class TestAccountFactory {

    public static Boolean bypassTriggers = true;

    public static Account createAccount() {
        return createAccount(false);
    }

    public static Account createAccount(Boolean toInsert) {
        Account account = new Account(
            Name = TestHelper.generateRandomString(),
            AccountNumber = TestHelper.generateRandomNumericString()
        );

        if (toInsert) {
            if (bypassTriggers) { TriggerHandler.bypassAllTriggers = true; }
                insert account;
            if (bypassTriggers) { TriggerHandler.bypassAllTriggers = false; }
        }

        return account;
    }
}
