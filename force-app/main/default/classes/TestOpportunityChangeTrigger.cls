@isTest
public class TestOpportunityChangeTrigger {

    //@isTest
    static void testCreateAndUpdateOpportunity() {
        Test.enableChangeDataCapture();

        insert new Opportunity(Name = 'Sell 100 Widgets',
                               StageName = 'Prospecting',
                               CloseDate = Date.today().addMonths(3));

        Test.getEventBus().deliver();

        Opportunity opportunity = [SELECT Id,StageName FROM Opportunity LIMIT 1];

        opportunity.StageName = 'Closed Won';
        update opportunity;

        Test.getEventBus().deliver();

        Task[] taskList = [SELECT Id,Subject FROM Task];
        System.assertEquals(1, taskList.size(), 'The change event trigger did not create the expected task.');
    }
}