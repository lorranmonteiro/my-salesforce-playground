@isTest
private class UserSelectorTest {

    @isTest
    static void getActiveAdminsEmails() {
        String adminEmail = TestHelper.generateEmail();
        User adminUser = createAdminUser(adminEmail);
        insert adminUser;

        Test.startTest();
            List<String> emails = UserSelector.getActiveAdminsEmails();
        Test.stopTest();

        Assert.isFalse(emails.isEmpty(), 'Active admin emails should be returned');
        Assert.isTrue(containsEmail(emails, adminEmail), 'Created admin user email should be returned');
    }

    private static User createAdminUser(String email) {
        Profile adminProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = :Constants.PROFILE.SYSTEM_ADMINISTRATOR
            LIMIT 1
        ];

        return new User(
            Alias = 'tadmin',
            Email = email,
            EmailEncodingKey = 'UTF-8',
            LastName = 'Admin',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            IsActive = true,
            ProfileId = adminProfile.Id,
            TimeZoneSidKey = 'America/Sao_Paulo',
            UserName = TestHelper.generateRandomString() + DateTime.now().getTime() + '@mail.com'
        );
    }

    private static Boolean containsEmail(List<String> emails, String expectedEmail) {
        for (String email : emails) {
            if (email != null && email.equalsIgnoreCase(expectedEmail)) {
                return true;
            }
        }

        return false;
    }
}
