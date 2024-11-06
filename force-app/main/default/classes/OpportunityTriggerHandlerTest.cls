@isTest
public class OpportunityTriggerHandlerTest {
    
    @isTest
    static void descAsHotOpportuntiyTest(){
        List<Opportunity> oppList = new List<Opportunity>();

        oppList.add(new Opportunity(Name = 'opp1',Amount = 100000, closeDate = Date.today(), StageName = 'Closed Won'));
        oppList.add(new Opportunity(Name = 'opp1',Amount = 300000, closeDate = Date.today(), StageName = 'Closed Lost'));

        insert oppList;

        OpportunityTriggerHandler.descAsHotOpportuntiy(oppList);

        update oppList;

        List<Opportunity> updatedList = [SELECT Id, Name, Amount,Description FROM Opportunity WHERE Amount>100000 ];

        for(Opportunity opp : updatedList){
            if(opp.Amount != null && opp.Amount > 100000){
                Assert.areEqual('Hot Opportunity', opp.Description,'Description does not match');
            }
        }
    }
}