public class CaseTriggerHandler {
    
    //if origin is email status as new and priority as medium
    public static void originBasedStatusAndPriority(List<Case> newList){
        for(Case cs : newList){
            if(cs.Origin == 'Email'){
                cs.Status = 'New';
                cs.Priority = 'Medium';
            }
        }
    }

    //update the latest case number on related account
    public static void latestCaseNumber(List<Case> newList){
        
        Set<Id> accIds = new Set<Id>();
        for(Case cs : newList){
            if(cs.AccountId != null){
                accIds.add(cs.AccountId);
            }
        }

        List<Account> accList = new List<Account>();
        for(Case cs : [SELECT CaseNumber,AccountId FROM Case WHERE AccountId IN :accIds ORDER BY CreatedDate DESC LIMIT 1]){
            accList.add(new Account(Id=cs.AccountId,LatestCaseNumber__c = cs.CaseNumber));
        }

        update accList;
    }
}