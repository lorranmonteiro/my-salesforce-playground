@IsTest
private class EmailNotificationServiceTest {

    @IsTest
    static void sendAccountTypeUpdateBatchResults() {
        insert createAdminUser(TestHelper.generateEmail());

        Test.startTest();
            EmailNotificationService.sendAccountTypeUpdateBatchResults(
                'someJobId',
                10,
                new List<String> { 'Sample error message' }
            );
            Integer emailInvocations = Limits.getEmailInvocations();
        Test.stopTest();

        Assert.areEqual(1, emailInvocations, 'One email should be sent to active admins');
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
}
