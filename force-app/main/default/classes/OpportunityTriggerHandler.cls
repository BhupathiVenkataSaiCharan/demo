public class OpportunityTriggerHandler {
    
    //if opp ammount is not null and is >100000 then populate the description as hot opportunity
    public static void descAsHotOpportuntiy(List<Opportunity> newList){

        for(Opportunity opp : newList){
            if(opp.Amount != null && opp.Amount > 100000){
                opp.Description = 'Hot Opportunity';
            }
        }
    }


    //latest opportunity amount on related account
    public static void latestOppAmount(List<Opportunity> newList){

        Set<Id> accIds = new Set<Id>();
        for(Opportunity opp : newList){
            if(opp.AccountId != null){
                accIds.add(opp.AccountId);
            }
        }

        List<Account> accList = new List<Account>();
        for(Opportunity opp : [SELECT Amount, AccountId FROM Opportunity WHERE AccountId IN :accIds ORDER BY Amount ASC LIMIT 1]){

            Account acc = new Account(
                Id = opp.AccountId,
                LatestOppAmount__c = opp.Amount
            );
            accList.add(acc);
        }

        update accList;
    }

}