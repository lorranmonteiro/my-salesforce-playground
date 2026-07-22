@IsTest
public class UserFactory {

    public static User createUser() {
        return createUser(false);
    }

    public static User createUser(Boolean toInsert) {
        User user = new User(
            FirstName = TestHelper.generateRandomString(),
            LastName = TestHelper.generateRandomString(),
            Email = TestHelper.generateEmail(),
            Username = TestHelper.generateEmail(),
            ProfileId = Constants.getInstance().PROFILE.getAdminProfileId(),
            Alias = TestHelper.generateRandomString(8),
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );

        if (toInsert)
            insert user;

        return user;
    }

    public static void assignPermissionSetToUser(Id userId, String permissionSetName) {
        PermissionSet permissionSet = [SELECT Id FROM PermissionSet WHERE Name = :permissionSetName LIMIT 1];

        if (permissionSet == null)
            return;

        insert new PermissionSetAssignment(
            AssigneeId = userId,
            PermissionSetId = permissionSet.Id
        );
    }
}
