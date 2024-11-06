@isTest
public class CaseTriggerHandlerTest {

    @TestSetup
    static void testSetup(){

        List<Case> cases = new List<Case>();

        cases.add(new Case(Origin = 'Email',Status = 'Working',Priority = 'Low'));
        cases.add(new Case(Origin = 'Email',Status = 'Escalated',Priority = 'High'));
        
        insert cases;
    }

    @isTest
    static void ifCase(){

        List<Case> caseList = [SELECT Id, Origin, Status, Priority FROM Case];

        CaseTriggerHandler.originBasedStatusAndPriority(caseList);

        update caseList;

        List<Case> updatedList = [SELECT Id, Origin, Status, Priority FROM Case];

        for(Case cs : updatedList){
            if(cs.Origin == 'Email'){
                Assert.areEqual('New',cs.Status,'error');
                Assert.areEqual('Medium',cs.Priority,'error');
            }
        }
    }


    @isTest
    static void latestCaseNumberTest(){

        Account acc = new Account(Name = 'Test Account');
        insert acc;

        List<Case> caseList = new List<Case>();

        caseList.add(new Case(Status = 'New', Origin = 'Phone', AccountId = acc.Id));

        insert caseList;

        Test.startTest();
        CaseTriggerHandler.latestCaseNumber(caseList);
        Test.stopTest();

        update caseList;

        Set<Id> accIds = new Set<Id>();
        for(Case cs : [SELECT CaseNumber, AccountId FROM Case WHERE AccountId != null]){
            accIds.add(cs.AccountId);
        } 

        for(Account accId : [SELECT Id,LatestCaseNumber__c,(SELECT CaseNumber FROM Cases ORDER BY CaseNumber DESC LIMIT 1) FROM Account WHERE Id IN :accIds]){
            Assert.areEqual(accId.LatestCaseNumber__c, accId.Cases[0].CaseNumber,'Number doesnt match');
        }
    }
}