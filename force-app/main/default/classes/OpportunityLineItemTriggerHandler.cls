public class OpportunityLineItemTriggerHandler {
    
    public static void ProductInformation(List<OpportunityLineItem> lineItemList){

        Set<Id> oppIds = new Set<Id>();

        for(OpportunityLineItem oli : lineItemList){
            oppIds.add(oli.OpportunityId);
        }

        Map<Id, String> oppMap = new Map<Id, String>();

        for(Opportunity opp : [SELECT Id,(SELECT Id,Product2.Name FROM OpportunityLineItems) FROM Opportunity WHERE Id IN :oppIds]){
            
            List<String> productNames = new List<String>();

            for(OpportunityLineItem oliname : opp.OpportunityLineItems){
                productNames.add(oliname.Product2.Name);
            }

            oppMap.put(opp.Id,String.join(productNames, ','));
        }

        List<Opportunity> opportunityList = new List<Opportunity>();

        for(Id oppId : oppMap.keySet()){
            Opportunity obj = new Opportunity(Id = oppId, Products_List__c = oppMap.get(oppId));
            opportunityList.add(obj);
        }

        if(!opportunityList.isEmpty()){
            update opportunityList;
        }
    }
}