public with sharing class UserSelector {

    public static List<String> getActiveAdminsEmails() {
        List<String> emails = new List<String>();

        for (User user : [SELECT Email
                          FROM User
                          WHERE
                            Profile.Name = :Constants.PROFILE.SYSTEM_ADMINISTRATOR AND
                            IsActive = true]) {

            emails.add(user.Email);
        }

        return emails;
    }
}
