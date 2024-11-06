@isTest
public class LeadTriggerHandlerTest {

    @TestSetup
    static void testData(){
        List<Lead> leads = new List<Lead>();

        leads.add(new Lead(LastName = 'One', Company = 'One', LeadSource = 'Web', Status = 'Open - Not Contacted'));
        leads.add(new Lead(LastName = 'Two', Company = 'Two', LeadSource = 'Other', Status = 'Open - Not Contacted'));

        insert leads;
    }

    @isTest
    static void ifSource(){
        List<Lead> leadList = [SELECT Id,LastName,Company,LeadSource,Status FROM Lead];

        LeadTriggerHandler.sourceBasedRating(leadList);

        update leadList;

        List<Lead> newLeadList = [SELECT Id, LastName, Company, LeadSource, Rating FROM Lead];

        for(Lead ld : newLeadList){
            if(ld.LeadSource != ''){
                if(ld.LeadSource == 'Web'){
                    Assert.areEqual('Cold',ld.Rating,'Error');
                }else{
                    Assert.areEqual('Hot',ld.Rating, 'Error');
                }
            }
        }
    }
}